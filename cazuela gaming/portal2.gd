extends Area2D

var lockPortal = false
@onready var timer:Timer = $Timer
@onready var animated_sprite=$AnimatedSprite2D
@export var id = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func playerentered(body):
	
	if not body.is_in_group("players"):
		return
	
	lockPortal=true	

func _onTimerComplete():
	if timer=0:
		print("No llegaste al mismo tiempo que tu yo del futuro :(")
	# Realiza las acciones necesarias cuando el temporizador del otro portal ha finalizado
