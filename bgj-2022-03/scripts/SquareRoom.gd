extends Room

export var east_open = true
export var south_open = true
export var west_open = true
export var north_open = true


func _ready():
	if east_open:
		$EastWall.queue_free()
	else:
		$EastDoor.queue_free()
		
	if south_open:
		$SouthWall.queue_free()
	else:
		$SouthDoor.queue_free()
		
	if west_open:
		$WestWall.queue_free()
	else:
		$WestDoor.queue_free()
		
	if north_open:
		$NorthWall.queue_free()
	else:
		$NorthDoor.queue_free()
