extends Node2D

@onready var enemies = $Enemies
@onready var enemies_2 = $Enemies2
@onready var character_temp = $CharacterTemp

var enemy_template = {}


#func _ready():
	#init()
	#for child in character_temp.get_children():
		#enemy_template[child.character.char_name] = child
	#print(enemy_template)




func set_enemies(level):
	pass




func init():
	for child in enemies.get_children()+enemies_2.get_children():
		if not child.character.is_player:
			child.add_to_group("enemies")
			child.init()
			child.activate = true
		
	
