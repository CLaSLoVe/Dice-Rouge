extends VBoxContainer

@onready var box = $box
@onready var button = $hbc/Button
@onready var label = $hbc/Label
@onready var label_2 = $hbc/Label2
@onready var rich_text_label = $RichTextLabel

var prize: int

var duplicated = false


func _ready():
	Events.update_store_state.connect(_on_update_store_state)

func evaluate():
	if prize > get_tree().get_first_node_in_group("status").money or not box.get_children():
		button.disabled = true
	else:
		button.disabled = false


func _on_button_pressed():
	if duplicated:
		for skill in get_tree().get_first_node_in_group("skill_container").get_children():
			if skill.code == box.get_child(0).code:
				skill.reparent(get_tree().get_first_node_in_group("skill_template"))
	Actions.sfx.get_node("MoneySFX").play()
	button.disabled = true
	Events.store_choose.emit(box.get_child(0), prize)

		
func _on_update_store_state():
	evaluate()
	Events.update_skills.emit()
	duplicated = check_duplicate()
	
		


func check_duplicate():
	if box.get_children() and box.get_child(0).code in get_tree().get_first_node_in_group("skills").skills_array.keys():
		var this_skill = get_tree().get_first_node_in_group("skills").skills_array[box.get_child(0).code]
		label.text = '存在重复组合'
		label_2.text = '[color=black]替换[/color][color=blue]'+this_skill.skill_name
		rich_text_label.text = this_skill.skill_description
		return true
	else:
		label.text = ''
		label_2.text = ''
		rich_text_label.text = ''
		return false

