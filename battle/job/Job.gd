extends VBoxContainer

@onready var button = $JobButton
@onready var true_box = $Box/TrueBox
@onready var job_area = $JobArea
@onready var xn = $Box/Labels/xn
@onready var color_rect = $Box/ColorRect
@onready var battle = $"../.."
@onready var sfx = %SFX

@export var max_credit: int = 2

@onready var credit = max_credit

func _ready():
	Events.credit_update_to.connect(_on_credit_update_to)
	Events.dice_into_job_box.connect(_on_dice_into_job_box)
	Events.dice_retrieve_from_job.connect(_on_dice_retrieve_from_job)
	xn.text = 'x' + str(max_credit)


func _on_button_pressed():
	var dice_uis = true_box.get_children()
	var dice_ui = dice_uis[0]
	var cur_symbol_id = Funcs.rand_dice(dice_ui)
	var hand = get_tree().get_first_node_in_group("hand")
	dice_ui.reparent(hand.get_node("b"+str(dice_ui.dice_pos)))
	button.disabled = true
	
	_on_credit_update_to(credit - 1)
	battle.instance_symbol_effect(dice_ui)
	sfx.get_node("JobSFX").play()
	
func _on_credit_update_to(value: int):
	credit = value
	xn.text = 'x' + str(value)
	if value > 0 and (not true_box.get_children()):
		job_area.set_deferred("monitorable", true)
	else:
		job_area.monitorable = false

func _on_dice_into_job_box():
	job_area.set_deferred("monitorable", false)
	button.disabled = false

func _on_dice_retrieve_from_job():
	if credit > 0 and (not true_box.get_children()):
		job_area.set_deferred("monitorable", true)
		button.disabled = true


func _on_job_area_area_entered(area):
	job_area.set_deferred("monitorable", false)


func _on_job_area_area_exited(area):
	if credit > 0 and (not true_box.get_children()):
		job_area.set_deferred("monitorable", true)


