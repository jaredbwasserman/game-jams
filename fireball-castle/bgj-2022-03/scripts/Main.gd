extends Node


func _on_UI_restart_signal():
	get_tree().reload_current_scene()
	get_tree().paused = false
