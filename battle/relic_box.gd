extends Control

@onready var icon = $Icon
@onready var desc = $desc
@onready var active = $active
@onready var animation_player = $AnimationPlayer

@export var relic: Relic

var heal_after_win = false

var count_damage = false
var receive_damage = 0


func _ready():
	active.hide()
	Event.win.connect(_on_after_win)
	Event.take_damage.connect(_on_receive_damage)
	icon.texture = relic.icon
	var n = 0
	var result = ""
	for i in range(relic.tooltip_text.length()):
		match relic.tooltip_text[i]:
			'&':
				result += str(relic.data_array[n])
				n += 1
			_:
				result += relic.tooltip_text[i]
	desc.text = result
	desc.set("modulate", Color.TRANSPARENT)


func init():
	var player = get_tree().get_first_node_in_group("player")
	var battle = get_tree().get_first_node_in_group("battle")
	match relic.text:
		'add_block':
			player.init_damage_per_turn += relic.data_array[0]
			battle.keep_block = true
		"keep_hand":
			battle.keep_hand = true
		"heal_after_win":
			heal_after_win = true
		"angry":
			count_damage = true
		"heavy_amour":
			player.max_take_damage = relic.data_array[0]
			player.min_take_damage = relic.data_array[1]
		"sharp":
			player.init_strenth -= 2
			player.make_bleed = true

func exit():
	var player = get_tree().get_first_node_in_group("player")
	var battle = get_tree().get_first_node_in_group("battle")
	match relic.text:
		'add_block':
			player.init_damage_per_turn -= relic.data_array[0]
			battle.keep_block = false
		"keep_hand":
			battle.keep_hand = false
		"heal_after_win":
			heal_after_win = false
		"heavy_amour":
			player.max_take_damage = 9999
			player.min_take_damage = 0
		"sharp":
			player.init_strenth += 2
			player.make_bleed = false
	

var tween: Tween

var fade_seconds = 0.2

func _on_icon_mouse_entered():
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(desc, "modulate", Color.WHITE, fade_seconds)


func _on_icon_mouse_exited():
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(desc, "modulate", Color.TRANSPARENT, fade_seconds)


var layer_win = 0

func _on_after_win(layer):
	if layer <= layer_win:
		return
	layer_win = layer
	if heal_after_win:
		await play()
		get_tree().get_first_node_in_group("player").heal(relic.data_array[0])

const ENHANCE = preload("res://resources/effects/enhance.tres")

func _on_receive_damage(character, value):
	if character.character.is_player and count_damage:
		receive_damage += value
		if receive_damage >= relic.data_array[0]:
			await play()
			character.do_action(ENHANCE, true)
			receive_damage = 0


func play():
	active.show()
	animation_player.play("active")
	await  animation_player.animation_finished
	active.hide()
