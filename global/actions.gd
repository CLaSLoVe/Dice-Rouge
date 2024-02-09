extends Node

var status_ui = null
var strike = null
var buff = null

var selected_enemy = null
var enemies = null
var player = null
var everyone = null

const MAX_DATA = 9999

var sfx = null
var tween: Tween

var shot_lock = false
signal action_over

var next_attack_aoe = false

var on_enemy_round = false

func _ready():
	Events.select_enemy.connect(_on_select_enemy)
	
	status_ui = get_tree().get_first_node_in_group('status')
	strike = get_tree().get_first_node_in_group('strike')
	buff = get_tree().get_first_node_in_group('buff')
	
	sfx = get_tree().get_first_node_in_group("sfx")

func register_chars():
	next_attack_aoe = false
	strike.strike = 0
	enemies = get_tree().get_nodes_in_group('enemy')
	player = get_tree().get_first_node_in_group('player')
	everyone = enemies + [player]
	reselect_enemy()



func rely2num(rely):
	if rely == Skill.Rely.STRENTH:
		return status_ui.strenth
	elif rely == Skill.Rely.DEFENCE:
		return status_ui.defence
	elif rely == Skill.Rely.MEDICAL:
		return status_ui.medical
	elif rely == Skill.Rely.MAGIC:
		return status_ui.magic	
	elif rely == Skill.Rely.INIT_STRENTH:
		return status_ui.init_strenth
	elif rely == Skill.Rely.INIT_DEFENCE:
		return status_ui.init_defence
	elif rely == Skill.Rely.INIT_MEDICAL:
		return status_ui.init_medical
	return -1


func _on_select_enemy(enemy):
	for each_enemy in get_tree().get_nodes_in_group('enemy'):
		each_enemy.get_node('TargetUI').visible = false
	enemy.get_node('TargetUI').visible = true
	selected_enemy = enemy
	if sfx:
		sfx.get_node("AimSFX").play()
		



func reselect_enemy():
	enemies = get_tree().get_nodes_in_group('enemy')

	if not enemies:
		battle_win()
		return
	var enemy = enemies[0]
	reset_target_ui()
	if (not selected_enemy) or (not selected_enemy.alive):
		selected_enemy = enemy
	selected_enemy.get_node('TargetUI').visible = true
	print("selected enemy:", selected_enemy)
	
func reset_target_ui():
	for each_enemy in get_tree().get_nodes_in_group('enemy'):
		each_enemy.get_node('TargetUI').visible = false

func calc_value(resource):
	return clampi(round(rely2num(resource.rely_on) * resource.mag), 0, MAX_DATA)

func give_pre(resource):
	var label = ' ('
	var value = calc_value(resource)

	label += str(value)
	if resource.times == 1:
		return label + ')'
	else:
		return label + 'x' + str(resource.times) + ')'

func handle(res):
	#shot_lock = true
	var value = calc_value(res)
	var animation_player = player.get_node("AnimationPlayer")
	var chars = null
	var true_chars = null
	
	match res.target:
		Skill.Target.EVERYONE:
			chars = everyone
		Skill.Target.ENEMIES:
			chars = enemies
		Skill.Target.ENEMY:
			chars = [selected_enemy]
		Skill.Target.SELF:
			chars = [player]
		_:
			return
	
	true_chars = chars
	
	var pos = player.position.x
	var player_moved = false
	
	# attack animation
	if res.type == Skill.Type.ATTACK:
		tween = get_tree().create_tween()
		tween.tween_property(player, "position", selected_enemy.get_parent().position-Vector2(100, 50), 0.2).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		player_moved = true
		animation_player.play("attack")
		await animation_player.animation_finished
		animation_player.play("Idle")
		if next_attack_aoe:
			chars = enemies
	
	# start handle here
	for i in range(res.times):
		value = attack_num_changer(value)
		for each_char in chars:
			if not each_char.alive:
				continue
			match res.type:
				# ATTACK
				Skill.Type.ATTACK:
					each_char.receive_damage(value)
					await get_tree().create_timer(0.1).timeout
				# BLOCK
				Skill.Type.BLOCK:
					each_char.get_block(value)
				
				Skill.Type.HEAL:
					each_char.heal(value)
					
				Skill.Type.ENHANCE:
					each_char.get_buff(res, value)
					
				Skill.Type.PURIFY:
					each_char.purify_buff()
					
		if res.type == Skill.Type.ATTACK and next_attack_aoe:
			chars = true_chars
			next_attack_aoe = false
			
		for each_char in chars:
			if each_char.health <= 0:
				break
	
	tween = get_tree().create_tween()
	tween.tween_property(player, "position", Funcs.PLAYER_INIT_POS, 0.2).set_trans(Tween.TRANS_CUBIC)
	await tween.finished

	#shot_lock = false
	action_over.emit()



func spell_handle(spell: Spell):
	match spell.spell_name:
		"block2attack":
			if next_attack_aoe:
				for enemy in enemies:
					enemy.receive_damage(player.block)
				next_attack_aoe = false
			else:
				selected_enemy.receive_damage(player.block)
		"emergency_heal":
			player.heal(0.5*player.max_health)
		"instant_block":
			player.get_block(20)
		"next_attackx2":
			Events.strike_update.emit(1)
		"next_attack_aoe":
			next_attack_aoe = true
		"purify":
			player.purify_debuff()

func attack_aim_to_aoe(value):
	if next_attack_aoe:
		return enemies
	else:
		return value

func attack_num_changer(value):
	if strike.strike > 0:
		Events.strike_update.emit(-1)
		return value * 2
	
	return value


func battle_win():
	Events.battle_win.emit()
