extends DiceState

func enter() -> void:
	dice_ui.get_node("Label").text = "BASE"
	dice_ui.drop_point_detector.monitoring = true

func on_input(event: InputEvent) -> void:
	var cancel = event.is_action_released("left_mouse")
	if cancel:
		transition_requested.emit(self, DiceState.State.BASE)
	elif event is InputEventMouseMotion:
		transition_requested.emit(self, DiceState.State.DRAGGING)
