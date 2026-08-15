extends CharacterBody2D

@export var speed: float = 200.0
var screen_size: Vector2

@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	screen_size = get_viewport_rect().size
	if anim:
		anim.play("idle") # Começa retinha

func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	if anim:
		if velocity.x > 0:
			anim.play("direita")   # Se move para a direita -> inclina para a direita
		elif velocity.x < 0:
			anim.play("esquerda")  # Se move para a esquerda -> inclina para a esquerda
		else:
			anim.play("idle")      # Parada -> volta a ficar reta

	global_position.x = clamp(global_position.x, 32, screen_size.x - 32)
