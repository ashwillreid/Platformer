extends Control

@onready var buttons_v_box = $MarginContainer/VBoxContainer/ButtonsVBox
@onready var game_manager = %GameManager
@onready var start_game_button = $MarginContainer/VBoxContainer/ButtonsVBox/StartGameButton

signal start_game()

func _ready() -> void:
	focus_button()

func _on_start_game_button_pressed() -> void:
	start_game.emit()
	hide()
	
func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
		
func focus_button() -> void:
	if buttons_v_box:
		var button: Button = start_game_button 
		
		if button is Button:
			button.grab_focus()
