class_name Spell
extends Resource


@export var spell_name: String
@export_multiline var description: String
@export var reusable: bool = true
@export  var delay: bool = false
@export var cost: int

@export var related_buff: Buff
@export var related_skill: Skill

