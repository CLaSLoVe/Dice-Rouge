extends Control

@export var connection: Effect.FromStatu

@onready var label = $content/label
@onready var init_var = $content/init_var
@onready var add_var = $content/add_var
@onready var add_ = $content/add_


var character

var add_value
		

func _ready():
	Event.attr_changed.connect(reset)




func reset():
	var player = character
	match connection:
		Effect.FromStatu.STRENTH:
			label.text = "[color=yellow]力量"
			init_var.text = str(player.init_strenth)
			add_value = player.add_strenth
			label.tooltip_text = "影响攻击时造成的伤害"
		Effect.FromStatu.DEFENCE:
			label.text = "[color=skyblue]防御"
			init_var.text = str(player.init_defence)
			add_value = player.add_defence
			label.tooltip_text = "影响格挡时获得的护盾"
		Effect.FromStatu.MEDICAL:
			label.text = "[color=green]治愈"
			init_var.text = str(player.init_medical)
			add_value = player.add_medical
			label.tooltip_text = "影响治疗时获得的回复"
	if add_value > 0:
		add_.text = "[color=green]+"
		add_var.text = "[color=green]"+str(add_value)
	elif add_value < 0:
		add_.text = "[color=red]-"
		add_var.text = "[color=red]"+str(-add_value)
	else:
		add_.text = ""
		add_var.text = ""
