extends VBoxContainer

@onready var magic_ui = $Magic
@onready var strenth_ui = $Strenth
@onready var defence_ui = $Defence
@onready var medical_ui = $Medical

#@onready var health = $Health
#@onready var block = $Block

@export var init_magic: int = 0
@export var init_strenth: int = 5
@export var init_defence: int = 5
@export var init_medical: int = 5

@export var money: int = 10

@onready var sfx = %SFX

var strenth_plus: int = 0
var defence_plus: int = 0
var medical_plus: int = 0

var strenth: int
var defence: int
var medical: int
var magic: int = 0

func _ready():
	Events.magic_update.connect(magic_update)
	#Events.strenth_update.connect(_on_strenth_update)
	
	magic_ui.data.text = str(init_magic)
	
	strenth_ui.data.text = str(init_strenth)
	defence_ui.data.text = str(init_defence)
	medical_ui.data.text = str(init_medical)
	
	magic = init_magic
	strenth = init_strenth
	defence = init_defence
	medical = init_medical
	

func magic_update(value):
	magic += value
	magic_ui.data.text = str(magic)
	Events.magic_changed.emit()

func strenth_update(value):
	strenth_plus = value
	strenth = clampi(init_strenth + strenth_plus, 1, Actions.MAX_DATA)
	if value > 0:
		strenth_ui.plus.text = '+'+str(strenth - init_strenth)
		strenth_ui.plus.set("theme_override_colors/font_color", Color.GREEN)
	elif value < 0:
		strenth_ui.plus.text = '-'+str(init_strenth - strenth)
		strenth_ui.plus.set("theme_override_colors/font_color", Color.RED)
	else:
		strenth_ui.plus.text = ''
	

func reset_all():
	strenth = init_strenth
	strenth_ui.data.text = str(strenth)
	strenth_ui.plus.text = ''
	
	medical = init_medical
	medical_ui.data.text = str(medical)
	
	defence = init_defence
	defence_ui.data.text = str(defence)
	
	magic = init_magic
	magic_ui.data.text = str(magic)
