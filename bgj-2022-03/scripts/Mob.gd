extends KinematicBody

# Speed limits
export var min_speed = 1
export var max_speed = 35

# Radius to start accelerating
export var accel_radius = 40

# Radius can attack
export var att_radius = 3

# Amount of damage per attack
export var att_damage = 1

# Navigation of Room
onready var nav: Navigation = $"../Navigation"

# Player
onready var player: KinematicBody = $"/root/Main/Player"

# Speed
var speed = min_speed

# Able to attack (based on timer)
var can_attack = true

# Path
var path = []

# Current path node
var current_node = 0


func _ready():
	get_tree().set_debug_collisions_hint(false)


func dist_to_player():
	var player_dir = player.global_transform.origin - global_transform.origin
	return player_dir.length()


func try_attack():
	if can_attack and dist_to_player() <= att_radius:
		player.find_node("Stats").take_damage(att_damage)
		can_attack = false
		$AttTimer.start()


func _physics_process(delta):
	# Try to attack
	try_attack()

	# Move
	if current_node < path.size():
		var path_dir: Vector3 = path[current_node] - global_transform.origin
		path_dir.y = 0
		if path_dir.length() < 1:
			current_node += 1
		else:
			# Rotation
			var pivot = $Pivot
			pivot.look_at(path[current_node], Vector3.UP)
			pivot.rotation = Vector3(0, pivot.rotation.y, 0)

			# Movement
			speed = lerp(
				speed,
				max_speed,
				clamp(1 - dist_to_player()/accel_radius, 0, 1)
			)
			move_and_slide(path_dir.normalized() * speed)


func update_path():
	path = nav.get_simple_path(
		global_transform.origin,
		player.global_transform.origin
	)
	current_node = 0


func _on_MoveTimer_timeout():
	update_path()


func _on_AttTimer_timeout():
	print("reset att")
	can_attack = true
	$AttTimer.stop()
