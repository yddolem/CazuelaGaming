extends Node2D
var playerArrivedAtPortal = false
var replicatorArrivedAtPortal = false	
var timer = 2
var npcMoveSpeed = 300
var path_follow
# Called when the node enters the scene tree for the first time.
func _ready():
	path_follow=$Path2D/PathFollow2D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	path_follow.progress+=npcMoveSpeed*delta
	#Si uno llega al portal y el otro no	
	if portalAwaiting()==true:
		timer-=delta
	if timer >0:
		print(timer)
	if timer <=0:
		print("Juego terminado")

func portalAwaiting():
	if (playerArrivedAtPortal != replicatorArrivedAtPortal):
		return  true
	else: 
		return false
func _on_player_player_arrived_at_portal():
	playerArrivedAtPortal = true
func _on_replicator_replicator_arrived_at_portal():
	replicatorArrivedAtPortal = true
