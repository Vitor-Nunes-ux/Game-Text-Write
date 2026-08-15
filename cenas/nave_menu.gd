extends CharacterBody2D

@export var velocidade: float = 150.0

func _process(delta: float) -> void:
	position.x += velocidade * delta
	
	if position.x > 1300:
		position.x = -200
		position.y = randf_range(100, 500)
