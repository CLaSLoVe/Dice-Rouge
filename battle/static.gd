extends Control

@onready var round_label = $Round
@onready var floor_label = $Floor

var round = 1
var floor = 1

func _ready():
	Events.battle_counter_update.connect(_on_battle_counter_update)
	_on_battle_counter_update(1, 1)
	
func _on_battle_counter_update(a, b):
	round = a
	floor = b
	round_label.text = "第"+str(round)+"回合"
	floor_label.text = "第"+str(floor)+"层"
