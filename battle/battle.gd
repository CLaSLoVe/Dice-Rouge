extends Node2D

@onready var trash = %Trash
@onready var hand = %Hand
@onready var job = %Job
@onready var skill_ui = %SkillsUI
@onready var shot_box = $BattleLayer/Shot/Box
@onready var shot_button = $BattleLayer/Shot/ShotButton
@onready var reset_button = $BattleLayer/Shot/ResetButton
@onready var end_turn = $BattleLayer/EndTurn
@onready var sfx = %SFX
@onready var buffs = %Buff
@onready var player_status_ui = %StatusUI
@onready var win_ui = $WinLayer/WinUI
@onready var skill_desc = %SkillDesc
@onready var shot = $BattleLayer/Shot
@onready var enemy_handler = $CharacterLayer/Enemies
@onready var static_counter = $BattleLayer/Static
@onready var lose_ui = $WinLayer/LoseUI


const pause_dur = 0.5
const move_dur = 0.5
const mistake_move_len = 10

var player = null

var at_round = 1
var at_floor = 1

var is_battle_end_state = false

func _ready():
	# init
	win_ui.visible = true
	Events.check_skill_access.connect(_on_check_skill_access)
	Events.battle_win.connect(_on_battle_win)
	Events.battle_lose.connect(_on_battle_lose)
	Events.award_finished.connect(_on_award_finished)
	player = get_tree().get_first_node_in_group('player')
	
	# set position
	init_position()
	
	#_on_battle_win()
	# start battle
	clean_battle()
	await init_battle() #! need this
	
	
	#get_tree().change_scene_to_file("res://battle/win_ui.tscn")
	#await get_tree().create_timer(1).timeout
	
func init_position():
	player.position = Funcs.PLAYER_INIT_POS
	win_ui.position.y = -1080
	get_tree().get_first_node_in_group("status").position.x = 510
	get_tree().get_first_node_in_group("status").position.y = 860
	
	
# battle related funcs

func init_battle():
	#add enemies
	
	enemy_handler.add_enemies(at_floor)
	Actions.register_chars()
	print("battle init.")
	# start first turn
	for enemy in get_tree().get_nodes_in_group('enemy'):
		enemy.modulate = GRAY
	
	Events.update_skills.emit()
	
	player_status_ui.reset_all()
	await from_trash_to_hand()
	

func clean_battle():
	# dice to trash
	Funcs.all_dice_to_trash()
	#reset job
	reset_job()
	# delete all enemy
	for enemy in get_tree().get_nodes_in_group('enemy'):
		enemy.queue_free()
	for enemy in get_tree().get_nodes_in_group('died_enemy'):
		enemy.queue_free()
	# clear buff
	for buff in buffs.get_children():
		buff.queue_free()
	# init status
	player_status_ui.strenth_plus = 0
	player_status_ui.defence_plus = 0
	player_status_ui.medical_plus = 0
	player_status_ui.magic_update(0)
	player_status_ui.strenth_update(0)
	player.reset_block()
	print("battle reset.")
	is_battle_end_state = false
	
	

func from_trash_to_hand():
	var cur_shot_button_disabled = shot_button.disabled
	shot_button.disabled = true
	var children = trash.get_children()
	
	for child in children:
		Funcs.rand_dice(child)
		child.reparent(hand.get_node("b"+str(child.dice_pos)))
	shot_button.disabled = cur_shot_button_disabled
	await for_box_instance_symbol_effect()
	end_turn.disabled = false
	
		
		
func reset_job():
	Events.credit_update_to.emit(job.max_credit)
	



func instance_symbol_effect(dice_ui: DiceUI):
	if dice_ui.cur_symbol.id == 3:
		var ui_layer = get_tree().get_first_node_in_group("ui_layer")
		dice_ui.reparent(ui_layer)
		dice_ui.global_position = dice_ui.last_base_pos
		dice_ui.is_draggable = false
		await get_tree().create_timer(pause_dur).timeout
		var tween = get_tree().create_tween()
		tween.tween_property(dice_ui, "position", Vector2(450, 800), move_dur).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		
		sfx.get_node("MagicSFX").play()

		dice_ui.reparent(trash)
		
		#dice_ui.mini_dice_ui.visible = true
		dice_ui.is_draggable = true
		
		Events.magic_update.emit(1)
	elif dice_ui.cur_symbol.id == 5:
		dice_ui.is_draggable = false
		await get_tree().create_timer(pause_dur).timeout
		
		var tween = get_tree().create_tween()
		tween.tween_property(dice_ui, "position:x", mistake_move_len, move_dur/6).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(dice_ui, "position:x", -1 * mistake_move_len, move_dur/6).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(dice_ui, "position:x", mistake_move_len, move_dur/6).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(dice_ui, "position:x", mistake_move_len, move_dur/6).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(dice_ui, "position:x", -1 * mistake_move_len, move_dur/6).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(dice_ui, "position:x", mistake_move_len, move_dur/6).set_trans(Tween.TRANS_LINEAR)
		await tween.finished

		get_tree().get_first_node_in_group('player').receive_damage(3)
		dice_ui.reparent(trash)
		dice_ui.is_draggable = true



