extends Control

@onready var texture_rect = $TextureRect
@onready var status = $Status
@onready var intro = $Intro
@onready var dices_box = $Dices
@onready var label = $label
@onready var job = $job


@export var character:Character
@export var init_strenth: int = 5
@export var init_defence: int = 5
@export var init_medical: int = 6
@export var damage: int = 0
@export var max_health: int = 20

func init():
	texture_rect.texture = character.icon
	label.text = character.char_name
	for statu in status.get_children():
		statu.font_size = 50
		statu.is_init = true
		statu.init_strenth = init_strenth
		statu.init_defence = init_defence
		statu.init_medical = init_medical
		statu.cur_health = max_health - damage
		statu.max_health = max_health
		intro.text = character.intro
		statu.reset()
	match character.job_name:
		'flip':
			job.text = '[color=Orchid]职业技能[/color]\n[font_size=40]将骰子翻面'
		'shuffle':
			job.text = '[color=Orchid]职业技能[/color]\n[font_size=40]重新投掷骰子'
		'attack':
			job.text = '[color=Orchid]职业技能[/color]\n[font_size=40]将骰子临时改变为攻击'
		
	for i in range(character.dices.size()):
		dices_box.get_child(i).id = i+1
		dices_box.get_child(i).dice = character.dices[i]
		dices_box.get_child(i).get_node('DiceMiniUI').set_dice(character.dices[i])
		
	
