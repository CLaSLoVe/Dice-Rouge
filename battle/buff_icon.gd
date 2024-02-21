extends Control

@onready var label = $Label
@onready var texture_rect = $TextureRect
@onready var poison = $poison
@onready var bleed = $bleed
@onready var animation_player = $AnimationPlayer
var effect: Effect
var countdown:int = 0
var character
var desc
var value

func _ready():
	poison.hide()
	bleed.hide()


func init():
	countdown = effect.countdown
	texture_rect.texture = effect.buff.icon
	desc = character.get_node("VBoxContainer/BuffContent/desc")


func reset():
	label.text = str(countdown)


func counting():
	countdown -= 1
	reset()
	if countdown <= 0:
		character.calc_buff()
		Event.buff_update.emit(character)
		exit()



func play(thing):
	match thing:
		"poison":
			Funcs.SFX.get_node("poison").play()
			poison.show()
		"bleed":
			Funcs.SFX.get_node("slash").play()
			bleed.show()
	animation_player.play(thing)
	await animation_player.animation_finished
	poison.hide()
	bleed.hide()
		

var exit_tween:Tween
const fade_seconds = 0.3
func exit():
	exit_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	exit_tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_seconds)
	await exit_tween.finished
	queue_free()

func _on_mouse_entered():
	texture_rect.set("modulate", Color.YELLOW)
	var text = ""
	for i in range(effect.tooltip.length()):
		match effect.tooltip[i]:
			'&':
				text += str(countdown)
			'B':
				text += str(effect.bias)
			_:
				text += effect.tooltip[i]
	desc.text = text


func _on_mouse_exited():
	texture_rect.set("modulate", Color.WHITE)
	desc.text = ""
