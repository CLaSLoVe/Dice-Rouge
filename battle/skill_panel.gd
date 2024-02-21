extends Control

@onready var needs = $Needs
@onready var text = $Text
@onready var desc = $Desc

@export var effect: Effect
@export var sellable: bool = true
@export var prize: int = 20

var value = ""
var result = ""

#func _ready():
	#reset()
	
func reset():
	var player = get_tree().get_first_node_in_group("player")
	if not effect:
		return
	match effect.to_target:
		Effect.Target.SELF:
			result = "自身 "
		Effect.Target.OPPOSITE:
			result = "选定敌方 "
		Effect.Target.OPPOSITES:
			result = "所有敌方 "
	value = "[color=white]["+str(Actions.calc_value(effect, player.get_target(effect.base_target)[0]))+"][/color]"
	for i in range(effect.tooltip.length()):
		match effect.tooltip[i]:
			'?':
				result += value
			'&':
				result += str(effect.countdown)
			'B':
				result += str(effect.bias)
			'M':
				result += str(effect.magnitude*100)+'%'
			'T':
				result += str(effect.times)
			_:
				result += effect.tooltip[i]
	match effect.type:
		Effect.Type.ATTACK:
			text.text = "[color=orange]"+effect.text
		Effect.Type.ENHANCE:
			text.text = "[color=yellow]"+effect.text
		Effect.Type.BLOCK:
			text.text = "[color=skyblue]"+effect.text
		Effect.Type.HEAL:
			text.text = "[color=green]"+effect.text
		Effect.Type.WEAK:
			text.text = "[color=pink]"+effect.text
		Effect.Type.BLEED:
			text.text = "[color=orange]"+effect.text
		Effect.Type.POISON:
			text.text = "[color=pink]"+effect.text
		Effect.Type.LOCK:
			text.text = "[color=pink]"+effect.text
		Effect.Type.BURN:
			text.text = "[color=orange]"+effect.text
		Effect.Type.STUN:
			text.text = "[color=white]"+effect.text
		Effect.Type.SHIELD:
			text.text = "[color=yellow]"+effect.text
	desc.text = result

	for i in range(effect.symbols.size()):
		needs.get_node("t"+str(i+1)).texture = effect.symbols[i].icon


