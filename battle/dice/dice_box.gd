extends CenterContainer

@onready var lock = $lock_box/lock
@onready var lock_box = $lock_box
@onready var animation_player = $lock_box/AnimationPlayer
@onready var up = $lock_box/up
@onready var down = $lock_box/down


func _ready():
	lock.hide()
	up.hide()
	down.hide()

func _on_lock_gui_input(event):
	if event.is_action_pressed("left_mouse"):
		Funcs.SFX.get_node("deny").play()


func make_lock():
	up.show()
	down.show()
	animation_player.play("lock")
	await animation_player.animation_finished
	Funcs.SFX.get_node("lock").play()
	lock.show()
	up.hide()
	down.hide()
	
func make_unlock():
	lock.hide()
	up.hide()
	down.hide()
