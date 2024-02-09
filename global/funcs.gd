extends Node

const PLAYER_INIT_POS = Vector2(300, 200)

#var sfx
#var player_status_ui
#
#func _ready():
	#sfx = get_tree().get_first_node_in_group("sfx")
	#player_status_ui = get_tree().get_first_node_in_group("status")


func rand_dice(dice_ui):
	var cur_num = randi() % 6
	var cur_symbol = dice_ui.symbols_array[cur_num]
	dice_ui.cur_symbol = cur_symbol
	dice_ui.get_node("Symbol").texture = cur_symbol.icon
	for i in range(6):
		dice_ui.get_node("MiniDiceUI/Panels/s"+str(i+1)).set("modulate", Color(1,1,1))
	dice_ui.get_node("MiniDiceUI/Panels/s"+str(cur_num+1)).set("modulate", Color(0,0,0))
	return cur_symbol.id



var transparent_tween: Tween

const fade_seconds = 0.1

func slowly_show(thing, color: Color = Color.WHITE, t = fade_seconds):
	transparent_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	transparent_tween.tween_property(thing, "modulate", color, t)
	await transparent_tween.finished
	
func slowly_hide(thing, color: Color = Color.TRANSPARENT, t = fade_seconds):
	transparent_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	transparent_tween.tween_property(thing, "modulate", color, t)
	await transparent_tween.finished
	
func slowly_up(thing):
	var up_tween = get_tree().create_tween()
	up_tween.tween_property(thing, "position:y", -20, 0.3).set_trans(Tween.TRANS_LINEAR)
	await up_tween.finished


func sum(array: Array[int]):
	var res = 0
	for i in array:
		res += i
	return res



func rand_choice_with_p(array: Array[int]):
	var sum_p = sum(array)
	var p_array: Array[int]
	
	p_array.append(array[0])
	for i in range(1, array.size()):
		p_array.append(array[i]+p_array[i-1])
	
	var cur = randi()%sum_p+1
	
	for i in range(p_array.size()):
		if cur <= p_array[i]:
			return i


func all_dice_to_trash():
	Events.all_dice_to_base.emit()
	for dice: DiceUI in get_tree().get_nodes_in_group('dice'):
		dice.reparent(get_tree().get_first_node_in_group("trash"))


