extends HBoxContainer


@export var strike: int = 0
@onready var strike_label = $strike


func _ready():
	Events.strike_update.connect(_on_strike_update)
	
	
func _on_strike_update(value):
	strike += value
	strike_label.text = "暴击："+str(strike)
