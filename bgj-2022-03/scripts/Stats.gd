extends Node

class_name Stats

signal took_damage_signal
signal dead_signal

# Max HP param
export var max_hp = 10

# Current HP
var cur_hp = max_hp


func take_damage(damage):
	# print(get_parent().get_name(), " took ", damage, ", now ", cur_hp, " / ", max_hp )
	cur_hp -= damage
	emit_signal("took_damage_signal")
	if cur_hp <= 0:
		emit_signal("dead_signal")
