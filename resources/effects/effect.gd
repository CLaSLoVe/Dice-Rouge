class_name Effect
extends Resource

enum Type {ATTACK, BLOCK, HEAL, ENHANCE, POISON, BLEED, WEAK, LOCK, BURN, STUN, NULL, SHIELD}

enum Target {SELF, OPPOSITE, OPPOSITES, EVERYONE}

enum FromStatu {NULL, STRENTH, DEFENCE, MEDICAL, INIT_STRENTH, INIT_DEFENCE, INIT_MEDICAL, }
enum ToStatu {NULL, STRENTH, DEFENCE, MEDICAL}

const SPELL = preload("res://Art/Picture/symbols/spell.png")
@export var text: String
@export var type: Type
@export_multiline var tooltip: String
@export var icon: Texture = SPELL

@export var base_target: Target
@export var base_statu: FromStatu
@export var to_target: Target
@export var to_statu: ToStatu

@export_range(0, 9999) var times: int = 1
@export var magnitude: float = 1.0
@export var bias: int = 0
@export_range(-1, 9999) var countdown: int = -1
@export var on_turn: bool = true
@export var buff: Buff
@export var symbols: Array[Symbol]
