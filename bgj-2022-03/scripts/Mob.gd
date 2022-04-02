extends KinematicBody

class_name Mob

# Speed limits
export var min_speed = 1
export var max_speed = 25

# Radius to start accelerating
export var accel_radius = 40

# Radius can attack
export var att_radius = 3.5

# Amount of damage per attack
export var att_damage = 2

# Player
onready var player: KinematicBody = $"/root/Main/Player"

# Speed
var speed = min_speed

# Able to attack (based on timer)
var can_attack = true

# Spawn point
var spawn_point

# Movement target
var target


func enable():
	_on_MoveTimer_timeout()
	$MoveTimer.start()

	set_physics_process(true)


func disable_and_reset():
	$MoveTimer.stop()

	$Pivot/Face/LeftEye.visible = false
	$Pivot/Face/RightEye.visible = false

	set_physics_process(false)

	global_transform.origin = spawn_point
	speed = min_speed


func _ready():
	spawn_point = global_transform.origin
	disable_and_reset()


func _dist_to_player():
	var player_dir = player.global_transform.origin - global_transform.origin
	return player_dir.length()


func _try_attack():
	if can_attack and _dist_to_player() <= att_radius:
		$AttAnim.play("attack")

		player.find_node("Stats").take_damage(att_damage)
		can_attack = false
		$AttTimer.start()


func _physics_process(delta):
	# Try to attack
	_try_attack()

	# Rotation
	var pivot = $Pivot
	pivot.look_at(target, Vector3.UP)
	pivot.rotation = Vector3(0, pivot.rotation.y, 0)

	# Movement
	var dir = target - global_transform.origin
	speed = lerp(
		speed,
		max_speed,
		clamp(1 - _dist_to_player()/accel_radius, 0, 1)
	)
	move_and_slide(dir.normalized() * speed)

	# Open eyes
	if speed > max_speed/2:
		$Pivot/Face/LeftEye.visible = true
		$Pivot/Face/RightEye.visible = true


func _on_MoveTimer_timeout():
	target = player.global_transform.origin


func _on_AttTimer_timeout():
	$AttAnim.stop()
	$AttAnim.play("RESET")

	can_attack = true
	$AttTimer.stop()
