class_name Buff
extends Resource



@export var label: String
@export var debuff: bool = false
@export var on_turn: bool = true
@export var icon: Texture
@export var countdown: int = 2
@export var rely_on: Skill.Rely
@export var discard_on: Skill.Stage
@export_multiline var description: Array[String]
