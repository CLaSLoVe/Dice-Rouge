extends Control

@onready var money_label = $money/Label
@onready var shelf = $Shelf
@onready var skill_template_box = $SkillTemplate
@onready var cancel = $Cancel
@onready var base = $"../Base"

var skill_templates

const SIGMA = 1.5

func _ready():
	#init()
	Events.store_choose.connect(_on_store_choose)
	

func init():
	update_money_label()
	skill_templates = skill_template_box.get_children()
	var positions = shelf.get_children().size()
	var selected_skills = select_n_from_array(positions, skill_templates)
	
	for i in range(selected_skills.size()):
		selected_skills[i].reparent(shelf.get_node("b"+str(i+1)+'/box'))
		shelf.get_node("b"+str(i+1)).visible = true
		var prize = selected_skills[i].skill.prize + round(randfn(0,SIGMA))
		shelf.get_node("b"+str(i+1)).prize = prize
		shelf.get_node("b"+str(i+1)+"/hbc/Button").text = str(prize)+'   '
	Events.update_store_state.emit()


func update_money_label():
	money_label.text = str(get_tree().get_first_node_in_group("status").money)
	


func exit():
	var child
	for i in (shelf.get_children().size()):
		shelf.get_node("b"+str(i+1)).visible = false
		shelf.get_node("b"+str(i+1)+"/hbc/Button").disabled = false
		child = shelf.get_node("b"+str(i+1)+'/box').get_children()
		if child:
			child[0].reparent(skill_template_box)
		
	
	

func select_n_from_array(n, array:Array):
	if n >= array.size():
		return array
	var res = []
	var ind
	for i in range(n):
		ind = randi()%array.size()
		res.append(array[ind])
		array.erase(array[ind])
	return res


func _on_store_choose(skill, prize):
	skill.reparent(get_tree().get_first_node_in_group("skill_container"))
	get_tree().get_first_node_in_group("status").money -= prize
	update_money_label()
	Events.update_store_state.emit()



func _on_cancel_pressed():
	exit()
	self.visible = false
	base.exit()
