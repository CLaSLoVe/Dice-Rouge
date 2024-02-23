extends Control

@onready var status = $Status
@onready var awards_inactive = $AwardsInactive
@onready var awards_active = $AwardsActive
@onready var curtain = $Curtain
@onready var book = $Curtain/book

var num_awards = 3


func _ready():
	Event.award_selected.connect(_on_award_selected)
	#Event.init_award.connect(_on_init_award)
	curtain.hide()
	#set_awards()
	



func init():
	for statu in status.get_children():
		statu.font_size = 50
		statu.is_init = true
		statu.set_character(get_tree().get_first_node_in_group("player"))
		statu.reset()
		
	set_awards()
		

func set_awards():
	var p: Array[int]
	var awards = []
	for award in awards_inactive.get_children():
		p.append(award.p)
		awards.append(award)
	var selected_awards = Funcs.select_n_with_p(awards, num_awards, p)
	for child in selected_awards:
		child.reparent(awards_active)
		if child.label == 'null':
			child.button.disabled = true
	

func _on_next_pressed():
	Event.next_turn_start.emit()
	for child in awards_active.get_children():
		child.reparent(awards_inactive)
		child.button.disabled = false
	for child in curtain.get_children():
		if child.name != 'button':
			child.hide()
	#技能放回去，如果有的话
	for child in book.get_node("skillselector").get_children():
		if child.get_node('cbox').get_children():
			child.get_node('cbox').get_child(0).reparent(get_tree().get_first_node_in_group('inactive_skills'))
	curtain.hide()
	Event.init_award.emit()
	
var curtain_tween: Tween
var fade_seconds = 0.3

@onready var relic = $Curtain/relic


func _on_award_selected(label):
	# 拉上幕布
	var player = get_tree().get_first_node_in_group('player')
	curtain.set('modulate', Color.TRANSPARENT)
	curtain.show()
	curtain_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	curtain_tween.tween_property(curtain, "modulate", Color.WHITE, fade_seconds)
	await curtain_tween.finished
	
	# 奖励放回去
	for child in awards_active.get_children():
		child.reparent(awards_inactive)
		child.button.disabled = false
	# 展示界面
	for child in curtain.get_children():
		if child.name == label or child.name == 'button':
			child.show()
		else:
			child.hide()
	# 执行界面
	match label:
		'relic':
			relic.init()
		'water':
			player.heal(9999)
			Event.attr_changed.emit()
		'book':
			book.init()
		
	
