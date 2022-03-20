extends Room

export var east_open = true
export var south_open = true
export var west_open = true
export var north_open = true


func _ready():
	if east_open:
		$EastWall.set_collision_layer_bit(5, true)
	else:
		$EastWall.set_collision_layer_bit(2, true)
		$EastDoor.queue_free()

	if south_open:
		$SouthWall.set_collision_layer_bit(5, true)
	else:
		$SouthWall.set_collision_layer_bit(2, true)
		$SouthDoor.queue_free()

	if west_open:
		$WestWall.set_collision_layer_bit(5, true)
	else:
		$WestWall.set_collision_layer_bit(2, true)
		$WestDoor.queue_free()

	if north_open:
		$NorthWall.set_collision_layer_bit(5, true)
	else:
		$NorthWall.set_collision_layer_bit(2, true)
		$NorthDoor.queue_free()
