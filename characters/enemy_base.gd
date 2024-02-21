class_name EnemyBase
extends CharacterBase


@onready var next = $VBoxContainer/Bar/next
@onready var next_icon = $VBoxContainer/Bar/next/next_icon
@onready var attackvalue = $VBoxContainer/Bar/next/attackvalue





const NULL_action = preload("res://resources/effects/null.tres")

var next_action: Effect

var activate = false


func _after_ready():
	Event.enemy_die.connect(_on_enemy_die)
	if not selectable:
		texture_rect.set("modulate", Color.TRANSPARENT)
	Event.set_target.connect(_on_set_target)
	set_next_action()
	#for skill in enemy_skills:
		#f_label.text += skill.text+"\n"

func set_target():
	print("选择了 ", character.char_name)
	Funcs.SFX.get_node("target").play()
	Event.set_target.emit()
	target.show()
	Actions.selected_enemy = self
	Funcs.SHOT.make_predict()

func _on_set_target():
	target.hide()

func _on_texture_rect_gui_input(event):
	if event.is_action_pressed("left_mouse") and alive:
		if selectable or get_tree().get_nodes_in_group("enemies").size()==1:
			set_target()
		else:
			Funcs.SFX.get_node("deny").play()

var die_tween: Tween


func _after_die():
	Funcs.FUTURE.add_text("[color=Indianred]"+character.char_name+" 死亡[/color]")
	remove_from_group("enemies")
	if Actions.selected_enemy == self:
		Actions.selected_enemy = null
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	Event.enemy_die.emit(self)

	
	die_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	die_tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.3)
	await die_tween.finished
	
	if not enemies:
		Event.win.emit(Funcs.COUNTER.cur_layer)
	
	queue_free()


func play_sound(which, quiet):
	if quiet:
		return
	var choice
	match which:
		"attack":
			choice = Funcs.SFX.get_node("slash")
		"block":
			choice = Funcs.SFX.get_node("block")
		"enhance":
			pass
		"heal":
			pass
		"damage":
			choice = Funcs.SFX.get_node("orc_damage")
		"hex":
			choice = Funcs.SFX.get_node("magic")
	if choice:
		choice.play()
		await choice.finished



func _on_enemy_die(char):
	if not activate:
		return
	if char == self:
		return
	if get_tree().get_nodes_in_group("enemies").size() == 1:
		if not selectable:
			selectable = true
			select_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
			select_tween.tween_property(texture_rect, "modulate", Color.WHITE, 0.2)
		set_target()
	elif get_tree().get_nodes_in_group("enemies").size() > 1:
		Funcs.select_from_enemy()

func _after_calc_buff():
	attackvalue.set("modulate", Color.WHITE)
	if next_action.type == Effect.Type.ATTACK:
		attackvalue.text = str(Actions.calc_value(next_action, get_target(next_action.base_target)[0]))
		if next_action.times>1:
			attackvalue.text += "x"+str(next_action.times)
	else:
		attackvalue.text = ""

func set_next_action():
	if character.mimic:
		next_action = NULL_action
	else:
		next_action = character.enemy_skills[Funcs.rand_choice_with_p(character.p_array)]
		
	calc_buff()
	reset_next_graphic()



	
func do_action():
	its_turn = true
	
	Funcs.FUTURE.add_text("[color=Indianred]"+character.char_name+"[/color] "+next_action.text)
	
	var cur_modulate = texture_rect.modulate
	select_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	select_tween.tween_property(texture_rect, "modulate", Color.WHITE, 0.3)
	await select_tween.finished
	var from_target = get_target(next_action.base_target)[0]
	var to_target = get_target(next_action.to_target)
	additional_action(next_action, from_target, to_target)
	await Actions.do_action(next_action, from_target, to_target, self)
	if not selectable:
		Funcs.SFX.get_node("dive").play()
	select_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	select_tween.tween_property(texture_rect, "modulate", cur_modulate, 0.2)
	await select_tween.finished
	
	
	its_turn = false

func get_target(target):
	var player = [get_tree().get_first_node_in_group("player")]
	var enemies = get_tree().get_nodes_in_group("enemies")
	match target:
		Effect.Target.SELF:
			return [self]
		Effect.Target.OPPOSITE:
			return player
		Effect.Target.OPPOSITES:
			return player
		Effect.Target.EVERYONE:
			return player + enemies
			


func make_stun():
	if stun_immune:
		Funcs.SFX.get_node("deny").play()
		return
	next_action = NULL_action
	calc_buff()
	reset_next_graphic()
	
func reset_next_graphic():
	next_icon.set("modulate", Color.WHITE)
	next_icon.texture = next_action.icon
	if next_action.type in [Effect.Type.ATTACK, Effect.Type.BLOCK, Effect.Type.NULL, Effect.Type.HEAL, Effect.Type.ENHANCE]:
		next.tooltip_text = next_action.text
	else:
		next.tooltip_text = "某个特殊动作"
	
func set_mimic():
	if character.mimic and Funcs.SHOT.current_effect:
		next_action = Funcs.SHOT.current_effect
		calc_buff()
		reset_next_graphic()


#func calc_single_var
