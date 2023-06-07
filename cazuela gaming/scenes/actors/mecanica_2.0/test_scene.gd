extends Node2D
var playerArrivedAtPortal = false
var replicatorArrivedAtPortal = false	
var timer = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
