extends Control

@onready var money = $HBoxContainer/Money
@onready var current_floor = $HBoxContainer/CurrentFloor


var cur_layer: int = 1
var cur_round: int = 1
var cur_money = 15

@export var init_magic: int = 0
@export var max_job: int = 1

var cur_job
var cur_magic: int = 0

func _ready():
	cur_job = max_job
	reset()
	
	
func reset(init:bool=false):
	if init:
		cur_round = 1
	money.text = "[color=gold]金币 "+str(cur_money)
	current_floor.text = "第"+str(cur_layer)+"层 第"+str(cur_round)+"回合"
	
