extends HBoxContainer
@onready var skills = $Skills


var skills_array = {}


func _ready():
	Events.update_skills.connect(update_skills)

func update_skills():
	skills_array = {}
	for skill in skills.get_children():
		var skill_array = []
		for sym in skill.skill.skill_comb:
			skill_array.append(str(sym.id))
		skills_array["".join(skill_array)] = skill.skill

