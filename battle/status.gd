extends Control

@onready var var_bar = $Status/VarBar

#func _ready():
	#Event.attr_changed.connect(reset)
	#reset()


func reset():
	for bar in var_bar.get_children():
		bar.reset()
