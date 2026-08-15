extends CharacterBody2D

@onready var animacao = $AnimatedSprite2D

@export var amplitude: Vector2 = Vector2(60, 40)   # Distância máxima que ele se afasta (X e Y)
@export var velocidade: Vector2 = Vector2(1.5, 2.0) # Velocidade do balanço em cada eixo

var tempo_x: float = 0.0
var tempo_y: float = 0.0
var posicao_inicial: Vector2

func _ready():
	# Inicia a animação
	animacao.play("default")
	
	posicao_inicial = position
	
	# Sorteia valores iniciais para que, se você colocar vários no mapa,
	# eles não se mofam exatamente iguais ao mesmo tempo
	tempo_x = randf_range(0.0, 100.0)
	tempo_y = randf_range(0.0, 100.0)

func _process(delta):
	# Atualiza o tempo com base no delta do jogo
	tempo_x += delta * velocidade.x
	tempo_y += delta * velocidade.y
	
	# Calcula o balanço suave usando Seno e Cosseno
	var offset_x = sin(tempo_x) * amplitude.x
	var offset_y = cos(tempo_y) * amplitude.y
	
	# Aplica o movimento a partir da posição inicial dele
	position = posicao_inicial + Vector2(offset_x, offset_y)
