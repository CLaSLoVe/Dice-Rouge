extends Control

@onready var battle = $Battle
@onready var win_ui = $WinUI
@onready var start_page = $StartPage
@onready var showcase = $StartPage/SelectChar/showcase
@onready var confirm_char = $StartPage/confirm_char


var custom_dice: Dice


func _ready():
	#win_ui.init()
	#win_ui.hide()
	Event.win_ui_pop_up.connect(_on_win_ui_pop_up)
	Event.next_turn_start.connect(_on_next_turn_start)
	Event.dice_selector_selected.connect(_on_dice_selector_selected)

var win_ui_tween: Tween

func _on_win_ui_pop_up():
	win_ui.init()
	win_ui.set("modulate", Color.TRANSPARENT)
	win_ui.show()
	win_ui_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	win_ui_tween.tween_property(win_ui, "modulate", Color.WHITE, 0.5)
	




var start_page_tween: Tween

func _on_confirm_char_pressed():
	
	# start game!
	if start_page.confirm_stage == 1:
		start_page.confirm_stage = 0
		Funcs.SFX.get_node("button").play()
		var selected_player = showcase.get_child(0)
		battle.set_player(selected_player.character, selected_player.init_strenth, selected_player.init_defence, selected_player.init_medical, selected_player.max_health-selected_player.damage, selected_player.max_health)
		battle.set("modulate", Color.TRANSPARENT)
		battle.show()
		#start_page_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		#start_page_tween.tween_property(start_page, "modulate", Color.TRANSPARENT, 0.5)
		#await start_page_tween.finished
		battle.init_battle()
		start_page.hide()
		start_page_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		start_page_tween.tween_property(battle, "modulate", Color.WHITE, 0.3)
		await start_page_tween.finished
		await get_tree().create_timer(0.5).timeout

func _on_dice_selector_selected(selector):
	confirm_char.disabled = false

func _on_next_turn_start():
	win_ui_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	win_ui_tween.tween_property(win_ui, "modulate", Color.TRANSPARENT, 0.5)
	win_ui.hide()
	battle.next_battle()
