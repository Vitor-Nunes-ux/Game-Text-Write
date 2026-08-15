extends Sprite2D
func _process(delta):
	position += (get_global_mouse_position()/5*delta)-position
