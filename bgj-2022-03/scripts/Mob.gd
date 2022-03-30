extends KinematicBody

# Speed
export var speed = 15

# Navigation of Room
onready var nav: Navigation = $"../Navigation"

# Player
onready var player: KinematicBody = $"/root/Main/Player"

# Path
var path = []

# Current path node
var current_node = 0


func _physics_process(delta):
	if current_node < path.size():
		var direction: Vector3 = path[current_node] - global_transform.origin
		direction.y = 0
		if direction.length() < 1:
			current_node += 1
		else:
			var pivot = $Pivot
			pivot.look_at(path[current_node], Vector3.UP)
			pivot.rotation = Vector3(0, pivot.rotation.y, 0)
			move_and_slide(direction.normalized() * speed)


func update_path(target_position):
	path = nav.get_simple_path(global_transform.origin, target_position)
	current_node = 0


func _on_Timer_timeout():
	update_path(player.global_transform.origin)
