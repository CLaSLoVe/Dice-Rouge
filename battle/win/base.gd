extends Control

@onready var preload_award_ui = $Preload
@onready var awards_box = $AwardsBox
@onready var skip = $Skip
@onready var win_ui = $".."
@onready var health_deck = $"../Relax/health"

@onready var relax = $"../Relax"
@onready var smith = $"../Smith"
@onready var store = $"../Store"


func _ready():
	set_awards()
	Events.award_choice.connect(_on_award_choice)
	#Events.award_finished.connect(_on_award_finished)

func set_awards():
	var p: Array[int]
	var n = 0
	var empty_box = []
	for box in awards_box.get_children():
		if not box.get_children():
			n += 1
			empty_box.append(box)
	for i in range(3-n+1, 4):
		for award in preload_award_ui.get_children():
			p.append(award.award.p)
		var selected_award = preload_award_ui.get_children()[Funcs.rand_choice_with_p(p)]
		selected_award.reparent(empty_box[0])
		empty_box.erase(empty_box[0])
		p = []

func reset_awards():
	for i in range(1, 4):
		var award = awards_box.get_node("b"+str(i)).get_child(0)
		award.reset()
		if award and not award.award.stay:
			award.reparent(preload_award_ui)


func _on_award_choice(label):
	match label:
		"empty":
			pass
		"smith":
			smith.visible = true
			self.visible = false
		"relax":
			relax.visible = true
			self.visible = false
			get_tree().get_first_node_in_group("status").reset_all()
			get_tree().get_first_node_in_group("status").reparent(relax)
			get_tree().get_first_node_in_group("status").position.x = 300
			get_tree().get_first_node_in_group("status").position.y = 100
			health_deck.get_node("Data").text = str(get_tree().get_first_node_in_group("player").max_health)
		"medicine":
			get_tree().get_first_node_in_group("player").heal(9999)
			exit()
		"store":
			store.visible = true
			self.visible = false
			store.init()

func _on_skip_pressed():
	exit()


func exit():
	Actions.sfx.get_node("DoorSFX").play()
	reset_awards()
	set_awards()
	self.visible = true
	Events.award_finished.emit()
	var tween = get_tree().create_tween()
	tween.tween_property(win_ui, "position:y", -1080, 2).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
	
