extends Control

@onready var grid_container = $GridContainer

@export var custom_dices: Array[Dice]


func _ready():
	var dice_grids = grid_container.get_children()
	for i in range(dice_grids.size()):
		dice_grids[i].dice = custom_dices[i]
		dice_grids[i].init()


