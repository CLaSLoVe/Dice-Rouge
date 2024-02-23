extends VBoxContainer

@onready var button = $box/Button
@onready var cbox = $cbox
@onready var rich_text_label = $box/Button/TextureRect/RichTextLabel
@onready var texture_rect = $box/Button/TextureRect
@onready var buttonlabel = $box/Button/buttonlabel

func _ready():
	Event.skill_selected.connect(_on_skill_selected)
	Event.init_award.connect(_on_init_award)

func check_duplicate():
	for skill in get_tree().get_first_node_in_group('skills').get_children():
		if Funcs.symbols2str(cbox.get_child(0).effect.symbols) in Funcs.skills.keys():
			texture_rect.show()
			var cur_skill = Funcs.skills[Funcs.symbols2str(cbox.get_child(0).effect.symbols)]
			rich_text_label.text = '将替换 '+cur_skill.text.text+'\n'+cur_skill.desc.text

func check_available():
	if cbox.get_children():
		if Funcs.COUNTER.cur_money < cbox.get_child(0).prize:
			button.disabled = true


func _on_skill_selected():
	check_available()

func _on_button_pressed():
	button.disabled = true
	Funcs.COUNTER.cur_money -= cbox.get_child(0).prize
	Event.attr_changed.emit()
	Funcs.SFX.get_node("button").play()
	if cbox.get_children():
		cbox.get_child(0).reparent(get_tree().get_first_node_in_group('skills'))
	Funcs.get_skills()
	Event.skill_selected.emit()

func _on_init_award():
	button.disabled = true
	if cbox.get_children():
		cbox.get_child(0).reparent(get_tree().get_first_node_in_group('inactive_skills'))
	buttonlabel.text = ''
