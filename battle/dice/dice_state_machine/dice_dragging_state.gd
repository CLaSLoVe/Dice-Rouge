extends DiceState

func enter() -> void:
	#dice_ui.get_node("Label").text = "DRAGGING"
	var ui_layer = get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		dice_ui.reparent(ui_layer)
	dice_ui.mini_dice_ui.visible = false
	#Events.card_drag_started.emit(card_ui)
	
func on_input(event: InputEvent) -> void:
	var mouse_motion = event is InputEventMouseMotion
	#var cancel = event.is_action_pressed("right_mouse")
	var confirm = event.is_action_released("left_mouse")
	
	
	if mouse_motion:
		dice_ui.global_position = dice_ui.get_global_mouse_position() - dice_ui.pivot_offset
	
	#if cancel:
		#transition_requested.emit(self, DiceState.State.BASE)
	if confirm:# and minimum_drag_time_elapsed:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, DiceState.State.RELEASED)
		

func exit():
	dice_ui.mini_dice_ui.visible = true
	dice_ui.mini_dice_ui.modulate = Color.TRANSPARENT
