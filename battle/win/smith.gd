extends Control
@onready var dices = $Dices
@onready var texture_rect = $SmithDeck/TextureRect
@onready var recoin_button = $SmithDeck/Buttons/Recoin
@onready var confirm_button = $SmithDeck/Buttons/Confirm
@onready var base = $"../Base"

const MINI_DICE_UI = preload("res://battle/win/mini_dice_ui.tscn")
var trash = null

var selected_symbol

const ATTACK = preload("res://resources/symbols/attack.tres")
const BLOCK = preload("res://resources/symbols/block.tres")
const HEAL = preload("res://resources/symbols/heal.tres")
const MAGIC = preload("res://resources/symbols/magic.tres")
const POWER = preload("res://resources/symbols/power.tres")

var SYMBOLS = null

var to_symbol = null

func _ready():
	Events.smith_symbol_choice.connect(_on_smith_symbol_choice)
	Events.award_finished.connect(_on_award_finished)
	trash = get_tree().get_first_node_in_group("trash")
	get_dices()
	init()

func init():
	SYMBOLS = [ATTACK, BLOCK, HEAL, MAGIC, POWER]	
	recoin()

func get_dices():
	for dice in trash.get_children():
		if dice.editable:
			var mini_dice = MINI_DICE_UI.instantiate()
			mini_dice.name = 'd'+str(dice.dice_pos)
			mini_dice.dice_id = dice.dice_pos
			for i in (dice.symbols_array.size()):
				mini_dice.get_node("Symbols/s"+str(i+1)).texture = dice.symbols_array[i].icon
			dices.add_child(mini_dice)
			
func _on_smith_symbol_choice(dice_id, symbol_id):
	if to_symbol:
		confirm_button.disabled = false
	selected_symbol = [dice_id, symbol_id]
	for dice in dices.get_children():
		dice.reset_select()
	dices.get_node('d'+str(dice_id)).get_node("Outlines/s"+str(symbol_id+1)).visible = true


func recoin():
	to_symbol = SYMBOLS[randi() % SYMBOLS.size()]
	SYMBOLS.erase(to_symbol)
	texture_rect.texture = to_symbol.icon


func _on_recoin_pressed():
	recoin_button.disabled = true
	recoin()


func _on_confirm_pressed():
	Actions.sfx.get_node("CastSFX").play()
	
	recoin_button.disabled = true
	confirm_button.disabled = true
	for dice in trash.get_children():
		if dice.dice_pos == selected_symbol[0]:
			dice.symbols_array[selected_symbol[1]] = to_symbol
			dice.update_symbol_ui()
	texture_rect.texture = null
	dices.get_node("d"+str(selected_symbol[0])+"/Symbols/s"+str(selected_symbol[1]+1)).texture = to_symbol.icon
	to_symbol = null
	#for dice in trash.get_children():
		#dice.reparent(get_tree().get_first_node_in_group("hand").get_node("b"+str(dice.dice_pos)))
	#exit()

func reset():
	SYMBOLS = [ATTACK, BLOCK, HEAL, MAGIC, POWER]
	init()
	recoin_button.disabled = false
	
	for dice in dices.get_children():
		dice.reset_select()
	
	self.visible = false
	
func _on_cancel_pressed():
	reset()
	base.exit()
	
func _on_award_finished():
	reset()
