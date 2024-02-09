extends CharBase

@onready var buff = %Buff

const BUFF_UI = preload("res://battle/buff/buff_ui.tscn")

func get_buff(res, value):
	var buff_ui = BUFF_UI.instantiate()
	buff_ui.related_buff = res.related_buff
	buff_ui.value = value
	
	buff.add_child(buff_ui)
	buff_ui.set_text()
	Funcs.slowly_show(buff_ui)
	sfx.get_node("BuffSFX").play()
		
	Events.buff_update.emit()

func damage_sfx():
	sfx.get_node('PlayerHurtSFX').play()


func purify_debuff():
	for buff_i in buff.get_children():
		if buff_i.related_buff.debuff:
			buff_i.free()
	Events.buff_update.emit()
			
func purify_buff():
	for buff_i in buff.get_children():
		buff_i.free()
	Events.buff_update.emit()

func after_die():
	Events.battle_lose.emit()

