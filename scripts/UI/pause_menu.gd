extends Control

@onready var pause_menu = $"."
@onready var buttons_v_box = $CanvasLayer/MarginContainer/VBoxContainer/ButtonsVBox

func _ready():
	print('are we getting ready???')
	focus_button()

func _on_continue_game_button_pressed():
	get_tree().paused = false
	queue_free()

func _on_quit_game_button_pressed():
	get_tree().quit()

func _on_visibility_changed():
	if visible:
		focus_button()

func focus_button() -> void:
	if buttons_v_box:
		var button: Button = buttons_v_box.get_child(0)
		if button is Button:
			button.grab_focus()
