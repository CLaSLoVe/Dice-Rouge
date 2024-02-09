class_name Skill
extends Resource

enum Target {SELF, EVERYONE, ENEMIES, ENEMY}
enum Type {ATTACK, BLOCK, HEAL, WEAK, ENHANCE, POISON, SHIELD, BLEED, PURIFY}
enum Stage {PLAYER_TURN_START, PLAYER_TURN_END}
enum Rely {STRENTH, MEDICAL, MAGIC, DEFENCE, INIT_STRENTH, INIT_MEDICAL, INIT_DEFENCE, HEALTH, MAX_HEALTH}

@export var skill_name: String
@export var prize: int = 10
@export var type: Type
@export var rely_on: Rely
@export var bias: int = 0
@export var mag: float = 1.0
@export var times: int = 1
@export var target: Target
@export var discard_on: Stage
@export var skill_comb: Array[Symbol]
@export var related_buff: Buff
@export_multiline var skill_description: String
