extends KinematicBody

# Emitted when entering a new room
signal new_room_entered

# How fast the player moves horizontally in meters per second
export var speed = 14

# The downward acceleration when in the air, in meters per second squared
export var fall_acceleration = 75

# Vertical impulse applied to the character upon jumping in meters per second.
export var jump_impulse = 30

# Spell to shoot
export (PackedScene) var spell_scene

# Lower value means faster charge rate
export var spell_mult_inverse = 15

# Max spell power
export var max_spell_power = 5

# Velocity of player
var velocity = Vector3.ZERO

# Spell charge of the player
var spell_charge = 0

# Room of player
var room


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

	# Power up spell
	if Input.is_action_pressed("shoot"):
		spell_charge += 1

	# Shoot spell
	if Input.is_action_just_released("shoot"):
		var spell = spell_scene.instance()
		room.add_child(spell)

		# Clamp charge
		spell_charge = clamp(
			spell_charge / spell_mult_inverse,
			1,
			max_spell_power
		)

		# Init spell
		spell.initialize(
			$Pivot.global_transform.origin,
			$Pivot.rotation,
			spell_charge
		)
		spell_charge = 0

	# Jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse

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
	return space_state.intersect_ray(from, to, [], 16) # Collide with ground


func _on_Area_area_entered(area):
	emit_signal("new_room_entered", area)
	room = area
