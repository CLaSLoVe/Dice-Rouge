extends VBoxContainer

@onready var button = $box/Button
@onready var cbox = $cbox

func _ready():
	Event.relic_selected.connect(_on_relic_selected)
	Event.init_award.connect(_on_init_award)

func _on_relic_selected():
	button.disabled = true
	if cbox.get_children():
		cbox.get_child(0).reparent(get_tree().get_first_node_in_group('inactive_relic'))

func _on_button_pressed():
	Funcs.SFX.get_node("button").play()
	if cbox.get_children():
		cbox.get_child(0).reparent(get_tree().get_first_node_in_group('active_relic'))
	Event.relic_selected.emit()

func _on_init_award():
	button.disabled = false
