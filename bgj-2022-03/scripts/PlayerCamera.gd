extends Camera

# Camera smoothing
export var smooth = true
export var smooth_speed = 0.1

# Padding
export var padding_x = 0
export var padding_z = 0

# Offsets
export var offset_y = 50
export var offset_z = 50

# Some variables
var ground_mesh
var ground_pos
var ground_size_x_half
var ground_size_z_half


func _ready():
	# Init ground size
	var mesh_path = "/root/Main/RoomsRoot/RoomsManager/RoomsList/Room1/Ground/MeshInstance"
	ground_mesh = self.get_parent().get_node(mesh_path)
	_set_ground_params()

	set_process(true)


func _process(delta):
	var target = get_node("../Player").get_translation()
	var camera_size_half = self.get_size()

	var clamp_x = clamp(
		target.x,
		ground_pos.x - ground_size_x_half + camera_size_half - padding_x,
		ground_pos.x + ground_size_x_half - camera_size_half + padding_x
	)

	var clamp_y = target.y + offset_y

	var clamp_z = clamp(
		target.z,
		ground_pos.z - ground_size_z_half + camera_size_half - padding_z,
		ground_pos.z + ground_size_z_half - camera_size_half + padding_z
	) + offset_z

	var new_pos = Vector3(clamp_x, clamp_y, clamp_z)

	if smooth:
		var new_lerp = self.translation.linear_interpolate(new_pos, smooth_speed)
		self.set_translation(new_lerp)
	else:
		self.set_translation(new_pos)


func _set_ground_params():
	ground_pos = ground_mesh.global_transform.origin
	var mesh_size = ground_mesh.mesh.size
	ground_size_x_half = mesh_size.x/2
	ground_size_z_half = mesh_size.z/2


func _on_Player_new_room_entered(area):
	ground_mesh = area.get_parent().get_node("Ground/MeshInstance")
	_set_ground_params()
