extends Node2D

var alvo = null
var velocidade: float = 1200.0 

func _process(delta: float) -> void:
	if alvo != null and is_instance_valid(alvo):
		global_position = global_position.move_toward(alvo.global_position, velocidade * delta)
		
		var angulo_alvo = global_position.direction_to(alvo.global_position).angle()
		rotation = angulo_alvo + PI/2
		
		if global_position.distance_to(alvo.global_position) < 15.0:
			alvo.receber_dano_do_laser()
			queue_free()
	else:
		queue_free()
