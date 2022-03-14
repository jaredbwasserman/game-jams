extends KinematicBody

# Emitted when entering a new room
signal new_room_entered

# How fast the player moves horizontally in meters per second
export var speed = 14

# The downward acceleration when in the air, in meters per second squared
export var fall_acceleration = 75

# Velocity of player
var velocity = Vector3.ZERO


func _physics_process(delta):
	# Look at mouse
	var mouse_intersect = _get_mouse_intersect()
	if mouse_intersect:
		var mouse_pos: Vector3 = mouse_intersect.position
		var pivot = $Pivot
		mouse_pos.y = pivot.translation.y
		pivot.look_at(mouse_pos, Vector3.UP)

		# Fix rotation
		pivot.rotation = Vector3(0, pivot.rotation.y, 0)

	# Move
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)


# Get position of mouse in 3D space
func _get_mouse_intersect():
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_node("../PlayerCamera")
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000
	var space_state = get_world().get_direct_space_state()
	return space_state.intersect_ray(from, to)


func _on_Area_area_entered(area):
	emit_signal("new_room_entered", area)
