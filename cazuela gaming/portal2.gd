extends Area2D
@onready var animated_sprite=$AnimatedSprite2D
@export var id = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _onTimerComplete():
	print("No llegaste al mismo tiempo que tu yo del futuro :(")
	# Realiza las acciones necesarias cuando el temporizador del otro portal ha finalizado
