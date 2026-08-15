extends Node

# --- VARIÁVEIS DE JOGO E ARRAYS ---
var banco_de_palavras: Array[String] = [
# --- TEMA ESPAÇO E FICÇÃO CIENTÍFICA ---
	"estrela", "cometa", "meteoro", "nave", "foguete", 
	"alien", "laser", "radar", "motor", "escudo", 
	"portal", "cosmo", "piloto", "marte", "lua", 
	"terra", "sol", "raio", "eclipse", "universo",

	# --- TEMA NATUREZA E ANIMAIS ÉPICOS ---
	"tigre", "lobo", "urso", "cobra", "pantera", 
	"raposa", "fera", "selva", "monstro", "oceano", 
	"pedra", "rocha", "caverna", "montanha", "rio", 
	"vento", "fogo", "gelo", "floresta", "deserto",

	# --- TEMA TECNOLOGIA E GAMING ---
	"teclado", "mouse", "tela", "jogo", "fase", 
	"chefe", "pixel", "controle", "bateria", "energia", 
	"drone", "ciborgue", "cabo", "metal", "ferro", 
	"placa", "rede", "fone", "som", "imagem",

	# --- TEMA AVENTURA E AÇÃO ---
	"espada", "magia", "poder", "lenda", "tesouro", 
	"mapa", "viagem", "pulo", "corrida", "mestre", 
	"ninja", "sombra", "luz", "fantasma", "gigante", 
	"torre", "castelo", "barco", "navio", "ponte",

	"secreto", "enigma", "desafio", "ouro", "prata", 
	"bronze", "cristal", "diamante", "rubi", "chave", 
	"armadura", "tempo", "futuro", "passado", "presente", 
	"infinito", "velocidade", "armadilha", "veneno", "cura"
]

var cena_inimigo: PackedScene = preload("res://cenas/inimigo.tscn")
var cena_laser: PackedScene = preload("res://cenas/laser.tscn") 
var inimigo_atual = null

# --- VARIÁVEIS DO BOSS ---
var banco_de_palavras_boss: Array[String] = [
	"extraterrestre", "supercomputador", "intergalactico", 
	"invulnerabilidade", "desenvolvimento", "paralelepipedo"
]
var proximo_marco_boss: int = 2000 

var pontos_atuais: int = 0
@onready var label_pontos = $CanvasLayer/LabelPontos
@onready var label_ranking = $CanvasLayer/LabelRanking
@onready var painel_pause = $CanvasLayer/PainelPause

@onready var player = $Player
@onready var som_acerto = $SomAcerto 
@onready var botao_play = $CanvasLayer/PainelPause/BotaoPlay # Referência para mudar a cor
@onready var som_clique = $CanvasLayer/PainelPause/SomClique
@onready var som_hover = $CanvasLayer/PainelPause/SomHover

var player_original_position: Vector2

func _ready() -> void:
	randomize()
	label_pontos.text = "Pontos: 0"
	exibir_ranking_na_fase()
	
	player_original_position = player.global_position

func _process(delta: float) -> void:
	if inimigo_atual != null and is_instance_valid(inimigo_atual):
		var target_angle = player.global_position.direction_to(inimigo_atual.global_position).angle() + PI/2
		player.rotation = target_angle
	else:
		player.rotation = lerp_angle(player.rotation, 0.0, 0.2)
	
	player.global_position = player_original_position

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		alternar_pause()
		return 
		
	if event is InputEventKey and event.pressed:
		if event.echo or event.as_text().length() > 1:
			return
			
		var letra_digitada: String = char(event.unicode).to_lower()
		verificar_digitacao(letra_digitada)

func verificar_digitacao(letra: String) -> void:
	if inimigo_atual != null and not is_instance_valid(inimigo_atual):
		inimigo_atual = null
		
	if inimigo_atual == null:
		var todos_inimigos = get_tree().get_nodes_in_group("inimigos")
		
		for inimigo in todos_inimigos:
			if inimigo.palavra == "" or inimigo.indice_digitado >= inimigo.palavra.length():
				continue
				
			var primeira_letra = inimigo.palavra[0].to_lower()
			
			if letra == primeira_letra:
				inimigo_atual = inimigo
				inimigo_atual.registrar_letra_correta()
				adicionar_pontos(10)
				
				som_acerto.play() 
				atirar_laser_no_alvo(inimigo_atual)
				
				if inimigo_atual.indice_digitado >= inimigo_atual.palavra.length():
					adicionar_pontos(50)
					inimigo_atual = null
				return
				
	else:
		var letra_esperada: String = inimigo_atual.palavra[inimigo_atual.indice_digitado].to_lower()
		
		if letra == letra_esperada:
			inimigo_atual.registrar_letra_correta()
			adicionar_pontos(10)
			
			som_acerto.play() 
			atirar_laser_no_alvo(inimigo_atual)
			
			if inimigo_atual.indice_digitado >= inimigo_atual.palavra.length():
				adicionar_pontos(50)
				inimigo_atual = null

