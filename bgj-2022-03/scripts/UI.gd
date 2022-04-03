extends Control

signal restart_signal

onready var game_over = $GameOver
onready var game_win = $GameWin


func _ready():
	game_over.hide()
	game_win.hide()


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and (game_over.visible or game_win.visible):
		emit_signal("restart_signal")
