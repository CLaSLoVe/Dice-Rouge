extends DiceState

@onready var mini_dice_ui = $"../../MiniDiceUI"
@onready var put_sfx = $"../../PutSFX"


func enter() -> void:
	#dice_ui.get_node("Label").text = "BASE"
	if not dice_ui.is_node_ready():
		await dice_ui.ready

	dice_ui.pivot_offset = Vector2.ZERO

	#mini_dice_ui.visible = true
	
	if dice_ui.last_visible_parent == 'Job' and dice_ui.get_parent().get_parent().name == 'Hand':
		Events.dice_retrieve_from_job.emit()
	#dice_ui.last_visible_parent = 'Hand'
	

func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		dice_ui.pivot_offset = dice_ui.get_global_mouse_position() - dice_ui.global_position
		transition_requested.emit(self, DiceState.State.DRAGGING)
	elif event.is_action_pressed("right_mouse"):
		Events.dice_right_clicked.emit(dice_ui)
		put_sfx.play()

#func exit() -> void:
	#mini_dice_ui.visible = false
