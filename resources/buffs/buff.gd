class_name Buff
extends Resource

enum Stage {INSTANT, SHOT, TURN_END, TURN_START}

@export var text: String
@export var icon: Texture

@export var on: Stage
