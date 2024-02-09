extends Control
@onready var h_box_container = $HBoxContainer
@onready var base = $"../Base"

func _ready():
	Events.relax_choice.connect(_on_relax_choice)



func _on_relax_choice(array):
	for emit_things in array:
		var id = emit_things[0]
		var data = emit_things[1]
		
		match id:
			"health":
				get_tree().get_first_node_in_group("player").max_health += data
				get_tree().get_first_node_in_group("player").health += data
				get_tree().get_first_node_in_group("player").fresh_health()
			"magic":
				get_tree().get_first_node_in_group("status").init_magic += data
			"strenth":
				get_tree().get_first_node_in_group("status").init_strenth += data
			"defence":
				get_tree().get_first_node_in_group("status").init_defence += data
			"medical":
				get_tree().get_first_node_in_group("status").init_medical += data
		
		get_tree().get_first_node_in_group("status").reset_all()
	exit()

func exit():
	for child in h_box_container.get_children():
		child.reset()
		child._ready()
	get_tree().get_first_node_in_group("status").reparent(get_tree().get_first_node_in_group("ui_layer"))
	self.visible = false
	base.exit()

func _on_cancel_2_pressed():
	exit()
	
