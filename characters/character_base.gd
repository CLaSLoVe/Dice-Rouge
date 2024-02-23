class_name CharacterBase
extends Node

@onready var block_var = $VBoxContainer/Bar/HBoxContainer/BlockVar
@onready var health_bar = $VBoxContainer/Bar/HBoxContainer/HealthBar/HealthBar
@onready var texture_rect = $VBoxContainer/Character/TextureRect
@onready var health_label = $VBoxContainer/Bar/HBoxContainer/HealthBar/Label
@onready var target = %Target
@onready var future = %future
@onready var buff_bar = %BuffBar
@onready var features_panel = %Features
@onready var f_label = %Features/HBoxContainer/labels/Label
@onready var status = %Status

@onready var sfx = $SFX
@onready var main_sfx = $SFX/main_sfx

@export var character: Character

@export var init_strenth: int = 5
@export var init_defence: int = 5
@export var init_medical: int = 6
@export var max_health: int = 20

const BUFF_ICON = preload("res://battle/buff_icon.tscn")
const MI_SFX_27 = preload("res://Art/sfx/MI_SFX 27.wav")
const BLEED = preload("res://resources/effects/onlyforenemies/bleed.tres")
const POISON = preload("res://resources/effects/poison.tres")
const POISON_1 = preload("res://resources/effects/onlyforenemies/poison_1.tres")


var add_strenth: int = 0
var add_defence: int = 0
var add_medical: int = 0

var cur_block: int = 0
var cur_health
var cur_strenth
var cur_defence
var cur_medical
var buff_array


var alive: bool = true

var make_bleed
var make_poison
var stun_immune: bool = false
var selectable = true

var init_damage_per_turn: int = 0
var add_damage_per_turn = 0

var init_damage_per_shot: int = 0
var add_damage_per_shot: int = 0

var max_take_damage = 9999
var min_take_damage = 0


var its_turn = false


func init():
	# data
	#init_strenth = character.init_strenth
	#init_defence = character.init_defence
	#init_medical = character.init_medical
	#max_health = character.max_health
	make_bleed = character.make_bleed
	make_poison = character.make_poison
	stun_immune = character.stun_immune
	selectable = character.selectable
	init_damage_per_turn = character.init_damage_per_turn
	
	# feature board
	if character.is_player:
		f_label.text = "[center][color=green][玩家][/color] "+character.char_name+"[/center]\n"
	else:
		f_label.text = "[center][color=red][敌对][/color] "+character.char_name+"[/center]\n"
		if stun_immune:
			f_label.text += "无法被[color=orange]晕眩[/color]\n"
		if character.invincible_with_pal:
			f_label.text += "存在[color=green]队友[/color]时[color=orange]无敌[/color]\n"
		if character.mimic:
			f_label.text += "[color=purple]模仿[/color]你最后的[color=orange]行动[/color]"
		if not character.selectable:
			f_label.text += "存在[color=green]队友[/color]时[color=gray]潜行[/color]\n"
		if make_bleed:
			f_label.text += "[color=red]攻击[/color]时造成[color=orange]撕裂[/color]\n"
		if make_poison:
			f_label.text += "[color=red]攻击[/color]时造成"+str(POISON_1.countdown)+"层[color=green]中毒[/color]\n"
		f_label.text += "[font_size=15]\n[color=purple][技能][/color] "
		for skill in character.enemy_skills:
			f_label.text += skill.text+" "
		
	target.hide()
	texture_rect.texture = character.icon
	texture_rect.custom_minimum_size.y = character.size
	texture_rect.set("modulate", Color.DIM_GRAY)
	features_panel.set("modulate", Color.TRANSPARENT)
	
	# init
	if not cur_health:
		cur_health = max_health
	
	for statu in status.get_children():
		statu.font_size = 25
		statu.set_character(self)
		statu.reset()
	
	add_to_group("everyone")
	_after_ready()
	reset()	



func play_sound(which, quiet):
	pass
		


var bar_tween: Tween

func reset():
	health_label.text = str(cur_health)+"/"+str(max_health)
	health_bar.max_value = max_health
	block_var.text = str(cur_block)
	bar_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	bar_tween.tween_property(health_bar, "value", cur_health, 0.08)
	await bar_tween.finished

func take_damage(value, quiet=false):
	if value <= 0:
		return
	value = clampi(value, min_take_damage, max_take_damage)
	if (not character.is_player) and character.invincible_with_pal and get_tree().get_nodes_in_group("enemies").size()>1:
		Funcs.SFX.get_node("invincible").play()
		return
	for child in buff_bar.get_children():
		if child.effect.type == Effect.Type.SHIELD and child.countdown >= 1:
			Funcs.SFX.get_node("invincible").play()
			child.counting()
			child.reset()
			return
	if value <= cur_block:
		Funcs.FUTURE.add_text("[font_size=15]"+character.char_name+"[color=skyblue]格挡[/color]了"+str(value)+"伤害[/font_size]")
		cur_block -= value
	else:
		var after_health = clampi(cur_health + cur_block - value, 0, max_health)
		play_sound("damage", quiet)
		if cur_block > 0:
			Funcs.FUTURE.add_text("[font_size=15]"+character.char_name+"[color=skyblue]格挡[/color]了"+str(cur_block)+"伤害[/font_size]")
		Funcs.FUTURE.add_text("[font_size=15]"+character.char_name+"受到了"+str(cur_health-after_health)+"[color=orange]伤害[/color][/font_size]")
		Event.take_damage.emit(self, cur_health-after_health)
		cur_health = after_health
		cur_block = 0
	await reset()
	if cur_health <= 0:
		die()
		#return
		
