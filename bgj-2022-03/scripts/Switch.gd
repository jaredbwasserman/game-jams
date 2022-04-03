extends Area

var clicked = false


func trigger():
	if clicked:
		return

	$ClickAnim.play("click")
	clicked = true
