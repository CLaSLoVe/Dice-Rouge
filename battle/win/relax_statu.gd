extends HBoxContainer
@onready var _icon = $Icon
@onready var _label = $Label
@onready var _data = $Data

@export var id: String
@export var icon: Texture
@export var label: String
@export var data: int
@export var color: Color

func _ready():
	_icon.texture = icon
	_label.text = label
	if data > 0:
		_data.text = '+'+str(data)
	else:
		_data.text = str(data)
	_label.set("theme_override_colors/font_color", color)


func update():
	if data > 0:
		_data.text = '+'+str(data)
	else:
		_data.text = str(data)
