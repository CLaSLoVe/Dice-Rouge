extends Node2D

@onready var end_turn_button = $BattleUI/EndTurn
@onready var tips = $BattleUI/Tips
@onready var relics = $BattleUI/Relics
@onready var curtain = $BattleUI/Curtain
@onready var large_curtain = $BattleUI/LargeCurtain

var is_win = false
var is_lose = false
var money_of_active_dice = 0


@export var earn_dice_money: bool = true
@export var max_dice_money: int = 5
var keep_hand: bool = false
var keep_block: bool = false



var is_player_turn = true

func _ready():
	curtain.set("modulate", Color.TRANSPARENT)
	Event.win.connect(_on_win)
	Event.lose.connect(_on_lose)
	init_battle()
	
func init_battle():
	Funcs.FUTURE.add_text("\t"+Funcs.COUNTER.current_floor.text)
	Funcs.FUTURE.add_text("[color=Orchid]-- 玩家回合开始 --[/color]")
	# data init
	curtain.hide()
	is_win = false
	is_lose = false
	end_turn_button.disabled = false
	money_of_active_dice = 0
	
	get_tree().get_first_node_in_group("active_characters").init()
	
	# enemy init
	var children = get_tree().get_nodes_in_group("enemies")
	if children:
		Funcs.select_from_enemy()
		
	# player init
	var player = get_tree().get_first_node_in_group("player")
	
	if not player.is_node_ready():
		await player.ready
	
	player.its_turn = true
	player.slow_show()
	player.clear_block()
	Funcs.JOB.reset()
	Funcs.HAND.from_trash_to_hand()
	Funcs.COUNTER.reset(true)
	
	for relic in relics.get_children():
		relic.init()
	
	tips.reset()
	print("---")
	print(Funcs.COUNTER.current_floor.text)

func clear_up(force=false):
	print("-- 清理战斗", force)
	end_turn_button.disabled = true
	var active_dices = get_tree().get_nodes_in_group("active_dice")
	var player = get_tree().get_first_node_in_group("player")
	
	if force:
		player.clear_buff()
		print("--- buff 清理完成")
	
	if active_dices:
		for dice in active_dices:
			if not keep_hand:
				dice.to_trash()
			elif force:
				dice.to_trash()
			
			# earn dice money
			if earn_dice_money:
				money_of_active_dice += 1
				if money_of_active_dice <= max_dice_money:
					Funcs.COUNTER.cur_money += 1
				Funcs.COUNTER.reset()

var curtain_tween: Tween
const fade_seconds = 0.15

func _on_end_turn_pressed():
	if is_lose:
		return
	Funcs.FUTURE.add_text("[color=Orchid]-- 玩家回合结束 --[/color]")
	var player = get_tree().get_first_node_in_group("player")
	player.its_turn = false
	player.slow_hide()
	
	curtain.show()
	curtain_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	curtain_tween.tween_property(curtain, "modulate", Color.WHITE, fade_seconds)
	await curtain_tween.finished
	await get_tree().create_timer(0.3).timeout
	
	for dice:DiceUI in Funcs.SHOT.get_node("Shot").get_children():
		dice.to_hand()
	for dice:DiceUI in get_tree().get_nodes_in_group("active_dice"):
		dice.is_draggable = false
	is_player_turn = false
	#print('---')
	#print(get_tree().get_nodes_in_group("active_dice"))
	#print(get_tree().get_nodes_in_group("inactive_dice"))

	# --- CLEARN ---
	Funcs.HAND.unlock_hand()
	Funcs.SFX.get_node("button").play()
	clear_up()
	
	player.counting()
	#get_tree().get_first_node_in_group("player").calc_buff()
	await player.take_turn_damage()
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies:
		for enemy in enemies:
			enemy.clear_block()
	else:
		print("[Error]未检测到敌方")
		return
	
	# --- ENEMY TURN ---
	Funcs.FUTURE.add_text("[color=Orchid]-- 敌方回合开始 --[/color]")
	for enemy in enemies:
		if not enemy:
			continue
		if is_lose:
			return
		await enemy.do_action()
		await get_tree().create_timer(0.3).timeout
	await get_tree().create_timer(0.3).timeout
	
	for enemy in enemies:
		enemy.calc_buff()
		await enemy.take_turn_damage()
	
		
	#await get_tree().create_timer(1).timeout
	
	
	# --- ENEMY TURN END ---
	Funcs.FUTURE.add_text("[color=Orchid]-- 敌方回合结束 --[/color]\n")
	for enemy in enemies:
		if not enemy:
			continue
		enemy.counting()
		enemy.calc_buff()
		
		
		enemy.set_next_action()
	
	# --- NEW TURN ---
	Funcs.COUNTER.cur_round += 1
	Funcs.COUNTER.reset()
	Funcs.FUTURE.add_text(Funcs.COUNTER.current_floor.text)
	Funcs.FUTURE.add_text("[color=Orchid]-- 玩家回合开始 --[/color]")
	player.its_turn = true
	player.slow_show()
	
	curtain_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	curtain_tween.tween_property(curtain, "modulate", Color("#0c1122bb"), fade_seconds)
	await curtain_tween.finished
	curtain.hide()
	is_player_turn = true
	if not keep_block:
		get_tree().get_first_node_in_group("player").clear_block()
	
	Funcs.JOB.reset()
	Funcs.HAND.from_trash_to_hand()
	for dice:DiceUI in get_tree().get_nodes_in_group("active_dice"):
		dice.is_draggable = true
	
	
	
	if not is_win or is_lose:
		end_turn_button.disabled = false



var layer_win = 0

func _on_win(layer):
	if layer <= layer_win:
		return
	
	layer_win = layer
	is_win = true
	Funcs.COUNTER.cur_layer += 1
	Funcs.COUNTER.cur_round = 1
	Funcs.COUNTER.cur_money += 10
	Funcs.COUNTER.reset()
	clear_up(true)
	Funcs.FUTURE.add_text("[color=Greenyellow ]胜利![/color]")
	#await get_tree().create_timer(1).timeout
	#init_battle()

@onready var lose_text = $BattleUI/LargeCurtain/lose_text

func _on_lose():
	is_lose = true
	large_curtain.show()
	lose_text.text = "你坚持了"+str(Funcs.COUNTER.cur_layer)+"[color=Hotpink ]层[/color]\n\n\t拥有"+str(relics.get_children().size())+"个[color=orange]神秘遗物[/color]\n\n\t\t学习了"+str(Funcs.SKILLS.get_children().size())+"个[color=skyblue]技能[/color]\n\n\t\t\t下次再来！"
