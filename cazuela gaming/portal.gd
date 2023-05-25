extends Area2D

var PlayersInPortal=0
var lockPortal = false
@onready var timer:Timer = $Timer
@onready var animated_sprite=$AnimatedSprite2D
@export var id = 0
#var Player = get_node("/root/player")#
#var InvertedPlayer = get_node("/root/player2")
#var isReadyNPC = false
#var isReadyPlayer = false

func _ready():
	self.on_body_entered.connect(playerentered)
	timer.timeout.connect(timeout)
	var otherPortal = get_node("/root/portal2")
	
	pass
	
	otherPortal._onTimerComplete()
	#null referencial al otro portal, poner getnode del path y asignarla al otro portal lockportal en el otro y si es true cancelar el timer
func timeout():
	#perder
	pass
	
func playerentered(body):
	
	if not body.is_in_group("players"):
		return
		
	lockPortal=true
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 3.0
	timer.start()

func Teleport(area):
	var otherPortal = get_node("/root/portal2")
	var Player = get_node("/root/player")
	var InvertedPlayer = get_node("/root/player2")
	if lockPortal:
		if otherPortal.lockPortal:
			Player.position 
			
#stunned=true
#await(get_tree().create_timer(2).timeout)
#global_position=portal.global_position
#stunned=false
#isInverted = true
#PlayerInverted.emit(isInverted)
#enviarInputs.emit(inputs)
