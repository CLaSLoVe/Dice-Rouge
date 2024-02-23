extends Control

enum Type {STRENTH, DEFENCE, MEDICAL, MONEY, HEALTH}

var is_init: bool= false


@export var connection: Type
@onready var label = $content/label
@onready var init_var = $content/init_var
@onready var add_var = $content/add_var
@onready var add_ = $content/add_

var font_size:int= 16


var add_value


var init_strenth = 0
var init_defence = 0
var init_medical = 0

var add_strenth = 0
var add_defence = 0
var add_medical = 0

var cur_health = 0
var max_health = 0

var this_character

func _ready():
	Event.attr_changed.connect(reset)

func set_character(character):
	this_character = character
	init_strenth = character.init_strenth
	init_defence = character.init_defence
	init_medical = character.init_medical
	
	add_strenth = character.add_strenth
	add_defence = character.add_defence
	add_medical = character.add_medical
	
	cur_health = character.cur_health
	max_health = character.max_health
	


func reset():
	if this_character:
		set_character(this_character)
	label.set("theme_override_font_sizes/normal_font_size", font_size)
	init_var.set("theme_override_font_sizes/normal_font_size", font_size)
	add_var.set("theme_override_font_sizes/normal_font_size", font_size)
	add_.set("theme_override_font_sizes/normal_font_size", font_size)
	match connection:
		Type.STRENTH:
			label.text = "[color=orange]力量"
			init_var.text = str(init_strenth)
			add_value = add_strenth
			label.tooltip_text = "影响攻击时造成的伤害"
		Type.DEFENCE:
			label.text = "[color=skyblue]防御"
			init_var.text = str(init_defence)
			add_value = add_defence
			label.tooltip_text = "影响格挡时获得的护盾"
		Type.MEDICAL:
			label.text = "[color=green]治愈"
			init_var.text = str(init_medical)
			add_value = add_medical
			label.tooltip_text = "影响治疗时获得的回复"
		Type.MONEY:
			label.text = "[color=yellow]金币"
			init_var.text = str(Funcs.COUNTER.cur_money)
			label.tooltip_text = "可以用于学习技能等"
			add_.text = ''
			return
		Type.HEALTH:
			label.text = "[color=Indianred ]生命"
			init_var.text = str(cur_health)
			add_.text = '/'
			add_value = max_health
			add_var.text = str(add_value)
			label.tooltip_text = "生命值"
			return
	if is_init:
		if add_.text == '+':
			add_.text = ''
			add_var.text = ''
		return
	if add_value > 0:
		add_.text = "[color=green]+"
		add_var.text = "[color=green]"+str(add_value)
	elif add_value < 0:
		add_.text = "[color=red]-"
		add_var.text = "[color=red]"+str(-add_value)
	else:
		add_.text = ""
		add_var.text = ""
	
