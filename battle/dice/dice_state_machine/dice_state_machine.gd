class_name DiceStateMachine
extends Node


@export var initial_state: DiceState

var current_state: DiceState
var state = {}

func init(dice: DiceUI) -> void:
	for child in get_children():
		if child is DiceState:
			state[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
			child.dice_ui = dice
	Events.all_dice_to_base.connect(_on_all_dice_to_base)
			
	if initial_state:
		initial_state.enter()
		current_state = initial_state
		
		
func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)
	

func on_gui_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_gui_input(event)


func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()
	
	
func on_mouse_exited() -> void:
	if current_state:
		current_state.on_mouse_exited()


func _on_transition_requested(from: DiceState, to: DiceState.State) -> void:
	if from != current_state:
		return
	
	var new_state: DiceState = state[to]
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
		
	new_state.enter()
	current_state = new_state
	
func _on_all_dice_to_base():
	_on_transition_requested(current_state, DiceState.State.BASE)