func atirar_laser_no_alvo(alvo_node):
	var novo_laser = cena_laser.instantiate()
	novo_laser.global_position = player.global_position
	novo_laser.alvo = alvo_node
	add_child(novo_laser)

func adicionar_pontos(valor: int) -> void:
	pontos_atuais += valor
	label_pontos.text = "Pontos: " + str(pontos_atuais)
	
	if pontos_atuais >= proximo_marco_boss:
		spawnar_boss()
		proximo_marco_boss += 2000 

func spawnar_boss() -> void:
	var boss = cena_inimigo.instantiate()
	boss.position = Vector2(576, -100)
	boss.palavra = banco_de_palavras_boss.pick_random()
	boss.scale = Vector2(2.0, 2.0) 
	boss.velocidade_descida = 15.0 
	add_child(boss)

func _on_spawn_timer_timeout() -> void:
	var novo_inimigo = cena_inimigo.instantiate()
	var posicao_x_aleatoria = randi_range(150, 800) 
	novo_inimigo.position = Vector2(posicao_x_aleatoria, -50.0)
	novo_inimigo.palavra = banco_de_palavras.pick_random()
	add_child(novo_inimigo)

func exibir_ranking_na_fase() -> void:
	var caminho_save = "user://ranking.json"
	
	if not FileAccess.file_exists(caminho_save):
		label_ranking.text = "TOP 5:\nSem recordes"
		return
		
	var arquivo = FileAccess.open(caminho_save, FileAccess.READ)
	var texto = arquivo.get_as_text()
	arquivo.close()
	
	var rank = JSON.parse_string(texto)
	
	if typeof(rank) == TYPE_ARRAY:
		var texto_final = "TOP 5 RECORDES:\n"
		var posicao = 1
		
		for pontos in rank:
			texto_final += str(posicao) + "º: " + str(int(pontos)) + " pts\n"
			posicao += 1
			
		label_ranking.text = texto_final

func salvar_no_ranking() -> void:
	var caminho_save = "user://ranking.json"
	var rank: Array = []
	
	if FileAccess.file_exists(caminho_save):
		var arquivo_leitura = FileAccess.open(caminho_save, FileAccess.READ)
		var texto = arquivo_leitura.get_as_text()
		var json = JSON.parse_string(texto)
		if typeof(json) == TYPE_ARRAY:
			rank = json
			
	rank.append(pontos_atuais)
	rank.sort()
	rank.reverse() 
	
	if rank.size() > 5:
		rank.pop_back()
		
	var arquivo_escrita = FileAccess.open(caminho_save, FileAccess.WRITE)
	if arquivo_escrita:
		arquivo_escrita.store_string(JSON.stringify(rank))
		arquivo_escrita.close()

func _on_linha_morte_area_entered(area: Area2D) -> void:
	if area.has_method("registrar_letra_correta"):
		salvar_no_ranking()
		print("GAME OVER! Voltando para o menu...")
		get_tree().call_deferred("change_scene_to_file", "res://cenas/gameover.tscn")

func alternar_pause() -> void:
	# Inverte o estado do jogo (se tá rodando, pausa; se tá pausado, roda)
	var novo_estado = not get_tree().paused
	get_tree().paused = novo_estado
	
	if novo_estado:
		painel_pause.show()
	else:
		painel_pause.hide()
		

func _on_botao_pause_pressed() -> void:
	som_clique.play()
	alternar_pause()

func _on_botao_play_pressed() -> void:
	som_clique.play()
	alternar_pause()


func _on_botao_play_mouse_entered() -> void:
	# Tire os '#' abaixo se for usar o botão central:
	botao_play.modulate = Color(0.6, 0.6, 0.6)
	som_hover.play()
	pass

func _on_botao_play_mouse_exited() -> void:
	botao_play.modulate = Color(1, 1, 1)
	som_hover.play()
	pass
