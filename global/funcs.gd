extends Node


var SHOT
var HAND
var TRASH
var JOB

var SKILLS

var DATA
var SFX
var COUNTER
var FUTURE

func _ready():
	SHOT = get_tree().get_first_node_in_group("shot")
	HAND = get_tree().get_first_node_in_group("hand")
	TRASH = get_tree().get_first_node_in_group("trash")
	JOB = get_tree().get_first_node_in_group("job")
	SFX = get_tree().get_first_node_in_group("sfx")
	COUNTER = get_tree().get_first_node_in_group("counter")
	SKILLS = get_tree().get_first_node_in_group("skills")
	FUTURE = get_tree().get_first_node_in_group("future")

func symbols2str(symbols, with_mirror:bool=false):
	if with_mirror:
		if not symbols:
			return ""
		elif symbols[0].type == Symbol.Type.MIRROR:
			return ""
		for i in range(symbols.size()):
			if symbols[i].type == Symbol.Type.MIRROR:
				symbols[i] = symbols[i-1]
	var res = ''
	for symbol in symbols:
		res += str(symbol.type)
	return res

var skills

func get_skills():
	skills = {}
	for skill in Funcs.SKILLS.get_children():
		skills[symbols2str(skill.effect.symbols)] = skill

func sum(array: Array[int]):
	var res = 0
	for i in array:
		res += i
	return res

func rand_choice_with_p(array: Array[int]):
	var sum_p = sum(array)
	var p_array: Array[int]
	
	p_array.append(array[0])
	for i in range(1, array.size()):
		p_array.append(array[i]+p_array[i-1])
	
	var cur = randi()%sum_p+1
	
	for i in range(p_array.size()):
		if cur <= p_array[i]:
			return i


func select_from_array(array:Array):
	if array.size() == 1:
		return array[0]
	if array.size() > 1:
		return array[randi() % array.size()]
	return null



func select_from_enemy():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var target_set = false
	for enemy in enemies:
		if enemy.character.selectable:
			enemy.set_target()
			target_set = true
			break
	if not target_set:
		Event.set_target.emit()
		Actions.selected_enemy = null


func check_selectable_enemy_exist():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var selectable_enemy_exist = false
	for enemy in enemies:
		if enemy.selectable:
			selectable_enemy_exist = true
			break
	return selectable_enemy_exist
			
