extends Camera2D


var player

func _ready() -> void:
	player = get_parent() 
	make_current()
	global_position.y = 324
