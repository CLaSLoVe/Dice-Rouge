class_name DiceUI
extends Control

@export var dice: Dice
@export var dice_pos: int
@export var cur_symbol: Symbol
@export var editable: bool = true

@onready var mini_dice_ui = $MiniDiceUI
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var dice_state_machine: DiceStateMachine = $DiceStateMachine  

var fade_seconds = 0.5

var over_area = null
var is_draggable = true

var symbols_array: Array[Symbol]

# for Tween
var last_base_pos

# for job box retrieve
var last_visible_parent = 'Hand'

# transparent tween
var transparent_tween: Tween

func _ready():
	dice_state_machine.init(self)
	symbols_array = dice.symbols.duplicate()
	for i in range(6):
		mini_dice_ui.get_node("Symbols/s"+str(i+1)).texture = symbols_array[i].icon
		mini_dice_ui.modulate = Color.TRANSPARENT
	add_to_group('dice')

func update_symbol_ui():
	for i in range(6):
		mini_dice_ui.get_node("Symbols/s"+str(i+1)).texture = symbols_array[i].icon



func _input(event: InputEvent) -> void:
	if is_draggable:
		dice_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	if is_draggable:
		dice_state_machine.on_gui_input(event)


func _on_mouse_entered():
	if is_draggable:
		dice_state_machine.on_mouse_entered()
	#$DiceMiniUI.visible = true and (dice_state_machine.current_state.name == "DiceBaseState")


func _on_mouse_exited():
	dice_state_machine.on_mouse_exited()
	#$DiceMiniUI.visible = false


func _on_drop_point_detector_area_entered(area):
	over_area = area


func _on_drop_point_detector_area_exited(area):
	over_area = null


func _on_drop_point_detector_mouse_entered():
	mini_dice_ui_show()

func _on_drop_point_detector_mouse_exited():
	mini_dice_ui_hide()
	

func mini_dice_ui_show():
	transparent_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	transparent_tween.tween_property(mini_dice_ui, "modulate", Color.WHITE, fade_seconds)


func mini_dice_ui_hide():
	transparent_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	transparent_tween.tween_property(mini_dice_ui, "modulate", Color.TRANSPARENT, fade_seconds)
	#transparent_tween.tween_callback(hide)
