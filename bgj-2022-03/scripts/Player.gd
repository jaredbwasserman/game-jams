extends KinematicBody

onready var game_over = $"/root/Main/UI/GameOver"

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

# Room label
var room_label

# Health bar
var health_bar


func _ready():
	# Room
	room_label = get_parent().get_node("UI/RoomLabel")

	# Health
	health_bar = get_parent().get_node("UI/HealthBar")
	health_bar.set_max_health($Stats.max_hp)
	_update_health_bar()


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
		$CastAnim.play("cast")
		$CastAnim.playback_speed = 4

		_init_spell_if_needed()
		_update_spell_pos()
		spell.add_charge(1)

	# Shoot spell
	if Input.is_action_just_released("shoot"):
		$CastAnim.stop()
		$CastAnim.play("RESET")

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

	direction = direction.normalized()

	# Move more slowly while charging spell
	var speed = max_speed
	if spell:
		speed = clamp(
			speed - 5 * spell.spell_charge,
			min_speed,
			max_speed
		)

	# Animation
	if direction != Vector3.ZERO and is_on_floor():
		$WalkAnim.play("walk")
		$WalkAnim.playback_speed = clamp(
			4 * speed/max_speed,
			1,
			4
		)
	else:
		$WalkAnim.stop()
		$WalkAnim.play("RESET")

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
	# Room label
	room_label.text = area.get_parent().name

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


func _update_health_bar():
	health_bar.set_health($Stats.cur_hp)


func _on_Stats_took_damage_signal():
	$DamageAnim.play("damage")
	_update_health_bar()


func _on_Stats_dead_signal():
	$"/root/Main".get_tree().paused = true
	game_over.show()
