extends Area2D

var PlayersInPortal=0
var lockPortal = false
@onready var timer:Timer = $Timer

@onready var animated_sprite=$AnimatedSprite2D
@export var id = 0

func _physics_process(delta):
  
	if lockPortal:
		return

		# Aumentar el número de personas en el portal
		PlayersInPortal += 1
		
		# Si hay dos personas en el portal, activar el temporizador
		if PlayersInPortal == 2:
			lockPortal = true
			await(get_tree().create_timer(2).timeout)
			
			var PlayersPortal1 = get_node("Portal_1").get_node_count()
			var PlayersPortal2 = get_node("Portal_2").get_node_count()
			
			if PlayersPortal1 == 2 and PlayersPortal2 == 2:
				# Intercambiar la posición de los personajes
				var portal_1_player_1 = get_node("portal/player")
				var portal_1_player_2 = get_node("portal/player_2")
				var portal_2_player_1 = get_node("portal/player")
				var portal_2_player_2 = get_node("portal_2/player_2")
				
				portal_1_player_1.position= portal_2_player_1.position
				portal_2_player_1.position= portal_1_player_1.position
				portal_1_player_2.position= portal_2_player_2.position
				portal_2_player_2.position= portal_1_player_2.position
				# Reiniciar la variable "personas_en_portal"
				PlayersInPortal = 0

func _ready():
	self.on_body_entered.connect(playerentered)
	timer.timeout.connect(timeout)
	pass
	#null referencial al otro portal, poner getnode del path y asignarla al otro portal lockportal en el otro y si es true cancelar el timer
func timeout():
	#perder
	pass

func playerentered(body):
	
	if not body.is_in_group("players"):
		return
		
	#ver q sea player -> agregar player y player2 a una clase player o añadirlos a un grupo
	#meter aca el codigo
	lockPortal=true
	timer.start()
	#avisarle al otro portal crear 2 variables export nodepad y aignar el camino a otro portal (arriba cn las variables)
	
	pass
