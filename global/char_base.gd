class_name CharBase
extends CharacterBody2D

@onready var animation_player = $AnimationPlayer


@onready var base_status_ui = $BaseStatusUI
@onready var health_ui = $BaseStatusUI/Health
@onready var block_ui = $BaseStatusUI/Block

@export var label: String
@export var max_health: int = 50
@export var alive: bool = true
@export var enemy: bool = true

@onready var health = max_health

var block: int = 0

var enemies = null
var player = null
var everyone = null

var tween: Tween

var sfx
var player_status_ui


func _ready():
	animation_player.play("Idle")
	update_health()
	update_block()
	
	enemies = get_tree().get_nodes_in_group('enemy')
	player = get_tree().get_first_node_in_group('player')
	everyone = enemies + [player]
	
	sfx = Actions.sfx
	player_status_ui = Actions.status_ui
	
	_ready_and()

func update_block():
	block_ui.get_node('Data').text = str(block)


func update_health():
	health_ui.get_node('Data').text = str(max_health)
	health_ui.get_node('cur').text = str(health)


func get_block(value: int):
	block += value
	update_block()
	sfx.get_node('BlockSFX').play()

func reset_block():
	block = 0
	update_block()
	

func heal(value: int):
	health = clampi(health+value, health, max_health)
	update_health()
	sfx.get_node('HealSFX').play()


func receive_damage(value: int):
	if value <= block:
		block -= value
		update_block()
		sfx.get_node('BlockSFX').play()
	else:
		var true_damage = value - block
		health = clampi(health - true_damage, 0, Actions.MAX_DATA)
		update_health()
		block = 0
		update_block()
		damage_sfx()
		
		animation_player.play("hurt")
		
		# statu change
		var new_label = Label.new()
		new_label.text = '-'+str(true_damage)
		new_label.set("theme_override_colors/font_color", Color.RED)
		new_label.set("theme_override_font_sizes/font_size", 30)
		get_node("StatuChange").add_child(new_label)
		await Funcs.slowly_up(new_label)
		new_label.queue_free()
		
		if health <= 0:
			self.alive = false
			sfx.get_node('DeathSFX').play()
			animation_player.play("die")
			await animation_player.animation_finished
			after_die()
			return
		else:
			pass
		await animation_player.animation_finished
		animation_player.play("Idle")	

func fresh_health():
	base_status_ui.get_node("Health/Data").text = str(max_health)
	base_status_ui.get_node("Health/cur").text = str(health)


func after_die():
	pass

func _ready_and():
	pass

func damage_sfx():
	pass
