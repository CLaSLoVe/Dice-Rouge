extends HBoxContainer

@onready var box = $Box
@onready var battle = $"../.."
@onready var sfx = %SFX
@onready var shot_button = $ShotButton
@onready var end_turn = $"../EndTurn"
@onready var skill_ui = %SkillsUI


#var button_lock = false

func _ready():
	Events.dice_on_shot_area.connect(_on_dice_on_shot_area)


func _on_reset_button_pressed():
	sfx.get_node("ResetSFX").play()
	for child in box.get_children():
		child.reparent(%Hand.get_node("b"+str(child.dice_pos)))


func _on_shot_button_pressed():
	Events.press_shot.emit()
	if Actions.tween and Actions.tween.is_running():
		Actions.tween.kill()
	var dices = box.get_children()
	var cur_sym = []
	for dice in dices:
		cur_sym.append(dice.cur_symbol.id)
	for dice in dices:
		dice.reparent(%Trash)
	cur_sym = "".join(cur_sym)
	#button_lock = true
	shot_button.disabled = true
	var cur_end_turn_state = end_turn.disabled
	end_turn.disabled = true
	await Actions.handle(skill_ui.skills_array[cur_sym])
	#if not battle.is_battle_win_state:
	end_turn.disabled = false
	#button_lock = false
	if Actions.tween and Actions.tween.is_running():
		Actions.tween.kill()
	Events.shot_end.emit()
	
# achieve custom order
func _on_dice_on_shot_area(dice_ui):
	var cur_x = dice_ui.global_position.x
	var children = box.get_children()
	if children.size() >= 2:
		var first_child = children[0]
		var start_x = first_child.get_global_position().x
		var insert_pos = (cur_x - start_x) / 120
		if insert_pos < 0:
			box.move_child(dice_ui, 0)
		else:
			box.move_child(dice_ui, min(int(insert_pos)+1, children.size()))
	
	#for child in box.get_children():
		#print(child.cur_symbol.id)


func _on_area_2d_area_entered(area):
	Events.check_skill_access.emit()


func _on_area_2d_area_exited(area):
	Events.check_skill_access.emit()
