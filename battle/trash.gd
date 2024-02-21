extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	for dice in get_children():
		dice.add_to_group("dice")
		dice.add_to_group("inactive_dice")
