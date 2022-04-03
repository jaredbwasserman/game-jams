extends Room

class_name SquareRoom

export var east_open = true
export var south_open = true
export var west_open = true
export var north_open = true


func set_east_open(value: bool):
	east_open = value
	_update_doors()


func set_south_open(value: bool):
	south_open = value
	_update_doors()


func set_west_open(value: bool):
	west_open = value
	_update_doors()


func set_north_open(value: bool):
	north_open = value
	_update_doors()


func _ready():
	_update_doors()


func _update_doors():
	if east_open:
		$EastWall.set_collision_layer_bit(5, true)
		$EastWall.set_collision_layer_bit(2, false)
		$EastDoor.visible = true
	else:
		$EastWall.set_collision_layer_bit(5, false)
		$EastWall.set_collision_layer_bit(2, true)
		$EastDoor.visible = false

	if south_open:
		$SouthWall.set_collision_layer_bit(5, true)
		$SouthWall.set_collision_layer_bit(2, false)
		$SouthDoor.visible = true
	else:
		$SouthWall.set_collision_layer_bit(5, false)
		$SouthWall.set_collision_layer_bit(2, true)
		$SouthDoor.visible = false

	if west_open:
		$WestWall.set_collision_layer_bit(5, true)
		$WestWall.set_collision_layer_bit(2, false)
		$WestDoor.visible = true
	else:
		$WestWall.set_collision_layer_bit(5, false)
		$WestWall.set_collision_layer_bit(2, true)
		$WestDoor.visible = false

	if north_open:
		$NorthWall.set_collision_layer_bit(5, true)
		$NorthWall.set_collision_layer_bit(2, false)
		$NorthDoor.visible = true
	else:
		$NorthWall.set_collision_layer_bit(5, false)
		$NorthWall.set_collision_layer_bit(2, true)
		$NorthDoor.visible = false