func take_block(value):
	cur_block = clampi(cur_block+value, 0, 9999)
	reset()

func clear_block():
	cur_block = 0
	reset()
	
func heal(value):
	cur_health = clampi(cur_health + value, 0, max_health)
	await reset()
	
func take_buff(effect:Effect, value:int):
	if effect.type == Effect.Type.POISON or effect.type == Effect.Type.SHIELD:
		for child in buff_bar.get_children():
			if child.effect.type == effect.type:
				child.countdown += effect.countdown
				child.reset()
				return
	var new_buff = BUFF_ICON.instantiate()
	new_buff.effect = effect
	new_buff.value = value
	new_buff.character = self
	buff_bar.add_child(new_buff)
	new_buff.init()
	new_buff.reset()
	

func die():
	if not alive:
		return
	alive = false
	_after_die()

func counting():
	for buff in buff_bar.get_children():
		if buff.effect.on_turn:
			buff.counting()




func set_future(text):
	future.text = text
	
func calc_buff():
	var sum_add_strenth = 0
	var sum_add_defence = 0
	var sum_add_medical = 0
	
	add_damage_per_turn = 0
	add_damage_per_shot = 0
	
	for buff in buff_bar.get_children():
		if buff.countdown <= 0:
			continue
		match buff.effect.type:
			Effect.Type.ENHANCE:
				match buff.effect.to_statu:
					Effect.FromStatu.STRENTH:
						sum_add_strenth += buff.value
					Effect.FromStatu.DEFENCE:
						sum_add_defence += buff.value
					Effect.FromStatu.MEDICAL:
						sum_add_medical += buff.value
			Effect.Type.WEAK:
				match buff.effect.to_statu:
					Effect.FromStatu.STRENTH:
						sum_add_strenth -= buff.value
					Effect.FromStatu.DEFENCE:
						sum_add_defence -= buff.value
					Effect.FromStatu.MEDICAL:
						sum_add_medical -= buff.value
			Effect.Type.POISON:
					add_damage_per_turn = buff.countdown
			Effect.Type.BLEED:
					add_damage_per_shot = buff.value
			
	add_strenth = sum_add_strenth
	add_defence = sum_add_defence
	add_medical = sum_add_medical
	
	cur_strenth = clampi(init_strenth + add_strenth, 1, 9999)
	cur_defence = clampi(init_defence + add_defence, 1, 9999)
	cur_medical = clampi(init_medical + add_medical, 1, 9999)
	
	add_strenth = cur_strenth - init_strenth
	add_defence = cur_defence - init_defence
	add_medical = cur_medical - init_medical
	Event.attr_changed.emit()
	_after_calc_buff()


func take_turn_damage():
	for buff in buff_bar.get_children():
		if not buff:
			continue
		if buff.effect.buff.on == Buff.Stage.TURN_END:
			buff.play("poison")
	await take_damage(add_damage_per_turn+init_damage_per_turn, true)


func take_shot_damage():
	for buff in buff_bar.get_children():
		if buff.effect.buff.on == Buff.Stage.SHOT:
			buff.play("bleed")
	await take_damage(init_damage_per_shot+add_damage_per_shot, true)
	


func additional_action(effect, from_target, to_target):
	if effect.type == Effect.Type.ATTACK:
		if make_bleed:
			await Actions.do_action(BLEED, from_target, to_target, self, true)
		if make_poison:
			await Actions.do_action(POISON_1, from_target, to_target, self, true)


func clear_buff():
	for buff in buff_bar.get_children():
		buff.exit()


func get_target(char):
	pass

func _after_calc_buff():
	pass


func _after_ready():
	pass

func _after_die():
	pass

var tween: Tween
var fade_seconds = 0.2

var select_tween: Tween

func slow_show():
	
	select_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	select_tween.tween_property(texture_rect, "modulate", Color.WHITE, 0.1)
	await select_tween.finished

func slow_hide():
	
	#if select_tween.is_running():
		#select_tween.kill()
	select_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	if selectable or character.is_player:
		select_tween.tween_property(texture_rect, "modulate", Color.DIM_GRAY, 0.1)
	else:
		select_tween.tween_property(texture_rect, "modulate", Color.TRANSPARENT, 0.1)


func _on_mouse_entered():
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(features_panel, "modulate", Color.WHITE, fade_seconds)
	if not its_turn:
		slow_show()


func _on_mouse_exited():
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(features_panel, "modulate", Color.TRANSPARENT, fade_seconds)
	if not its_turn:
		#if not character.is_player and Actions.selected_enemy == self:
			#return
		slow_hide()
