extends Node2D
var playerArrivedAtPortal = false
var replicatorArrivedAtPortal = false	
var timer = 2
var npcMoveSpeed = 300
var path_follow
var PathReversa 
var PlayerIsInverted= false
var gameOver = false
# Called when the node enters the scene tree for the first time.
func _ready():
	path_follow=$Path2D/PathFollow2D
	PathReversa = $Path2D/PathReversa
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if replicatorArrivedAtPortal == false:
		path_follow.progress+=npcMoveSpeed*delta
		PathReversa.progress+=npcMoveSpeed*delta
	if PlayerIsInverted == true:
		PathReversa.progress-=npcMoveSpeed*delta
	
	#Si uno llega al portal y el otro no	
	if portalAwaiting()==true:
		timer-=delta
	if timer >0 && PlayerIsInverted == false:
		print(timer)
	if timer <=0:
		gameOverHandler("Portal descoordinado")
		gameOver = true

func portalAwaiting():
	if (playerArrivedAtPortal != replicatorArrivedAtPortal):
		return  true
	else: 
		return false
func _on_player_player_arrived_at_portal():
	playerArrivedAtPortal = true
func _on_replicator_replicator_arrived_at_portal():
	replicatorArrivedAtPortal = true


func _on_player_player_is_inverted():
	PlayerIsInverted = true


func _on_player_game_over(reason):
	if (reason == "Personaje no imitó al invertido"):
		gameOverHandler(reason)
		
func gameOverHandler(reason:String):
	print(reason)
	gameOver= true
