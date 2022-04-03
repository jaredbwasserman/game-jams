extends Spatial

# Damage to inflict
export var damage = 4

# Current victim
var victim


func _inflict_damage():
	victim.find_node("Stats").take_damage(damage)


func _on_Area_body_entered(body):
	if not body.is_in_group("player"):
		return

	victim = body
	_on_AttTimer_timeout()
	$AttTimer.start()


func _on_Area_body_exited(body):
	$AttTimer.stop()
	victim = null


func _on_AttTimer_timeout():
	_inflict_damage()
