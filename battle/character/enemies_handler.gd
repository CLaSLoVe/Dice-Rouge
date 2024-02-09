extends Control

@export var enemies: Array[CharacterBody2D]

@onready var enemy_template = $EnemyTemplate

var wolf = null

func _ready():
	wolf = enemy_template.get_node("Wolf")

func add(char, pos):
	var enemy_box = get_node("Enemy"+str(pos))
	if enemy_box:
		for child in enemy_box.get_children():
			child.queue_free()
		enemy_box.add_child(char)
		char.add_to_group('enemy')
		print('enemy spawn succeed.')
	else:
		print('enemy spawn failed.')


func add_wolf(pos:int, attr: Array):
	var _wolf = wolf.duplicate()
	_wolf.strenth = attr[0]
	_wolf.defence = attr[1]
	_wolf.max_health = attr[2]
	add(_wolf, pos)

func add_enemies(at_floor):
	match at_floor:
		1:
			add_wolf(1, [5, 5, 20])
		2:
			add_wolf(1, [5, 5, 20])
			add_wolf(2, [5, 5, 20])
		3:
			add_wolf(1, [8, 7, 20])
		4:
			add_wolf(1, [10, 7, 40])
			add_wolf(2, [10, 10, 60])
		5:
			add_wolf(1, [10, 10, 40])
			add_wolf(2, [7, 10, 40])
			add_wolf(3, [10, 10, 60])
		6:
			add_wolf(1, [15, 15, 65])
			add_wolf(2, [16, 16, 65])
		7:
			add_wolf(1, [20, 30, 100])
