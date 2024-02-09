extends CharBase

@export var strenth: int = 15
@export var defence: int = 10
@export var p: Array[int]

@export var skills: Array[EnemySkill]
@onready var desc_ui = $DescUI
@onready var desc_ui_label = $DescUI/Label

var next_action
var cur_strenth

var on_enemy_turn = false

func _ready_and():
	show_action()

func select_this():
	Events.select_enemy.emit(self)


func after_die():
	alive = false
	remove_from_group('enemy')
	enemies.erase(self)
	add_to_group('died_enemy')
	Actions.reselect_enemy()	
	Funcs.slowly_hide(self)
	#self.queue_free()
	


func show_action():
	next_action = skills[Funcs.rand_choice_with_p(p)]
	#next_action = skills[2]
	cur_strenth = randi_range(int(strenth*(1-next_action.variance)), int(strenth*(1+next_action.variance))+1)
	get_node('ActionUI/TextureRect').texture = next_action.icon
	
	if next_action.type == EnemySkill.Type.ATTACK:
		get_node('ActionUI/Label').text = str(cur_strenth)
		desc_ui_label.text = '将对你发动攻击'
	elif next_action.type == EnemySkill.Type.BLOCK:
		get_node('ActionUI/Label').text = str(defence)
		desc_ui_label.text = '将进行格挡'
	elif next_action.type == EnemySkill.Type.WEAK:
		desc_ui_label.text = '将对你施加负面效果'
		get_node('ActionUI/Label').text = ""
	elif next_action.type == EnemySkill.Type.BLEED:
		desc_ui_label.text = '将对你施加负面效果'
		get_node('ActionUI/Label').text = ""
	
func conduct_action():
	on_enemy_turn = true
	if next_action.type == EnemySkill.Type.ATTACK:
		var pos = self.position
		
		tween = get_tree().create_tween()
		tween.tween_property(self, "position", player.position-self.get_parent().position+Vector2(100,40), 0.1).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		
		animation_player.play("attack")
		await animation_player.animation_finished
		animation_player.play("Idle")
		tween = get_tree().create_tween()
		tween.tween_property(self, "position", pos, 0.2).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		
		await player.receive_damage(cur_strenth)
		
	elif next_action.type == EnemySkill.Type.BLOCK:
		self.get_block(defence)
	elif next_action.type == EnemySkill.Type.WEAK:
		player.get_buff(next_action, next_action.value)
	elif next_action.type == EnemySkill.Type.BLEED:
		player.get_buff(next_action, next_action.value)
	get_node('ActionUI/TextureRect').texture = null
	get_node('ActionUI/Label').text = ''
	on_enemy_turn = false
	
	# next round
	#strenth += 1

func damage_sfx():
	sfx.get_node('DamageSFX').play()

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("left_mouse"):
		select_this()


func _on_desc_area_mouse_entered():
	desc_ui.visible = true


func _on_desc_area_mouse_exited():
	desc_ui.visible = false
