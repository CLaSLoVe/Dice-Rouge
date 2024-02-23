class_name DiceUI
extends Control

@export var dice: Dice
@export var id: int

@onready var dice_mini_ui = %DiceMiniUI
@onready var icon = %Icon
@onready var panel = %Panel
@onready var label = %Label

@onready var dice_base_state = $DiceStateMachine/DiceBaseState


@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var dice_state_machine: DiceStateMachine = $DiceStateMachine  

@onready var animation_player = $AnimationPlayer
@onready var magic = $Magic
@onready var burn = $Burn
@onready var change = $Change
@onready var mistake = $Mistake

const BASE_PANEL_STYLE = preload("res://battle/dice/dice_state_machine/base_panel_style.tres")
const HOVER_PANEL_STYLE = preload("res://battle/dice/dice_state_machine/hover_panel_style.tres")

const fade_seconds = 0.1

var current_num: int
var current_symbol: Symbol
var symbols_array: Array[Symbol]

var is_draggable: bool = true
var is_mouse_inside:bool = false
var is_burning = false

var mini_ui_show_hide_tween: Tween
var label_show_hide_tween: Tween

var on_area: Area2D


func init():
	dice_mini_ui.set("modulate", Color.TRANSPARENT)
	burn.hide()
	magic.hide()
	change.hide()
	
	dice_state_machine.init(self)
	dice_mini_ui.set_dice(dice)
	
	symbols_array = dice.symbols.duplicate()
	shuffle()
	
	#await get_tree().create_timer(1).timeout
	#make_change()
	#make_magic()
	#make_burn(true)


func make_cur_symbol():
	if not symbols_array:
		await ready
	current_symbol = symbols_array[current_num - 1]
	dice_mini_ui.select(current_num)
	icon.texture = current_symbol.icon
	self.tooltip_text = current_symbol.tooltip_text

func make_temp_symbol(symbol):
	current_symbol = symbol
	icon.texture = symbol.icon
	self.tooltip_text = symbol.tooltip_text


func shuffle():
	current_num = randi() % 6 + 1
	make_cur_symbol()

func reverse():
	current_num = 7 - current_num
	make_cur_symbol()


const MIRROR = preload("res://resources/symbols/mirror.tres")
const ATTACK = preload("res://resources/symbols/attack.tres")
func to_mirror():
	current_symbol = MIRROR
	make_temp_symbol(MIRROR)
	
func to_attack():
	current_symbol = ATTACK
	make_temp_symbol(ATTACK)

func mini_ui_show_hide(is_show: bool):
	mini_ui_show_hide_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	#label_show_hide_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	if is_show:
		mini_ui_show_hide_tween.tween_property(dice_mini_ui, "modulate", Color.WHITE, fade_seconds)
		#label_show_hide_tween.tween_property(label, "modulate", Color.WHITE, fade_seconds)
	else:
		mini_ui_show_hide_tween.tween_property(dice_mini_ui, "modulate", Color.TRANSPARENT, fade_seconds)
		#label_show_hide_tween.tween_property(label, "modulate", Color.TRANSPARENT, fade_seconds)


func make_burn(is_burn: bool = true):
	if is_burn:
		label.text = "[center][color=red]燃烧"
		label.tooltip_text = "燃烧\n使用时受到伤害"
		is_burning = true
		burn.visible = true
		animation_player.play("start")
		await animation_player.animation_finished
		animation_player.play("loop")
	else:
		label.text = ""
		is_burning = false
		burn.visible = false
		animation_player.stop()

func make_magic():
	is_draggable = false
	magic.show()
	Funcs.SFX.get_node("magic").play()
	animation_player.play("magic")
	await animation_player.animation_finished
	magic.hide()
	is_draggable = true
	
	
func make_mistake():
	is_draggable = false
	mistake.show()
	Funcs.SFX.get_node("flesh").play()
	animation_player.play("mistake")
	await animation_player.animation_finished
	mistake.hide()
	is_draggable = true


func make_change(method:String="shuffle"):
	is_draggable = false
	change.show()
	Funcs.SFX.get_node("magic").play()
	animation_player.play("change")
	await animation_player.animation_finished
	if method == "shuffle":
		shuffle()
	elif method == "reverse":
		reverse()
	elif method == 'mirror':
		to_mirror()
	elif method == 'attack':
		to_attack()
	animation_player.play("change2")
	await animation_player.animation_finished
	change.hide()
	is_draggable = true
	#self.reparent()


func reset():
	if not symbols_array:
		await ready
	panel.show()
	icon.show()
	
	is_draggable = true
	is_mouse_inside = false
	is_burning = false
	
	dice_base_state.enter()

func to_trash():
	dice_base_state.enter()
	self.remove_from_group("active_dice")
	self.add_to_group("inactive_dice")
	self.reparent(Funcs.TRASH)

func to_hand():
	Funcs.SFX.get_node("put").play()
	self.reparent(Funcs.HAND.get_node("b"+str(id)))
	Event.dice_to_hand.emit()

func to_shot(to_last:bool=false):
	Funcs.SFX.get_node("put").play()
	self.reparent(Funcs.SHOT.get_node("Shot"))
	if to_last:
		Event.dice_to_shot.emit(null)
	else:
		Event.dice_to_shot.emit(self)
	

# ---events---

func _input(event: InputEvent) -> void:
	if is_draggable:
		dice_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	if is_draggable:
		dice_state_machine.on_gui_input(event)
	elif (not is_draggable) and event.is_action_pressed("right_mouse"):
		Funcs.SFX.get_node("deny").play()

func _on_drop_point_detector_area_entered(area):
	on_area = area

func _on_drop_point_detector_area_exited(area):
	on_area = null


func _on_drop_point_detector_mouse_entered():
	pass

func _on_drop_point_detector_mouse_exited():
	pass


func _on_mouse_entered():
	is_mouse_inside = true
	if dice_state_machine.current_state.state == DiceState.State.BASE:
		mini_ui_show_hide(is_mouse_inside)
	if is_draggable:
		dice_state_machine.on_mouse_entered()

func _on_mouse_exited():
	is_mouse_inside = false
	mini_ui_show_hide(is_mouse_inside)
	
	dice_state_machine.on_mouse_exited()

