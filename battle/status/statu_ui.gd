extends HBoxContainer

@export var statu: Statu

@onready var icon = $Icon
@onready var data = $Data
@onready var label = $Label



func _ready():
	icon.texture = statu.statu_icon
	label.text = statu.statu_name
	#data.text = statu.init_data
	label.set("theme_override_colors/font_color", statu.color)
	#data.set("theme_override_colors/font_color", statu.color)

func reset():
	icon.texture = statu.statu_icon
	label.text = statu.statu_name
	#data.text = statu.init_data
	label.set("theme_override_colors/font_color", statu.color)
