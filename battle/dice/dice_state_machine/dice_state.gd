class_name DiceState
extends Node


enum State {BASE, CLICKED, DRAGGING, RELEASED}

signal transition_requested(from: DiceState, to: State)

@export var state: State

var dice_ui: DiceUI


func enter() -> void:
	pass
	

func exit() -> void:
	pass


func on_input(event: InputEvent) -> void:
	pass
	

func on_gui_input(event: InputEvent) -> void:
	pass
	

func on_mouse_entered() -> void:
	pass
	
	
func on_mouse_exited() -> void:
	pass
