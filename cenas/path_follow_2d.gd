extends PathFollow2D

@export var speed: float = 30.0

func _process(delta: float) -> void:
	if speed > 0:
		$NaveMenu/AnimatedSprite2D.flip_h = false 
	else:
		$NaveMenu/AnimatedSprite2D.flip_h = true
	
	progress += speed * delta
