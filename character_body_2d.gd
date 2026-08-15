extends CharacterBody2D

@onready var animacao = $AnimatedSprite2D


@export var velocidade_rotacao: float = 2.0
@export var velocidade_movimento_x: float = -15.0 # Valor negativo para ir da Direita para a Esquerda


@export var amplitude_y: float = 20.0 
@export var velocidade_oscilacao: float = 0.5 

var tempo: float = 0.0
var posicao_inicial_y: float

func _ready() -> void:
	animacao.play("default")
	posicao_inicial_y = position.y
	tempo = randf_range(0.0, 100.0)

func _process(delta: float) -> void:

	rotation_degrees += velocidade_rotacao * delta
	

	position.x += velocidade_movimento_x * delta
	

	tempo += delta
	position.y = posicao_inicial_y + sin(tempo * velocidade_oscilacao) * amplitude_y
	

	if position.x < -200:

		position.x = 1350
		
		posicao_inicial_y = randf_range(100.0, 500.0)
