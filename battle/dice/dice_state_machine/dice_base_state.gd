extends DiceState


func enter() -> void:
	#dice_ui.get_node("Label").text = "BASE"
	dice_ui.panel.set("theme_override_styles/panel",dice_ui.BASE_PANEL_STYLE)
	dice_ui.mini_ui_show_hide(dice_ui.is_mouse_inside)
	if not dice_ui.is_node_ready():
		await dice_ui.ready

	dice_ui.pivot_offset = Vector2.ZERO
	

func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		dice_ui.pivot_offset = dice_ui.get_global_mouse_position() - dice_ui.global_position
		transition_requested.emit(self, DiceState.State.DRAGGING)
	if event.is_action_pressed("right_mouse"):
		if dice_ui.on_area and dice_ui.on_area.name == "ShotArea":
			dice_ui.to_hand()
		else:
			dice_ui.to_shot(true)

