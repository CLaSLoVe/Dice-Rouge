extends VBoxContainer

@onready var rich_text_label = $RichTextLabel
@onready var texture_rect = $texturebox/TextureRect
@onready var buttonlabel = $buttonbox/Button/buttonlabel
@onready var button = $buttonbox/Button


@export var label: String
@export var texture:Texture
@export_multiline var text: String
@export var button_label: String
@export var p: int = 1

func _ready():
	texture_rect.texture = texture
	rich_text_label.text = text
	buttonlabel.text = button_label


func _on_button_pressed():
	button.disabled = true
	Event.award_selected.emit(label)
