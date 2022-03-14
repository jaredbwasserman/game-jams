extends Camera

# Camera smoothing
export var smooth = true
export var smooth_speed = 0.1

# Target for camera
export var target_path: String = ""

# Padding
export var padding_x = 0
export var paddinx_z = 0

# Offsets
export var offset_y = 50
export var offset_z = 50

# Some variables
var ground_size_x_half
var ground_size_z_half


func _ready():
	set_process(true)

	# Init vars
	var mesh_size = get_node("/root/Main/Ground/MeshInstance").mesh.size
	ground_size_x_half = mesh_size.x/2
	ground_size_z_half = mesh_size.z/2

func _process(delta):
	var target = get_node(target_path).get_translation()
	var camera = get_node(".")
	var camera_size_half = camera.get_size()
	var camera_size_half_z = camera_size_half * 0.707107 # sqrt(2)/2

	var clamp_x = clamp(
		target.x,
		-ground_size_x_half + camera_size_half - padding_x,
		ground_size_x_half - camera_size_half + padding_x
	)

	var clamp_y = target.y + offset_y

	var clamp_z = clamp(
		target.z + offset_z,
		-ground_size_z_half + camera_size_half_z + offset_z - paddinx_z,
		ground_size_z_half - camera_size_half_z + offset_z + paddinx_z
	)

	var new_pos = Vector3(clamp_x, clamp_y, clamp_z)

	if smooth:
		var new_lerp = camera.translation.linear_interpolate(new_pos, smooth_speed)
		camera.set_translation(new_lerp)
	else:
		camera.set_translation(new_pos)