func for_box_instance_symbol_effect():
	var boxs = hand.get_children()
	for i in range(boxs.size()):
		var box = boxs[i]
		if box.get_children():
			var dice_ui = box.get_child(0)
			if dice_ui:
				dice_ui.last_base_pos = hand.global_position + Vector2(i*140 - 30, 40) 
				await instance_symbol_effect(dice_ui)




# ---SIGNAL AREA---
const TURN_PAUSE = 0.2
const GRAY = Color.DARK_GRAY

func _on_end_turn_pressed():
	# ---player turn end
	Events.player_round_end.emit()
	sfx.get_node("EndTurnSFX").play()
	end_turn.disabled = true
	
	
	reset_job()
	Funcs.slowly_hide(player, GRAY, TURN_PAUSE)
	for enemy in get_tree().get_nodes_in_group('enemy'):
		Funcs.slowly_hide(enemy, Color.WHITE, TURN_PAUSE)
	
	await get_tree().create_timer(TURN_PAUSE).timeout
	for enemy in get_tree().get_nodes_in_group('enemy'):
		enemy.reset_block()
		#await get_tree().create_timer(0.1).timeout
	
	# buff countdown
	for buff in buffs.get_children():
		if buff.related_buff.discard_on == Skill.Stage.PLAYER_TURN_END and buff.related_buff.on_turn:
			buff.countdown -= 1
			await buff.update_countdown()
	Events.buff_update.emit()
	
	# ---enemy turn
	Actions.shot_lock = true
	for enemy in get_tree().get_nodes_in_group('enemy'):
		if player.alive:
			await enemy.conduct_action()

	for enemy in get_tree().get_nodes_in_group('enemy'):
		enemy.show_action()
		
	# ---enemy turn end
	Funcs.slowly_hide(player, Color.WHITE, TURN_PAUSE)
	for enemy in get_tree().get_nodes_in_group('enemy'):
		#enemy.modulate = Color.GRAY 
		Funcs.slowly_hide(enemy, GRAY, TURN_PAUSE)
	#await get_tree().create_timer(5*TURN_PAUSE).timeout
	# ---player turn start
	#for buff in buffs.get_children():
		#if buff.buff_type.discard_on == Skill.Stage.PLAYER_TURN_START and buff.buff_type.on_turn:
			#buff.countdown -= 1
			#await buff.update_countdown()
	#Events.buff_update.emit()
	#for buff in buffs.get_children():
		#if not buff.buff_type.on_turn:

	
	# reset block
	
	player.reset_block()
	at_round += 1
	Events.battle_counter_update.emit(at_round, at_floor)
	# started
	sfx.get_node("StartTurnSFX").play()
	Actions.shot_lock = false
	if is_battle_end_state:
		end_turn.disabled = true
	else:
		Events.player_round_start.emit()
		end_turn.disabled = false
		await from_trash_to_hand()
	
	
	


func _on_check_skill_access():
	var dices = shot_box.get_children()
	if dices:
		reset_button.disabled = false
	else:
		reset_button.disabled = true
	#await Events.action_conducted
	var cur_sym = []
	for dice in dices:
		cur_sym.append(dice.cur_symbol.id)
	cur_sym = "".join(cur_sym)
	if cur_sym in skill_ui.skills_array.keys():
		if Actions.shot_lock:
			await Actions.action_over
		shot_button.disabled = false
		shot_button.text = skill_ui.skills_array[cur_sym].skill_name
		skill_desc.text = skill_ui.skills_array[cur_sym].skill_description + Actions.give_pre(skill_ui.skills_array[cur_sym])
		
	else:
		shot_button.disabled = true
		if dices:
			shot_button.text = '无效组合'
			skill_desc.text = ''
		else:
			shot_button.text = '拖拽骰子'
			skill_desc.text = ''

var skill_tween = null

func _on_see_skill_button_button_down():
	if skill_tween and skill_tween.is_running():
		skill_tween.kill()
	var skill_tween = get_tree().create_tween()
	sfx.get_node("UpSFX").play()
	skill_tween.tween_property(skill_ui, "position:x", 90, .1).set_trans(Tween.TRANS_CUBIC)


func _on_see_skill_button_button_up():
	if skill_tween and skill_tween.is_running():
		skill_tween.kill()
	var skill_tween = get_tree().create_tween()
	sfx.get_node("DownSFX").play()
	skill_tween.tween_property(skill_ui, "position:x", -2000, .1).set_trans(Tween.TRANS_CUBIC)


func _on_battle_win():
	print('battle win.')
	var get_money_value = clampi((5-at_round)*at_floor+5, 5, 10)
	player_status_ui.money += get_money_value
	print(get_money_value)
	end_turn.disabled = true
	is_battle_end_state = true
	Funcs.all_dice_to_trash()
	var tween = get_tree().create_tween()
	tween.tween_property(win_ui, "position:y", 0, 0.5).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
	await Events.new_battle_start

func _on_battle_lose():
	is_battle_end_state = true
	lose_ui.init()



func _on_award_finished():
	at_floor += 1
	Events.battle_counter_update.emit(1, at_floor)
	Events.update_skills.emit()
	init_position()
	# start battle
	clean_battle()
	await init_battle() #! need this
