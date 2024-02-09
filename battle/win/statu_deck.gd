extends VBoxContainer

@onready var health = $health
@onready var magic = $magic
@onready var strenth = $strenth
@onready var defence = $defence
@onready var medical = $medical
@onready var button = $Button

var emit_things = []

var statu_array

func _ready():
	#Events.relax_choice.connect(_on_relax_choice)
	var health_plus = [1,2,3,4,5,6,7,8][Funcs.rand_choice_with_p([2,3,5,5,3,2,1,1])]
	var magic_plus = [1,2,3,4,5][Funcs.rand_choice_with_p([3,3,2,2,1])]
	var strenth_plus = [1,2,3][Funcs.rand_choice_with_p([3,2,1])]
	var defence_plus = [1,2,3][Funcs.rand_choice_with_p([3,2,1])]
	var medical_plus = [1,2,3][Funcs.rand_choice_with_p([3,2,1])]
	
	health.data = health_plus
	magic.data = magic_plus
	strenth.data = strenth_plus
	defence.data = defence_plus
	medical.data = medical_plus
	
	statu_array = [health, magic, strenth, defence, medical]
	var selected_status_ind = select_n(3, [3,1,2,2,2])
	var selected_status = []
	for i in selected_status_ind:
		selected_status.append(statu_array[i])
		statu_array[i].visible = true
		statu_array[i].update()
		emit_things.append([statu_array[i].id, statu_array[i].data])
	

func select_n(n:int, p:Array[int]):
	var array = []
	var res = []
	for i in range(p.size()):
		array.append(i)
	var pp = p.duplicate()
	for i in range(n):
		var ind = array[Funcs.rand_choice_with_p(pp)]
		res.append(ind)
		pp.erase(p[ind])
		array.erase(ind)
	return res


func _on_button_pressed():
	Events.relax_choice.emit(emit_things)

	#button.disabled = true
	

func reset():
	button.disabled = false
	emit_things = []
	for status in statu_array:
		status.visible = false
