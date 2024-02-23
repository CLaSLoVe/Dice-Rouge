class_name PlayerBase
extends CharacterBase


func _after_ready():
	add_to_group("player")

func _on_texture_rect_gui_input(event):
	if event.is_action_pressed("left_mouse"):
		Funcs.SFX.get_node("deny").play()

func get_target(target):
	var player = [get_tree().get_first_node_in_group("player")]
	var enemies = get_tree().get_nodes_in_group("enemies")
	match target:
		Effect.Target.SELF:
			return [self]
		Effect.Target.OPPOSITE:
			return [Actions.selected_enemy]
		Effect.Target.OPPOSITES:
			return enemies
		Effect.Target.EVERYONE:
			return player + enemies


func do_action(effect:Effect, quiet=false):
	if not effect:
		return
	Funcs.FUTURE.add_text("[color=green]"+character.char_name+"[/color] "+effect.text)
	var from_target = get_target(effect.base_target)[0]
	var to_target = get_target(effect.to_target)
	additional_action(effect, from_target, to_target)
	await Actions.do_action(effect, from_target, to_target, self, quiet)


func _after_die():
	Funcs.FUTURE.add_text("[color=Indianred]"+character.char_name+" 死亡[/color]")
	Funcs.FUTURE.add_text("\n[color=Indianred]--- 游戏结束 ---[/color]")
	self.set("modulate", Color.TRANSPARENT)
	Event.lose.emit()


func play_sound(which, quiet):
	if quiet:
		return
	var choices
	match which:
		"attack":
			sfx.get_node(which).stream = Funcs.select_from_array(character.attack_audios)
		"block":
			sfx.get_node(which).stream = Funcs.select_from_array(character.block_audios)
		"enhance":
			sfx.get_node(which).stream = Funcs.select_from_array(character.enhance_audios)
		"heal":
			sfx.get_node(which).stream = Funcs.select_from_array(character.heal_audios)
		"damage":
			sfx.get_node(which).stream = Funcs.select_from_array(character.damage_audios)
		"hex":
			sfx.get_node(which).stream = Funcs.select_from_array(character.hex_audios)

	if sfx.get_node(which).stream:
		sfx.get_node(which).play()
		await sfx.get_node(which).finished



func make_stun():
	Funcs.HAND.lock_hand()
	
	
func _after_calc_buff():
	Event.attr_changed.emit()
