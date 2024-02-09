extends Control
@onready var select_sfx = $SelectSFX
@onready var outlines = $Outlines

@export var dice_id: int

func reset_select():
	for s in outlines.get_children():
		s.visible = false


func emit_sig(event, sig):
	
	if event.is_action_pressed("left_mouse"):
		select_sfx.play()
		Events.smith_symbol_choice.emit(dice_id, sig)

func _on_s_1_gui_input(event):
	emit_sig(event, 0)

func _on_s_2_gui_input(event):
	emit_sig(event, 1)

func _on_s_3_gui_input(event):
	emit_sig(event, 2)


func _on_s_4_gui_input(event):
	emit_sig(event, 3)


func _on_s_5_gui_input(event):
	emit_sig(event, 4)


func _on_s_6_gui_input(event):
	emit_sig(event, 5)
