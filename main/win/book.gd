extends Control


@onready var skillselector = $skillselector



func init():
	var inactive_skills = get_tree().get_first_node_in_group('inactive_skills').get_children()
	var p: Array[int]
	
	for i in range(inactive_skills.size()):
		p.append(1)
	
	var selected_skills = Funcs.select_n_with_p(inactive_skills, 8, p)
	for i in (selected_skills.size()):
		selected_skills[i].reparent(skillselector.get_node('skillbox'+str(i+1)+'/cbox'))
		selected_skills[i].reset()
		skillselector.get_node('skillbox'+str(i+1)+'/box/Button/buttonlabel').text = str(selected_skills[i].prize)
		skillselector.get_node('skillbox'+str(i+1)).button.disabled = false
		skillselector.get_node('skillbox'+str(i+1)).check_available()
		skillselector.get_node('skillbox'+str(i+1)).check_duplicate()
