extends Spatial

onready var game_win = $"/root/Main/UI/GameWin"


func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		$"/root/Main".get_tree().paused = true
		game_win.show()
