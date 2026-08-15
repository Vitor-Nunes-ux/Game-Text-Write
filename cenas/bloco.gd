extends StaticBody2D

var golpes = 0

@onready var animation_player = $AnimationPlayer

func _ready():
	comprovar_golpes()

func destruir():
	golpes += 1
	comprovar_golpes()

func comprovar_golpes():
	if golpes == 0:
		animation_player.play("normal")
	elif golpes == 1:
		animation_player.play("danificado")
	elif golpes == 2:
		queue_free()
