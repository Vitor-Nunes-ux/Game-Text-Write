extends Control

@onready var label_texto = $Label
@onready var btn_replay = $ReplayBtn
@onready var btn_play = $PlayBtn
@onready var btn_close = $CloseBtn

@onready var animacao_texto = $AnimationPlayer 
@onready var som_clique = $SomClique
@onready var som_hover = $SomHover

func _ready() -> void:
	btn_replay.hide()
	btn_play.hide()
	btn_close.hide()
	
	label_texto.text = "YOU LOSE"
	
	await get_tree().create_timer(2.0).timeout
	

	label_texto.text = "GAME OVER"
	

	animacao_texto.stop() 
	label_texto.modulate = Color(1, 1, 1) # Garante que a cor volte para o branco total (caso a animação pare no meio do vermelho)
	
	btn_replay.show()
	btn_play.show()
	btn_close.show()


func _on_replay_btn_pressed() -> void:
	som_clique.play() # Toca o som
	await get_tree().create_timer(0.2).timeout # Espera 0.2 segundos para o som sair
	get_tree().change_scene_to_file("res://cenas/fase.tscn")

func _on_play_btn_pressed() -> void:
	som_clique.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://cenas/main_menu.tscn")

func _on_close_btn_pressed() -> void:
	som_clique.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()

func _on_replay_btn_mouse_entered() -> void:
	btn_replay.modulate = Color(0.6, 0.6, 0.6) 
	som_hover.play() # <--- Toca o som ao entrar

func _on_replay_btn_mouse_exited() -> void:
	btn_replay.modulate = Color(1, 1, 1)       

func _on_play_btn_mouse_entered() -> void:
	btn_play.modulate = Color(0.6, 0.6, 0.6)
	som_hover.play() # <--- Toca o som ao entrar

func _on_play_btn_mouse_exited() -> void:
	btn_play.modulate = Color(1, 1, 1)

func _on_close_btn_mouse_entered() -> void:
	btn_close.modulate = Color(0.6, 0.6, 0.6)
	som_hover.play() # <--- Toca o som ao entrar

func _on_close_btn_mouse_exited() -> void:
	btn_close.modulate = Color(1, 1, 1)
