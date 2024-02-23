extends HBoxContainer

@onready var trash = $"../Trash"

const DEAL_DT = 0.2

var box_lock: Array[bool] = [false,false,false,false,false,false,]


func _ready():
	Event.dice_to_hand.connect(_on_dice_to_hand)
	#from_trash_to_hand()
	


func from_trash_to_hand():
	for dice in trash.get_children():
		#await get_tree().create_timer(DEAL_DT).timeout
		if box_lock[dice.id-1]:
			continue
		dice.reset()
		dice.shuffle()
		dice.to_hand()
		dice.add_to_group("active_dice")
		dice.remove_from_group("inactive_dice")
	Event.dice_to_hand.emit()


func do_instant_effect(dice_ui: DiceUI):
	if not (dice_ui in get_tree().get_nodes_in_group("active_dice")):
		return
	match dice_ui.current_symbol.type:
		Symbol.Type.MAGIC:
			dice_ui.remove_from_group("active_dice")
			dice_ui.add_to_group("inactive_dice")
			await dice_ui.make_magic()
			dice_ui.to_trash()
			Funcs.COUNTER.cur_magic += 1
			print("magic")
		Symbol.Type.MISTAKE:
			dice_ui.remove_from_group("active_dice")
			dice_ui.add_to_group("inactive_dice")
			await dice_ui.make_mistake()
			dice_ui.to_trash()
			get_tree().get_first_node_in_group("player").take_damage(3)
			print("mistake")

func lock_hand():
	var player = get_tree().get_first_node_in_group("player")
	Funcs.FUTURE.add_text("[font_size=15]"+player.character.char_name+"被[color=gray]晕眩[/color][/font_size]")
	var id_ind = Array(range(box_lock.size()))
	id_ind.shuffle()
	for i in id_ind:
		if not box_lock[i]:
			box_lock[i] = true
			get_node("b"+str(i+1)).make_lock()
			if get_node("b"+str(i+1)).get_children().size()>1:
				get_node("b"+str(i+1)).get_child(1).to_trash()
			break

func unlock_hand():
	for i in range(box_lock.size()):
		box_lock[i] = false
		get_node("b"+str(i+1)).make_unlock()



func _on_dice_to_hand():
	for i in range(1,7):
		var children = Funcs.HAND.get_node("b"+str(i)).get_children()
		if children.size()>1:
			do_instant_effect(children[1])
