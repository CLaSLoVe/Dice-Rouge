extends DiceState

@onready var put_sfx = $"../../PutSFX"

var area = null

func enter() -> void:
	pass
	#dice_ui.get_node("Label").text = "RELEASED"	
	area = dice_ui.over_area
	put_sfx.play()
	

func on_input(event: InputEvent) -> void:
	if area:
		area_handler(area)
		return
	var hand = get_tree().get_first_node_in_group("hand")
	dice_ui.reparent(hand.get_node("b"+str(dice_ui.dice_pos)))
	transition_requested.emit(self, DiceState.State.BASE)
	

func area_handler(area):
	var ui_layer = get_tree().get_first_node_in_group("ui_layer")
	var shot = get_tree().get_first_node_in_group("shot")
	if area.get_parent().name == "Job":
		dice_ui.reparent(area.get_parent().get_node("Box/TrueBox"))
		dice_ui.last_visible_parent = "Job"
		transition_requested.emit(self, DiceState.State.BASE)
		Events.dice_into_job_box.emit()
	elif area.get_parent().name == "Shot":
		dice_ui.reparent(area.get_parent().get_node("Box"))
		dice_ui.last_visible_parent = "Shot"
		transition_requested.emit(self, DiceState.State.BASE)
		Events.dice_on_shot_area.emit(dice_ui)
	
		
