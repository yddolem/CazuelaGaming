extends Area2D

var PlayersInPortal=0
var lockPortal = false
@onready var timer:Timer = $Timer

@onready var animated_sprite=$AnimatedSprite2D
@export var id = 0


			


func _ready():
	self.on_body_entered.connect(playerentered)
	timer.timeout.connect(timeout)
	pass
	var otherPortal = get_node("/root/portal2")
	otherPortal._onTimerComplete()
	#null referencial al otro portal, poner getnode del path y asignarla al otro portal lockportal en el otro y si es true cancelar el timer
func timeout():
	#perder
	pass


	
func playerentered(body):
	
	if not body.is_in_group("players"):
		return
		

	#avisarle al otro portal crear 2 variables export nodepad y aignar el camino a otro portal (arriba cn las variables)
	
	var PlayersPortal1 = get_node("portal").get_node_count()
	var PlayersPortal2 = get_node("portal2").get_node_count()
	
	if PlayersPortal1 == 1 or PlayersPortal2 == 1:
		lockPortal=true
		timer = Timer.new()
		add_child(timer)
		timer.wait_time = 3.0
		timer.start()
		
	if PlayersPortal1 == 1 and PlayersPortal2 == 1:
		# Intercambiar la posición de los personajes
		var portal_1_player_1 = get_node("portal/player")
		var portal_1_player_2 = get_node("portal/player_2")
		var portal_2_player_1 = get_node("portal/player")
		var portal_2_player_2 = get_node("portal2/player_2")
		
		portal_1_player_1.position= portal_2_player_1.position
		portal_2_player_1.position= portal_1_player_1.position
		portal_1_player_2.position= portal_2_player_2.position
		portal_2_player_2.position= portal_1_player_2.position
		# Reiniciar la variable "personas_en_portal"
		PlayersInPortal = 0
	pass
