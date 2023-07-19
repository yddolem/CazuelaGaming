extends Node2D
var playerArrivedAtPortal = false
var replicatorArrivedAtPortal = false	
var replicatorArrivedAtBed
var timer = 1.5
var npcMoveSpeed = 300
var path_follow
var PathReversa 
var PlayerIsInverted= false
var gameOver = false
var gameoverScene 
var game_over_reason
var currentLevel
var current_progress
var early_y
var state
var MissionSuccessScene
var missionSuccess = false
var colorRect 
var trails 
# Called when the node enters the scene tree for the first time.
func _ready():
	path_follow=$Path2D/PathFollow2D
	PathReversa = $Path2D/PathReversa
	game_over_reason = GameOverReason
	state = InvertedState
	currentLevel=CurrentScene
	early_y = position.y
	current_progress=0
	colorRect  = $ColorRect
	colorRect.hide()
	trails = $Path2D/PathFollow2D/Replicator/GPUParticles2D
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if replicatorArrivedAtPortal == false && path_follow.progress_ratio<1:
		path_follow.progress+=npcMoveSpeed*delta
		PathReversa.progress+=npcMoveSpeed*delta
		
		if position.y !=early_y:

			state.invertedIsJumping = true
			state.invertedIsRunning = false
			state.invertedIsIdle = false
		
		if state.invertedIsJumping == false:
			
			if  current_progress == path_follow.progress:
				print("inverted is idle")
				state.invertedIsIdle = true
				state.invertedIsRunning = false
				state.invertedIsJumping = false
				
			if current_progress != path_follow.progress:
				print("inverted is running")
				state.invertedIsRunning = true
				state.invertedIsIdle= false
				state.invertedIsJumping = false
			
	
		
	if PlayerIsInverted == true:
		PathReversa.progress-=npcMoveSpeed*delta	
		colorRect.show()
		
	#Si uno llega al portal y el otro no	
	if portalAwaiting()==true:
		timer-=delta
	if timer <=0 && gameOver==false:
		gameOver = true
		gameOverHandler("CRITICAL_ERROR: Portal desynced")
		
	current_progress = path_follow.progress
	early_y = position.y
	
	missionSuccessHandler()
		
func portalAwaiting():
	if (playerArrivedAtPortal != replicatorArrivedAtPortal):
		return  true
	else: 
		return false
func missionSuccessHandler():
		
	if missionSuccess==true and replicatorArrivedAtBed == true:
		MissionSuccessScene = preload("res://scenes/GUI/mission_success_screen.tscn")
		get_tree().change_scene_to_packed(MissionSuccessScene)
		
func _on_player_player_arrived_at_portal():
	playerArrivedAtPortal = true
func _on_replicator_replicator_arrived_at_portal():
	replicatorArrivedAtPortal = true
	path_follow.progress_ratio = 1
func _on_player_player_is_inverted():
	PlayerIsInverted = true
func _on_player_game_over(reason):
	if missionSuccess == false:
		gameOver=true
		gameOverHandler(reason)
		
func gameOverHandler(reason:String):

	gameoverScene = preload("res://scenes/GUI/game_over_screen.tscn")
	get_tree().change_scene_to_packed(gameoverScene)
	game_over_reason.reason = reason
	game_over_reason.tip = generateTip(reason)
	
func generateTip(reason):
	if (reason == "CRITICAL_ERROR: Portal desynced"):
		return "Remember to enter the portal at the same time as the inverted you"
	if (reason == "CRITICAL_ERROR: Character collided with himself"):
		return "Cooperate with your future self to complete the mission"
	if (reason == "CRITICAL_ERROR: Character broke the space-time continuity"):
		return "Imitate the best as you can the position of the inverted you"


func _on_player_mission_success():
	missionSuccess = true
	
func _on_replicator_replicator_arrived_at_bed():
	replicatorArrivedAtBed = true
