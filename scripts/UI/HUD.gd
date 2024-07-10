extends CanvasLayer

@onready var score_label = $Panel/ScoreLabel
@onready var health_label = $Panel/HealthLabel


var game_manager: Node

func _ready():
	game_manager = get_parent()

func _process(_delta):
	if game_manager:
		if game_manager.score:
			score_label.text = "SCORE: " + str(game_manager.score)
		if game_manager.health:
			health_label.text = "HEALTH: " + str(game_manager.health)
