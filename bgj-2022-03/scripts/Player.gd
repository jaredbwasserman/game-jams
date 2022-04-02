extends KinematicBody

# Emitted when entering a new room
signal new_room_entered

# How fast the player moves horizontally in meters per second
export var min_speed = 10
export var max_speed = 32

# The downward acceleration when in the air, in meters per second squared
export var fall_acceleration = 75

# Vertical impulse applied to the character upon jumping in meters per second.
export var jump_impulse = 30

# Spell to shoot
export (PackedScene) var spell_scene

# Velocity of player
var velocity = Vector3.ZERO

# Spell of player
var spell


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
		_init_spell_if_needed()
		_update_spell_pos()
		spell.add_charge(1)

	# Shoot spell
	if Input.is_action_just_released("shoot"):
		_init_spell_if_needed()
		spell.shoot($Pivot.rotation)
		spell = null

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

	# Move more slowly while charging spell
	var speed = max_speed
	if spell:
		speed = clamp(
			speed - 5 * spell.spell_charge,
			min_speed,
			max_speed
		)

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


func _init_spell_if_needed():
	if not spell:
		spell = spell_scene.instance()
		add_child(spell)
		_update_spell_pos()


func _update_spell_pos():
	spell.set_translation(
		Vector3(0, 0, -3).rotated(Vector3.UP, $Pivot.rotation.y)
	)


func _on_RoomDetector_area_entered(area):
		# Fix camera
	emit_signal("new_room_entered", area)

	# Alert enemies
	for child in area.get_parent().get_children():
		if child is Mob:
			child.enable()


func _on_RoomDetector_area_exited(area):
	# Alert enemies
	for child in area.get_parent().get_children():
		if child is Mob:
			child.disable_and_reset()
