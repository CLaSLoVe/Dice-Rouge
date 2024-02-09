extends Control


@export var related_buff: Buff
@export var value: int
@onready var icon = $Icon
@onready var countdown_label = $countdown_label
@onready var detail = $Panel/detail
@onready var panel = $Panel

var countdown = null

var player = null


func _ready():
	if not related_buff.on_turn:
		countdown_label.set("theme_override_colors/font_color", Color.RED)
	icon.texture = related_buff.icon
	countdown = related_buff.countdown
	countdown_label.text = str(countdown)
	self.set("modulate", Color.TRANSPARENT)
	panel.set("modulate", Color.TRANSPARENT)


func set_text():
	if related_buff.description.size() >= 2:
		if value < 0:
			detail.text = related_buff.description[0] + str(-value) + related_buff.description[1]
		else:
			detail.text = related_buff.description[0] + str(value) + related_buff.description[1]
	
	
	Events.shot_end.connect(_on_press_shot)
	
#func set_value(v):
	#value = v
	#if v > 0:
		#detail.text = '+'+str(value)
	#elif v < 0:
		#detail.text = str(value)
	#else:
		#self.queue_free()

func update_countdown():
	countdown_label.text = str(countdown)
	if countdown > 0:
		return
	await Funcs.slowly_hide(self)
	self.free()

	
	
	
func _on_press_shot():
	var player = get_tree().get_first_node_in_group('player')
	if related_buff.rely_on == Skill.Rely.HEALTH:
		if value < 0:
			player.receive_damage(-value)
			self.set("modulate", Color.RED)
			await get_tree().create_timer(0.3).timeout
			self.set("modulate", Color.WHITE)
			countdown -= 1
			update_countdown()
		elif value > 0:
			player.heal(value)


func _on_area_2d_mouse_entered():
	Funcs.slowly_show(panel)
	


func _on_area_2d_mouse_exited():
	Funcs.slowly_hide(panel)
