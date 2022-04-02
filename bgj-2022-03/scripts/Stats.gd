extends Node

class_name Stats

signal dead_signal

# Max HP param
export var max_hp = 10

# Current HP
var cur_hp = max_hp


func take_damage(damage):
	cur_hp -= damage
	
	# print("Unit ", get_parent().get_name(), " take damage ", damage, " new hp ", cur_hp, " / ", max_hp )
	
	if cur_hp <= 0:
		emit_signal("dead_signal")
