extends Node2D
var playerArrivedAtPortal = false
var replicatorArrivedAtPortal = false	
var timer = 2
var npcMoveSpeed = 300
var path_follow
var PathReversa 
var PlayerIsInverted= false
var gameOver = false
var gameoverScene 
var game_over_reason
var currentLevel
# Called when the node enters the scene tree for the first time.
func _ready():
	path_follow=$Path2D/PathFollow2D
	PathReversa = $Path2D/PathReversa
	game_over_reason = GameOverReason
	currentLevel=CurrentScene
	
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
	if timer <=0 && gameOver==false:
		gameOver = true
		gameOverHandler("Portal desycnc")


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
	gameOver=true
	gameOverHandler(reason)
		
		
		
		
func gameOverHandler(reason:String):

	gameoverScene = preload("res://scenes/GUI/game_over_screen.tscn")
	get_tree().change_scene_to_packed(gameoverScene)
	game_over_reason.reason = reason
	game_over_reason.tip = generateTip(reason)
	
func generateTip(reason):
	if (reason == "Portal desycnc"):
		return "Remember to enter the portal at the same time as the inverted character"
	if (reason == "Character collided with himself"):
		return "Cooperate with your future self to complete the mission"
	if (reason == "Character broke the space-time continium"):
		return "Imitate the best as you can the position of the inverted character"
