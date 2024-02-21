extends Control

@onready var shot = $Shot
@onready var skill_desc = $SkillDesc
@onready var shot_act = $ShotAct


var is_valid_comb: bool = false


var current_effect: Effect

var player

func _ready():
	Event.dice_to_shot.connect(_on_dice_to_shot)
	Event.dice_to_hand.connect(_on_dice_to_hand)
	player = get_tree().get_first_node_in_group("player")

func _on_shot_act_pressed():
	shot_act.disabled = true
	Funcs.SFX.get_node("button").play()
	
	for dice_ui: DiceUI in shot.get_children():
		dice_ui.to_trash()
		
	get_tree().get_first_node_in_group("battle").end_turn_button.disabled = true
	
	
	player = get_tree().get_first_node_in_group("player")
	#for player.buff_bar
	
	await player.do_action(current_effect)
	await player.take_shot_damage()
	get_tree().get_first_node_in_group("battle").end_turn_button.disabled = false
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.set_mimic()
		
	check_valid()
	


func _on_dice_to_shot(dice_ui):
	if not dice_ui:
		check_valid()
		return
		
	var exist_dice = shot.get_children()
	var vec = dice_ui.global_position
	if exist_dice:
		var bias = vec - exist_dice[0].global_position
		var insert_pos = bias[0] / 110
		if insert_pos < 0:
			shot.move_child(dice_ui, 0)
		else:
			shot.move_child(dice_ui, min(int(insert_pos)+1, exist_dice.size()))
	check_valid()

func check_valid():
	if not get_tree().get_first_node_in_group("battle").is_player_turn:
		Funcs.SFX.get_node("deny").play()
		skill_desc.text = "[center]敌方回合"
		is_valid_comb = false
		shot_act.disabled = true
		current_effect = null
		return 
	var symbols = []
	var symbolstr
	for dice in shot.get_children():
		symbols.append(dice.current_symbol)
	symbolstr = Funcs.symbols2str(symbols, true)
	
	if symbolstr in Funcs.skills.keys():
		if not Actions.check_valid_target(get_tree().get_first_node_in_group("player").get_target(Funcs.skills[symbolstr].effect.to_target)):
			skill_desc.text = "[center]无效目标"
			is_valid_comb = false
			shot_act.disabled = true
			current_effect = null
		else:
			skill_desc.text = "[center]"+Funcs.skills[symbolstr].desc.text
			is_valid_comb = true
			if (not Actions.is_in_action) and is_valid_comb:
				shot_act.disabled = false
			current_effect = Funcs.skills[symbolstr].effect
	else:
		skill_desc.text = "[center]无效组合"
		is_valid_comb = false
		shot_act.disabled = true
		current_effect = null
	make_predict()

func make_predict():
	player = get_tree().get_first_node_in_group("player")
	for target in get_tree().get_nodes_in_group("everyone"):
		target.set_future("")
	if current_effect and current_effect.type == Effect.Type.ATTACK:
		for target in player.get_target(current_effect.to_target):
			var this_text = str(Actions.calc_value(current_effect, player.get_target(current_effect.base_target)[0]))
			if current_effect.times >1:
				this_text += ("x"+str(current_effect.times))
			if target:
				target.set_future("-"+this_text)


func _on_dice_to_hand():
	check_valid()
