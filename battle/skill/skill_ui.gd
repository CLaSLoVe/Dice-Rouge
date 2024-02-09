extends Control


@export var skill: Skill
@onready var label = $Comb/Label
@onready var description = $Description
@onready var comb = $Comb

var code: String
	
func _ready():
	for i in range(1, 6):
		get_node("Comb/t"+str(i)).texture = null
	label.text = skill.skill_name
	for i in range(skill.skill_comb.size()):
		get_node('Comb/t'+str(i+1)).texture = skill.skill_comb[i].icon
	description.text = skill.skill_description
	
	var skill_array = []
	for sym in skill.skill_comb:
		skill_array.append(str(sym.id))
	code = "".join(skill_array)
	
