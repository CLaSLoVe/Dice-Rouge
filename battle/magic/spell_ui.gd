extends Control

@export var spell: Spell

@onready var cost = $HBoxContainer/cost
@onready var button = $HBoxContainer/Button
@onready var sfx = %SFX
@onready var rich_text_label = $RichTextLabel

var status = null

var usable = true


func _ready():
	cost.text = 'x'+str(spell.cost)
	rich_text_label.text = spell.description
	status = get_tree().get_first_node_in_group('status')
	evaluate()
	#Events.magic_update.connect(evaluate)
	Events.magic_changed.connect(evaluate)
	Events.player_round_start.connect(_on_player_round_start)
	Events.player_round_end.connect(_on_player_round_end)


func reset():
	button.disabled = false
	rich_text_label.modulate = Color.WHITE

func lock():
	button.disabled = true
	rich_text_label.modulate = Color.DIM_GRAY

func evaluate():
	if status.magic >= spell.cost and usable:
		reset()
	else:
		lock()
		
func _on_player_round_start():
	if spell.reusable:
		usable = true
	evaluate()
	
func _on_player_round_end():
	lock()


func _on_button_pressed():
	usable = false
	lock()
	Events.magic_update.emit(-spell.cost)
	Actions.spell_handle(spell)
	sfx.get_node("MagicSFX2").play()
	await sfx.get_node("MagicSFX2").finished
	if not spell.reusable:
		self.queue_free()

