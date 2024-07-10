extends Node

# SCNENES TO INSTANTIATE
const MAIN_MENU = preload("res://scenes/ui/menus/main_menu.tscn")
const HUD = preload("res://scenes/ui/hud.tscn")
const LEVEL_1 = preload("res://scenes/levels/level_1.tscn")
const LEVEL_2 = preload("res://scenes/levels/level_2.tscn")
const PAUSE_MENU = preload("res://scenes/ui/menus/pause_menu.tscn")
const GAME_OVER_MENU = preload("res://scenes/ui/menus/game_over_menu.tscn")
#@onready var pause_menu = $"../PauseMenu"
#@onready var game_over = $"../GameOver"

#exported scene vars
@export_range (1, 2) var starting_level: int #TODO: MAKE THIS DYNAMICALLY INCREASE AS WE ADD LEVELS
@export var skip_menu = true
@export var maxHealth = 5

#local vars
var score: int = 0
var health: int
var current_level: int = starting_level

const levels = [LEVEL_1, LEVEL_2]

func _ready():
	health = maxHealth
	if skip_menu:
		handle_start_game()
	else:		
		var mainMenu = MAIN_MENU.instantiate()
		add_child(mainMenu)
		mainMenu.connect('start_game', handle_start_game)
	
func handle_pickup_coin():
	score += 1
	
func handle_damage():
	print('we in there')
	health -= 1

func load_level():
	var level = levels[current_level].instantiate()
	add_child(level)
	var hud = HUD.instantiate()
	add_child(hud)
	connect_coins(level)
	connect_player(level)

func end_level():
	var template = "/root/Game/GameManager/Level%s"
	var literal = template %(current_level + 1)
	#print('LITERAL????', literal)
	#print('tersfd',get_node(literal))
	get_node(literal).queue_free()

func set_level(level: int):
	current_level = level
	print('current level plz?', current_level)
	
func get_level():
	return current_level

func handle_start_game():
	print('starting!', starting_level)
	set_level(starting_level - 1)
	load_level()
	
func connect_coins(level: Node):
	var children = level.get_children()
	for child in children:
		if child.get_name() == 'Coins':
			var coins = child
			for coin in coins.get_children():
				coin.connect('pickup_coin', handle_pickup_coin)

func handle_pause():
	var pause_menu = PAUSE_MENU.instantiate()
	add_child(pause_menu)
	
func handle_death():
	var game_over_menu = GAME_OVER_MENU.instantiate()
	add_child(game_over_menu)

func connect_player(level: Node):
	var children = level.get_children()
	for child in children:
		if child.get_name() == 'SpawnPoint':
			var player = child.get_child(0)
			player.connect("damageTaken", handle_damage)
			player.connect("playerDied", handle_death)
			player.connect("pause", handle_pause)
