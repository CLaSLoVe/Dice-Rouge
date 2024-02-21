extends DiceState

func enter() -> void:
	#dice_ui.get_node("Label").text = "DRAGGING"
	dice_ui.mini_ui_show_hide(false)
	dice_ui.panel.set("theme_override_styles/panel",dice_ui.HOVER_PANEL_STYLE)
	var ui_layer = get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		dice_ui.reparent(ui_layer)
	#Events.card_drag_started.emit(card_ui)
	
func on_input(event: InputEvent) -> void:
	var mouse_motion = event is InputEventMouseMotion
	var confirm = event.is_action_released("left_mouse")
	
	
	if mouse_motion:
		dice_ui.global_position = dice_ui.get_global_mouse_position() - dice_ui.pivot_offset
	
	if confirm:# and minimum_drag_time_elapsed:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, DiceState.State.RELEASED)
		

func exit():
	pass
