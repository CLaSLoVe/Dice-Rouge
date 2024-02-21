class_name Character
extends Resource

const SINGLE_ATTACK = preload("res://resources/effects/single_attack.tres")
const BLOCK = preload("res://resources/effects/block.tres")

@export var char_name: String
@export var is_player:bool=false

@export var alive: bool = true
@export_range(0, 300) var size: int = 100
@export var icon: Texture


@export_group("for enemy")

@export var selectable = true
@export var init_damage_per_turn: int = 0

@export var stun_immune: bool = false
@export var mimic: bool = false
@export var invincible_with_pal = false
@export var make_bleed = false
@export var make_poison = false

@export var enemy_skills: Array[Effect] = [SINGLE_ATTACK, BLOCK]
@export var p_array: Array[int] = [7, 3]

const _39_BLOCK_03 = preload("res://Art/sfx/39_Block_03.wav")
const _07_HUMAN_ATK_SWORD_1 = preload("res://Art/sfx/07_human_atk_sword_1.wav")
@export_group("audio")
@export var attack_audios: Array[AudioStreamWAV] = [_07_HUMAN_ATK_SWORD_1]
@export var block_audios: Array[AudioStreamWAV] = [_39_BLOCK_03]
@export var enhance_audios: Array[AudioStreamWAV] 
@export var heal_audios: Array[AudioStreamWAV] 
@export var damage_audios: Array[AudioStreamWAV]
@export var hex_audios: Array[AudioStreamWAV]
