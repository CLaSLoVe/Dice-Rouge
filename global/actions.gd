extends Node


var is_in_action = false
var selected_enemy

func calc_value(effect: Effect, from_target):
	if not from_target:
		return 0
	var value = 1
	match effect.base_statu:
		Effect.FromStatu.STRENTH:
			value = from_target.init_strenth + from_target.add_strenth
		Effect.FromStatu.DEFENCE:
			value = from_target.init_defence + from_target.add_defence
		Effect.FromStatu.MEDICAL:
			value = from_target.init_medical + from_target.add_medical
		Effect.FromStatu.INIT_STRENTH:
			value = from_target.init_strenth
		Effect.FromStatu.INIT_DEFENCE:
			value = from_target.init_defence
		Effect.FromStatu.INIT_MEDICAL:
			value = from_target.init_medical
		
	return round(value * effect.magnitude)+effect.bias


#func calc_base_value(effect:Effect):
	#var base_value
	#match effect.base_statu:
		#Effect.FromStatu.STRENTH:
			#base_value = init_strenth + add_strenth
		#Effect.FromStatu.DEFENCE:
			#base_value = init_defence + add_defence
		#Effect.FromStatu.MEDICAL:
			#base_value = init_medical + add_medical
		#Effect.FromStatu.INIT_STRENTH:
			#base_value = init_strenth
		#Effect.FromStatu.INIT_DEFENCE:
			#base_value = init_defence
		#Effect.FromStatu.INIT_MEDICAL:
			#base_value = init_medical
		#Effect.FromStatu.NULL:
			#base_value = 0
	#return base_value
func check_valid_target(to_targets):
	var valid_target = false
	for target in to_targets:
		if target:
			valid_target = true
			break
	return valid_target
		
	


var target_move_tween:Tween
var next_act_vis_tween: Tween

func do_action(effect: Effect, base_target:CharacterBase, to_targets: Array, from_target:CharacterBase=null, quiet=false):
	is_in_action = true
	
	
	if not check_valid_target(to_targets):
		is_in_action = false
		return
	
	if not from_target.character.is_player:
		next_act_vis_tween = get_tree().create_tween()
		next_act_vis_tween.tween_property(from_target.next_icon, "modulate", Color.TRANSPARENT, 0.2).set_trans(Tween.TRANS_CUBIC)
		next_act_vis_tween.tween_property(from_target.attackvalue, "modulate", Color.TRANSPARENT, 0.2).set_trans(Tween.TRANS_CUBIC)
		await  next_act_vis_tween.finished
	
	
	var times = effect.times
	var value = calc_value(effect, base_target)
	match effect.type:
		Effect.Type.ATTACK:
			from_target.play_sound("attack", quiet)
			#var from_target_position_x = from_target.global_position.x
			#target_move_tween = get_tree().create_tween()
			#target_move_tween.tween_property(from_target, "global_position:x", 900, 0.1).set_trans(Tween.TRANS_CUBIC)
			#await target_move_tween.finished
			await get_tree().create_timer(0.3).timeout
			#target_move_tween = get_tree().create_tween()
			#target_move_tween.tween_property(from_target, "global_position:x", from_target_position_x, 0.1).set_trans(Tween.TRANS_CUBIC)
			#await target_move_tween.finished
			#await get_tree().create_timer(0.1).timeout
			for target in to_targets:
				#target.play_sound("damage", quiet)
				for i in times:
					target.take_damage(value,quiet)
					if target.cur_health <= 0:
						break
		Effect.Type.BLOCK:
			from_target.play_sound("block", quiet)
			for target in to_targets:
				target.take_block(value)
		Effect.Type.HEAL:
			from_target.play_sound("heal", quiet)
			for target in to_targets:
				target.heal(value)
		Effect.Type.ENHANCE:
			from_target.play_sound("enhance", quiet)
			for target in to_targets:
				target.take_buff(effect, value)
				target.calc_buff()
		Effect.Type.WEAK:
			from_target.play_sound("hex", quiet)
			for target in to_targets:
				target.take_buff(effect, value)
				target.calc_buff()
		Effect.Type.BLEED:
			#from_target.play_sound("attack")
			for target in to_targets:
				target.take_buff(effect, value)
				target.calc_buff()
		Effect.Type.POISON:
			from_target.play_sound("hex", quiet)
			for target in to_targets:
				target.take_buff(effect, value)
				target.calc_buff()
		Effect.Type.LOCK:
			pass
		Effect.Type.BURN:
			pass
		Effect.Type.STUN:
			from_target.play_sound("attack", quiet)
			for target in to_targets:
				target.make_stun()
		Effect.Type.NULL:
			Funcs.SFX.get_node("error").play()
		Effect.Type.SHIELD:
			from_target.play_sound("enhance", quiet)
			for target in to_targets:
				target.take_buff(effect, value)
				target.calc_buff()
	is_in_action = false


