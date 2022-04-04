extends Spatial

export var is_black = false


func _ready():
	if is_black:
		$White.visible = false
		$Black.visible = true
	else:
		$White.visible = true
		$Black.visible = false
