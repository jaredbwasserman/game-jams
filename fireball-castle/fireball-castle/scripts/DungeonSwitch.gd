extends Node

onready var living_room: SquareRoom = get_node(
	"/root/Main/RoomsRoot/RoomsManager/RoomsList/LIVING ROOM"
)


func _on_Switch_body_entered(body):
	$Switch.trigger()
	get_parent().set_east_open(true)
	living_room.set_west_open(true)
	living_room.set_north_open(true)
