extends VBoxContainer

@onready var rich_text_label = $RichTextLabel
@onready var texture_rect = $TextureRect
@onready var button = $Button
@onready var show_label = $Button/Label

@export var award: Award

var label = null


func _ready():
	texture_rect.texture = award.icon
	show_label.text = award.show_label
	rich_text_label.text = '[center][color=black]'+award.description
	label = award.label

func reset():
	button.disabled = false



func _on_button_pressed():
	button.disabled = true
	Actions.sfx.get_node("AwardSFX").play()
	Events.award_choice.emit(label)
