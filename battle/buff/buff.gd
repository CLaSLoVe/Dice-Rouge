extends HBoxContainer

@onready var player_status_ui = %StatusUI

func _ready():
	Events.buff_update.connect(_on_buff_update)
	
	
func _on_buff_update():
	var strenth_change = 0
	for buff in get_children():
		# change strenth
		if buff.related_buff.rely_on == Skill.Rely.STRENTH:
			strenth_change += buff.value
		# change health
		elif buff.related_buff.rely_on == Skill.Rely.HEALTH:
			pass
		
	player_status_ui.strenth_update(strenth_change)
	
