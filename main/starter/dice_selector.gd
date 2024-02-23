extends Control

@onready var dice_mini_ui = $DiceMiniUI
@onready var button = $Button
@onready var panel = $Panel

var dice: Dice

func _ready():
	Event.dice_selector_selected.connect(_on_dice_selector_selected)


func init():
	dice_mini_ui.set_dice(dice)
	




func _on_dice_selector_selected(selector):
	
	if selector == self:
		button.disabled = true
		get_tree().get_first_node_in_group("manager").custom_dice = dice
		panel.show()
		
	else:
		button.disabled = false
		panel.hide()
		
func _on_button_pressed():
	Funcs.SFX.get_node("button").play()
	Event.dice_selector_selected.emit(self)
