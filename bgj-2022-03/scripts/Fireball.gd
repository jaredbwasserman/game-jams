extends KinematicBody

# Base and max spell speed
export var base_spell_speed = 50

# Minimum spell speed
export var min_spell_speed = 10

# Velocity of spell
var velocity = Vector3.ZERO


func _physics_process(_delta):
	move_and_slide(velocity)
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		if collision:
			queue_free()


func initialize(new_position, new_rotation, spell_charge):
	# Position
	global_transform.origin = new_position

	# Scale
	$Spatial/Ball.set_scale(Vector3(spell_charge, spell_charge, spell_charge))
	$Spatial/BallShadow.set_scale(Vector3(spell_charge, spell_charge, spell_charge))
	$Spatial/BallParticles.set_scale(Vector3(spell_charge, spell_charge, spell_charge))
	$CollisionShape.set_scale(Vector3(spell_charge, spell_charge, spell_charge))
	$VisibilityNotifier.set_scale(Vector3(spell_charge, spell_charge, spell_charge))

	# Light range
	$Spatial/Light.omni_range *= spell_charge

	# Light energy
	$Spatial/Light.light_energy *= spell_charge

	# Velocity
	var speed = clamp(
		base_spell_speed - ((spell_charge - 1) * 0.05 * base_spell_speed),
		min_spell_speed,
		base_spell_speed
	)
	velocity = Vector3.FORWARD * speed
	velocity = velocity.rotated(Vector3.UP, new_rotation.y)


func _on_VisibilityNotifier_camera_exited(camera):
	queue_free()
