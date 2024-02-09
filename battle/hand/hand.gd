extends HBoxContainer

@onready var box = $"../Shot/Box"
@onready var hand = %Hand

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.dice_right_clicked.connect(_on_dice_right_clicked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_dice_right_clicked(dice_ui):
	if dice_ui.get_parent().get_parent().name == "Hand":
		dice_ui.reparent(box)
	elif dice_ui.get_parent().get_parent().name == "Shot":
		dice_ui.reparent(hand.get_node("b"+str(dice_ui.dice_pos)))
