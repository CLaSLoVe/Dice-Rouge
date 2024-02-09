extends Control

@onready var floor_label = $EndWords/Sentence1/Label3
@onready var skills_label = $EndWords/Sentence2/Label3


func _ready():
	self.modulate = Color.TRANSPARENT
	self.visible = false
	


func init():
	self.visible = true
	Funcs.slowly_show(self, Color.WHITE, .5)
	skills_label.text = str(get_tree().get_first_node_in_group("skill_container").get_children().size())
	floor_label.text = str(get_tree().get_first_node_in_group("main_battle").at_floor)
	
