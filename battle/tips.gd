extends Control


@onready var tip_panel = $TipPanel
@onready var grid_container = $TipPanel/GridContainer

var tween: Tween

const fade_seconds = 0.1


func _ready():
	tip_panel.set("modulate", Color.TRANSPARENT)
	tip_panel.show()
	Event.attr_changed.connect(reset)
	
	Funcs.get_skills()


func reset():
	for panel in grid_container.get_children():
		panel.reset()


func _on_button_button_up():
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(tip_panel, "modulate", Color.TRANSPARENT, fade_seconds)


func _on_button_button_down():
	Funcs.SFX.get_node("book").play()
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(tip_panel, "modulate", Color.WHITE, fade_seconds)
