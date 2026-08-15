extends PathFollow2D

@export var speed: float = 50.0

func _process(delta: float) -> void:
	if speed > 0:
		$NaveMenu2/AnimatedSprite2D.flip_h = false 
	else:
		$NaveMenu2/AnimatedSprite2D.flip_h = true
	
	progress += speed * delta
