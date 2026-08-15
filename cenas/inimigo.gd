extends Area2D

@onready var animacao = $AnimatedSprite2D
@onready var label: RichTextLabel = $RichTextLabel

@export var palavra: String = "godot"
@export var velocidade_descida: float = 50.0

# Configurações do balanço (flutuação)
@export var amplitude: Vector2 = Vector2(10, 0)   
@export var velocidade_balanco: float = 2.0       

var indice_digitado: int = 0
var tempo: float = 0.0
var posicao_inicial_x: float

var palavra_completa: bool = false
var lasers_recebidos: int = 0
var morrendo: bool = false

func _ready() -> void:
	animacao.play("default")
	
	posicao_inicial_x = position.x
	tempo = randf_range(0.0, 100.0)
	
	add_to_group("inimigos")
	atualizar_texto_visual()

func _process(delta: float) -> void:
	if morrendo:
		return
		
	position.y += velocidade_descida * delta
	
	tempo += delta
	var offset_x = sin(tempo * velocidade_balanco) * amplitude.x
	position.x = posicao_inicial_x + offset_x

func atualizar_texto_visual() -> void:
	if palavra == "":
		return
		
	var parte_digitada = palavra.substr(0, indice_digitado)
	var parte_restante = palavra.substr(indice_digitado, palavra.length() - indice_digitado)
	
	label.text = "[color=green]" + parte_digitada + "[/color]" + parte_restante

func registrar_letra_correta() -> void:
	if morrendo:
		return
		
	indice_digitado += 1
	atualizar_texto_visual()
	
	if indice_digitado >= palavra.length():
		palavra_completa = true
		# Opcional: Fica amarelo para avisar o jogador que a palavra acabou e os tiros estão a caminho
		animacao.modulate = Color(1.0, 1.0, 0.0)

func receber_dano_do_laser() -> void:
	if morrendo:
		return
		
	lasers_recebidos += 1
	
	if lasers_recebidos >= palavra.length():
		morrer_com_efeito()

func morrer_com_efeito() -> void:
	morrendo = true
	
	animacao.modulate = Color(1, 0, 0)
	
	label.hide()
	
	await get_tree().create_timer(0.2).timeout
	
	queue_free()
