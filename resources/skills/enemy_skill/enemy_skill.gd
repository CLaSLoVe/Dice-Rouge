class_name EnemySkill
extends Resource

enum Target {SELF, ENEMIES, ENEMY}
enum Type {ATTACK, BLOCK, HEAL, WEAK, ENHANCE, POISON, SHIELD, BLEED}
enum Stage {PLAYER_TURN_START, PLAYER_TURN_END}


@export var skill_name: String
@export var icon: Texture
@export var value: int
@export var type: Type
@export var mag: float = 1.0
@export var variance: float = 0.2
@export var times: int = 1
@export var target: Target
@export var discard_on: Stage
@export var related_buff: Buff
@export_multiline var skill_description: String
