extends KinematicBody

class_name Mob

# Speed
export var speed = 60

# Radius to start accelerating
export var accel_radius = 40

# Radius can attack
export var att_radius = 3.5

# Amount of damage per attack
export var att_damage = 2

# Player
onready var player: KinematicBody = $"/root/Main/Player"

# Able to move (based on timer)
var can_move = true

# Currently moving
var is_moving = false

# Able to attack (based on timer)
var can_attack = true

# Currently attacking
var is_attacking = false

# Dead
var is_dead = false


func enable():
	if is_dead:
		return

	set_physics_process(true)


func disable_and_reset():
	if is_dead:
		return

	set_physics_process(false)


func _ready():
	disable_and_reset()


func _dist_to_player():
	var player_dir = player.global_transform.origin - global_transform.origin
	return player_dir.length()


func _try_attack():
	if can_attack and _dist_to_player() <= att_radius:
		$AttAnim.play("attack")

		player.find_node("Stats").take_damage(att_damage)
		can_attack = false
		is_attacking = true
		$AttTimer.start()

	if is_attacking:
		$Pivot/Face/LeftEye.visible = true
		$Pivot/Face/RightEye.visible = true


func _try_move():
	if can_move and _dist_to_player() <= accel_radius:
		can_move = false
		is_moving = true
		$MoveTimer.start()

	if is_moving:
		$Pivot/Face/LeftEye.visible = true
		$Pivot/Face/RightEye.visible = true

		# Rotation
		var target = player.global_transform.origin
		var pivot = $Pivot
		pivot.look_at(target, Vector3.UP)
		pivot.rotation = Vector3(0, pivot.rotation.y, 0)

		# Movement
		var dir = target - global_transform.origin
		move_and_slide(dir.normalized() * speed)


func _physics_process(delta):
	$Pivot/Face/LeftEye.visible = false
	$Pivot/Face/RightEye.visible = false

	_try_attack()
	_try_move()


func _on_MoveTimer_timeout():
	is_moving = false
	$MoveTimer.stop()
	$MoveCooldownTimer.start()


func _on_MoveCooldownTimer_timeout():
	can_move = true
	$MoveCooldownTimer.stop()


func _on_AttTimer_timeout():
	is_attacking = false
	$AttTimer.stop()
	$AttCooldownTimer.start()


func _on_AttCooldownTimer_timeout():
	can_attack = true
	$AttCooldownTimer.stop()


func _on_Stats_took_damage_signal():
	$DamageAnim.play("damage")


func _on_Stats_dead_signal():
	$DeathAnim.play("die")
	$DeathTimer.start()

	disable_and_reset()
	$CollisionShape.disabled = true
	is_dead = true


func _on_DeathTimer_timeout():
	$DeathTimer.stop()
	visible = false
	global_transform.origin = Vector3(0, -1000, 0)
