extends Control

@onready var panels_pile = $Panels
@onready var symbols_pile = $Symbols

const DICE_MINI_STYLE_BOX_FLAT_WHITE = preload("res://battle/dice/dice_mini_style_box_flat_white.tres")
const DICE_MINI_STYLE_BOX_FLAT_YELLOW = preload("res://battle/dice/dice_mini_style_box_flat_yellow.tres")


func select(num: int):
	for i in range(1, 7):
		panels_pile.get_node("Panel"+str(i)).set("theme_override_styles/panel", DICE_MINI_STYLE_BOX_FLAT_WHITE)
	panels_pile.get_node("Panel"+str(num)).set("theme_override_styles/panel", DICE_MINI_STYLE_BOX_FLAT_YELLOW)

func set_dice(dice: Dice):
	for i in range(1, 7):
		symbols_pile.get_node("t"+str(i)).texture = dice.symbols[i-1].icon
