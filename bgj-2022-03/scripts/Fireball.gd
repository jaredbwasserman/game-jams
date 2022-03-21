extends KinematicBody

# Base and max spell speed
export var base_spell_speed = 50

# Minimum spell speed
export var min_spell_speed = 10

# Base spell light range
export var base_spell_light_range = 10

# Base spell light energy
export var base_spell_light_energy = 0.5

# Lower value means faster charge rate
export var spell_mult_inverse = 15

# Max spell power
export var max_spell_power = 5

# Raw spell charge
var spell_charge_raw = 0

# Spell charge
var spell_charge = 0

# Velocity of spell
var velocity = Vector3.ZERO


func add_charge(spell_charge_amount):
	spell_charge_raw += spell_charge_amount

	# Clamp charge
	spell_charge = clamp(
		spell_charge_raw / spell_mult_inverse,
		1,
		max_spell_power
	)

	# Update size
	_update_spell_size()


func _update_spell_size():
	# Scale
	$Spatial/Ball.set_scale(Vector3(spell_charge, spell_charge, spell_charge))
	$Spatial/BallShadow.set_scale(Vector3(spell_charge, spell_charge, spell_charge))
	$Spatial/BallParticles.set_scale(Vector3(spell_charge, spell_charge, spell_charge))
	$CollisionShape.set_scale(Vector3(spell_charge, spell_charge, spell_charge))
	$VisibilityNotifier.set_scale(Vector3(spell_charge, spell_charge, spell_charge))

	# Light range
	$Spatial/Light.omni_range = base_spell_light_range * spell_charge

	# Light energy
	$Spatial/Light.light_energy = base_spell_light_energy * spell_charge


func shoot(new_rotation):
	# Use global coordinates
	set_as_toplevel(true)

	# Update velocity
	var speed = clamp(
		base_spell_speed - ((spell_charge - 1) * 0.05 * base_spell_speed),
		min_spell_speed,
		base_spell_speed
	)
	velocity = Vector3.FORWARD * speed
	velocity = velocity.rotated(Vector3.UP, new_rotation.y)

	# Enable collisions
	$CollisionShape.disabled = false


func _physics_process(_delta):
	move_and_slide(velocity)
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		if collision:
			queue_free()


func _on_VisibilityNotifier_camera_exited(camera):
	queue_free()
