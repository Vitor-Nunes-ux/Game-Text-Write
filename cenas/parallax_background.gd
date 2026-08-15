extends ParallaxBackground

@export var scroll_speed: float = 60.0

@onready var camada_fundo = $ParallaxLayer

func _process(delta: float) -> void:
	scroll_base_offset.y += scroll_speed * delta
	
	if camada_fundo:
		camada_fundo.motion_scale.y = 1.0
