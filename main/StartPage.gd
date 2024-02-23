extends Control


@onready var curtain = $Curtain
@onready var next = $SelectChar/next
@onready var showcase = $SelectChar/showcase
@onready var ready_place = $SelectChar/Ready
@onready var last = $SelectChar/last
@onready var select_char = $SelectChar
@onready var select_dice = $SelectDice
@onready var confirm_char = $confirm_char

@export var players: Array[Character]


# Called when the node enters the scene tree for the first time.
func _ready():
	curtain.hide()
	
	for child in showcase.get_children():
		child.init()
	for child in ready_place.get_children():
		child.init()
	
	#curtain.set("modulate", Color.TRANSPARENT)
	#curtain.show()

var curtain_tween: Tween
func _on_button_pressed():
	Funcs.SFX.get_node("button").play()
	next.disabled = true
	curtain.set("modulate", Color.TRANSPARENT)
	curtain.show()
	curtain_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	curtain_tween.tween_property(curtain, "modulate", Color.WHITE, 0.3)
	
	await curtain_tween.finished
	showcase.get_child(0).reparent(ready_place)
	ready_place.get_child(0).reparent(showcase)
	
	curtain_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	curtain_tween.tween_property(curtain, "modulate", Color.TRANSPARENT, 0.3)
	await curtain_tween.finished
	curtain.hide()
	next.disabled = false


func _on_last_pressed():
	Funcs.SFX.get_node("button").play()
	last.disabled = true
	curtain.set("modulate", Color.TRANSPARENT)
	curtain.show()
	curtain_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	curtain_tween.tween_property(curtain, "modulate", Color.WHITE, 0.3)
	
	await curtain_tween.finished
	var cur_char = showcase.get_child(0)
	cur_char.reparent(ready_place)
	ready_place.move_child(cur_char, 0)
	ready_place.get_child(-1).reparent(showcase)
	
	curtain_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	curtain_tween.tween_property(curtain, "modulate", Color.TRANSPARENT, 0.3)
	await curtain_tween.finished
	curtain.hide()
	last.disabled = false


var confirm_stage = 0


func _on_confirm_char_pressed():
	if confirm_stage == 0:
		confirm_stage = 1
		confirm_char.disabled = true
		Funcs.SFX.get_node("button").play()
		curtain.set("modulate", Color.TRANSPARENT)
		curtain.show()
		curtain_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		curtain_tween.tween_property(curtain, "modulate", Color.WHITE, 0.3)
		await curtain_tween.finished
		select_char.hide()
		
		curtain_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		curtain_tween.tween_property(curtain, "modulate", Color.TRANSPARENT, 0.3)
		await curtain_tween.finished
		select_dice.show()
		curtain.hide()
		#select_dice.show()
