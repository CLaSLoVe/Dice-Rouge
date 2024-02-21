extends DiceState

var area = null

func enter() -> void:
	#dice_ui.get_node("Label").text = "RELEASED"	
	if dice_ui.on_area and dice_ui.on_area.name == "ShotArea":
		dice_ui.to_shot()
	elif dice_ui.on_area and dice_ui.on_area.name == "JobArea":
		dice_ui.reparent(Funcs.JOB.get_node("Job"))
		Event.dice_to_job.emit()
	else:
		dice_ui.to_hand()
	

func on_input(event: InputEvent) -> void:
	transition_requested.emit(self, DiceState.State.BASE)
	

