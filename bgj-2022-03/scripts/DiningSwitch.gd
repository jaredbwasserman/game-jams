extends Node

onready var foyer: SquareRoom = get_node(
	"/root/Main/RoomsRoot/RoomsManager/RoomsList/FOYER"
)
onready var living_room: SquareRoom = get_node(
	"/root/Main/RoomsRoot/RoomsManager/RoomsList/LIVING ROOM"
)


func _on_Switch_body_entered(body):
	$Switch.trigger()
	get_parent().set_west_open(true)
	living_room.set_east_open(true)
	foyer.set_west_open(true)
