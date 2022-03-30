extends Camera

# Offsets relative to Player
export var offset_y = 50
export var offset_z = 45

# Padding
export var padding = 10

# Path to first ground mesh
export var ground_mesh_path: String

# Some variables
var ground_pos


func _ready():
	_update_ground(get_node(ground_mesh_path))
	set_process(true)


func _process(delta):
	self.set_translation(Vector3(
		ground_pos.x,
		offset_y,
		ground_pos.z + offset_z
	))


func _update_ground(mesh_node: Node):
	ground_pos = mesh_node.global_transform.origin
	self.set_size(mesh_node.mesh.size.x/2 + padding)


func _on_Player_new_room_entered(area):
	_update_ground(area.get_parent().get_node("Navigation/NavigationMeshInstance/Ground/MeshInstance"))
