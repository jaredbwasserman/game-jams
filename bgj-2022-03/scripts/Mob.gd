extends KinematicBody

# Speed limits
export var min_speed = 1
export var max_speed = 35

# Radius to start accelerating
export var accel_radius = 60

# Navigation of Room
onready var nav: Navigation = $"../Navigation"

# Player
onready var player: KinematicBody = $"/root/Main/Player"

# RNG
var rng = RandomNumberGenerator.new()

# Speed
var speed = min_speed

# Path
var path = []

# Current path node
var current_node = 0


func _ready():
	rng.randomize()


func _physics_process(delta):
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
			var player_dir = player.global_transform.origin - global_transform.origin
			speed = lerp(
				min_speed,
				max_speed,
				clamp(1 - player_dir.length()/accel_radius, 0, 1)
			)
			move_and_slide(path_dir.normalized() * speed)


func update_path(target_position):
	path = nav.get_simple_path(global_transform.origin, target_position)
	current_node = 0


func _on_Timer_timeout():
	update_path(player.global_transform.origin)
