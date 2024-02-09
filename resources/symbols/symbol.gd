class_name Symbol
extends Resource

enum Type {ATTACK, BLOCK, HEAL, MAGIC, POWER, MISTAKE, BLANK, MIMIC}

@export var id: int
@export var type: Type
@export var icon: Texture
@export_multiline var tooltip_text: String
