extends Control

@onready var job_box = $Job
@onready var job_area = $JobArea
@onready var job_mana = $JobMana
@onready var lock = $Lock

var tween: Tween
var lock_tween: Tween
# Called when the node enters the scene tree for the first time.
func _ready():
	lock.set("modulate", Color.TRANSPARENT)
	Event.dice_to_job.connect(_on_dice_to_job)
	reset()


func _on_dice_to_job():
	job_area.monitorable = false
	if Funcs.COUNTER.cur_job <= 0:
		return
	
	var dice_ui: DiceUI = job_box.get_child(0)
	var ui_layer = get_tree().get_first_node_in_group("ui_layer")
	match get_tree().get_first_node_in_group("player").character.job_name:
		"flip":
			await dice_ui.make_change("reverse")
		"shuffle":
			await dice_ui.make_change("shuffle")
		"mirror":
			await dice_ui.make_change("mirror")
		"attack":
			await dice_ui.make_change("attack")
	dice_ui.reparent(ui_layer)
	tween = get_tree().create_tween()
	tween.tween_property(dice_ui, "position", Funcs.HAND.get_node("b"+str(dice_ui.id)).global_position, 0.05).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
	dice_ui.to_hand()
	Event.dice_to_hand.emit()
	
	Funcs.COUNTER.cur_job -= 1
	update_job_mana_label()
		
func update_job_mana_label():
	job_mana.text = "[center]x "+str(Funcs.COUNTER.cur_job)
	if Funcs.COUNTER.cur_job > 0:
		job_area.monitorable = true
		lock_tween = get_tree().create_tween()
		lock_tween.tween_property(lock, "modulate", Color.TRANSPARENT, 0.3).set_trans(Tween.TRANS_CUBIC)
	else:
		job_area.monitorable = false
		Funcs.SFX.get_node("chain").play()
		lock_tween = get_tree().create_tween()
		lock_tween.tween_property(lock, "modulate", Color.WHITE, 0.3).set_trans(Tween.TRANS_CUBIC)


func reset():
	Funcs.COUNTER.cur_job = Funcs.COUNTER.max_job
	update_job_mana_label()
