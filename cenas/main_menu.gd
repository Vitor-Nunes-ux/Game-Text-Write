extends Control

# --- REFERÊNCIAS DOS NÓS ---
@onready var btn_start = $VBoxContainer/start
@onready var btn_credits = $VBoxContainer/credits # Renomeado para btn_credits
@onready var btn_quit = $VBoxContainer/quit
@onready var btn_close = $CreditosMenu/CloseBtn
@onready var menu_creditos = $CreditosMenu

@onready var music_menu = $MusicMenu
@onready var som_clique = $SomClique
@onready var som_hover = $SomHover

func _ready():
	menu_creditos.visible = false

# --- BOTÕES PRINCIPAIS ---
func _on_start_pressed() -> void:
	som_clique.play()
	var tween = create_tween()
	tween.tween_property(music_menu, "volume_db", -80.0, 1.5)
	await tween.finished
	get_tree().change_scene_to_file("res://cenas/fase.tscn")

func _on_credits_pressed() -> void: # Nome da função ajustado
	som_clique.play()
	menu_creditos.visible = true

func _on_quit_pressed() -> void:
	som_clique.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()

# --- EFEITOS DE MOUSE (HOVER) ---
func _on_start_mouse_entered() -> void:
	btn_start.modulate = Color(0.6, 0.6, 0.6)
	som_hover.play()

func _on_start_mouse_exited() -> void:
	btn_start.modulate = Color(1, 1, 1)

func _on_credits_mouse_entered() -> void: # Agora usa btn_credits
	btn_credits.modulate = Color(0.6, 0.6, 0.6)
	som_hover.play()

func _on_credits_mouse_exited() -> void:
	btn_credits.modulate = Color(1, 1, 1)

func _on_quit_mouse_entered() -> void:
	btn_quit.modulate = Color(0.6, 0.6, 0.6)
	som_hover.play()

func _on_quit_mouse_exited() -> void:
	btn_quit.modulate = Color(1, 1, 1)

func _on_close_btn_pressed():
	som_clique.play()
	menu_creditos.visible = false

func _on_close_btn_mouse_entered() -> void:
	btn_close.modulate = Color(0.6, 0.6, 0.6)
	som_hover.play()

func _on_close_btn_mouse_exited() -> void:
	btn_close.modulate = Color(1, 1, 1)
