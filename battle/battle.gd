extends Node2D

@onready var end_turn_button = $BattleUI/EndTurn
@onready var tips = $BattleUI/Tips
@onready var relics = $BattleUI/Relics
@onready var curtain = $BattleUI/Curtain
@onready var large_curtain = $BattleUI/LargeCurtain
@onready var player_node = $Characters/Player
@onready var character_temp = $Characters/CharacterTemp
@onready var job = $BattleUI/Job

var is_win = false
var is_lose = false
var is_player_turn = true

# 回收骰子赚钱
var money_of_active_dice = 0
@export var earn_dice_money: bool = true
@export var max_dice_money: int = 10

# 每回合不回收骰子
var keep_hand: bool = false
# 每回合不去除格挡
var keep_block: bool = false




func _ready():
	curtain.set("modulate", Color.TRANSPARENT)
	Event.win.connect(_on_win)
	Event.lose.connect(_on_lose)




# 初始化战斗
func init_battle():
	# 记录log
	Funcs.FUTURE.add_text("\t"+Funcs.COUNTER.current_floor.text)
	Funcs.FUTURE.add_text("[color=Orchid]-- 玩家回合开始 --[/color]")
	curtain.hide()
	
	# 玩家初始化
	var player = get_tree().get_first_node_in_group("player")
	player.init()
	
	next_battle()
	
	print("---")
	print(Funcs.COUNTER.current_floor.text)



func next_battle():
	# 数据初始化
	is_win = false
	is_lose = false
	end_turn_button.disabled = false
	money_of_active_dice = 0
	
	var player = get_tree().get_first_node_in_group("player")
	player.calc_buff()
	player.its_turn = true
	player.slow_show()
	player.clear_block()
	Funcs.JOB.reset()
	Funcs.HAND.from_trash_to_hand()
	Funcs.COUNTER.reset(true)
	
	# 敌人初始化
	set_enemies()
	var children = get_tree().get_nodes_in_group("enemies")
	if children:
		Funcs.select_from_enemy()
		
	#圣遗物初始化
	for relic in relics.get_children():
		relic.init()
	
	# 技能初始化
	tips.reset()



func clear_up(force=false):
	print("-- 清理战斗", force)
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



func set_player(player:Character, init_strenth, init_defence, init_medical, cur_health, max_health):
	player_node.character = player
	player_node.init_strenth = init_strenth
	player_node.init_defence = init_defence
	player_node.init_medical = init_medical
	player_node.cur_health = cur_health
	player_node.max_health = max_health
	
	var dices = player.dices
	for i in range(dices.size()):
		Funcs.TRASH.get_node('DiceUI'+str(i+1)).dice = dices[i]
	Funcs.TRASH.get_node('DiceUI6').dice = get_tree().get_first_node_in_group("manager").custom_dice
	for child in Funcs.TRASH.get_children():
		child.init()
	
	for child in job.get_node('jobdesc').get_children():
		child.hide()
	job.get_node('jobdesc/'+player.job_name).show()
	
func set_enemies():
	match Funcs.COUNTER.cur_layer:
		1:
			set_enemy("Slime",2,[15,5,10,40])
			#set_enemy("King", 1,[8,5,5,60])
			#set_enemy("Snack", 2,[7,5,5,80])
			#set_enemy("Shadow", 0,[15,5,20,24])
			#set_enemy("Bird", 2,[10,5,20,24])
		2:
			set_enemy("Slime",2,[10,5,10,40])
			set_enemy("Slime",1,[8,5,10,40])
			set_enemy("Snow",0,[10,5,10,40])
		3:
			set_enemy("Snow", 2,[20,5,20,60])
			set_enemy("King", 1,[8,5,5,60])
		4:
			set_enemy("Shadow", 2,[10,5,20,18])
			set_enemy("Bird", 2,[4,5,5,80])
		5:
			set_enemy("Snack", 2,[7,5,5,80])
			set_enemy("Snack", 1,[7,5,5,80])
		6:
			set_enemy("Shadow", 2,[10,5,20,24])
			set_enemy("Shadow", 1,[10,5,20,24])
		7:
			set_enemy("King", 1,[8,5,5,60])
			set_enemy("Snack", 2,[7,5,5,80])
			set_enemy("Shadow", 0,[15,5,20,24])
			set_enemy("Bird", 2,[5,5,20,24])


@onready var enemies_1 = $Characters/Enemies
@onready var enemies_2 = $Characters/Enemies2

const CHARACTER = preload("res://characters/character.tscn")

func set_enemy(enemy_name, pos, attr_array):
	var new_char = CHARACTER.instantiate()
	new_char.character = character_temp.get_node(enemy_name).character
	new_char.init_strenth = attr_array[0]
	new_char.init_defence = attr_array[1]
	new_char.init_medical = attr_array[2]
	new_char.max_health = attr_array[3]
	print(new_char.character)
	if new_char.character.fly:
		enemies_2.get_child(pos).add_child(new_char)
	else:
		enemies_1.get_child(pos).add_child(new_char)
	new_char.init()
	print(enemy_name,"出现")

var curtain_tween: Tween
const fade_seconds = 0.15








func _on_end_turn_pressed():
	if is_lose:
		return
	end_turn_button.disabled = true
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
	Funcs.COUNTER.cur_money += 10+randi_range(-4,4)
	Funcs.COUNTER.reset()
	clear_up(true)
	Funcs.FUTURE.add_text("[color=Greenyellow ]胜利![/color]")
	Funcs.SFX.get_node("laugh").play()
	await get_tree().create_timer(1).timeout
	Event.win_ui_pop_up.emit()
	
	

@onready var lose_text = $BattleUI/LargeCurtain/lose_text

var large_curtain_tween: Tween

func _on_lose():
	is_lose = true
	
	lose_text.text = "你坚持了"+str(Funcs.COUNTER.cur_layer)+"[color=Hotpink ]层[/color]\n\n\t拥有"+str(relics.get_children().size())+"个[color=orange]神秘遗物[/color]\n\n\t\t学习了"+str(Funcs.SKILLS.get_children().size())+"个[color=skyblue]技能[/color]\n\n\t\t\t下次再来！"
	large_curtain.set("modulate", Color.TRANSPARENT)
	large_curtain.show()
	large_curtain_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	large_curtain_tween.tween_property(large_curtain, "modulate", Color.WHITE, 0.3)

	
