extends CharacterBody2D
## Objeto que replica en reversa el movimiento recibido
var playerArrivedAtPortal = false
var isInverted = true
signal replicatorArrivedAtPortal
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var playback= animation_tree.get("parameters/playback")
var state = InvertedState
var arrivedAtPortal = false

func _ready():
	($"../../../Player" as Player).movement_finished.connect(start_replication)
	# NOTA: evitar obtener nodos de esta forma. Si es necesario conectar dos
	# nodos hermanos, lo correcto es que el nodo superior les conecte.
	# En este caso habría que crear un script en TestScene que en su _ready haga
	# $Player.movement_finished.connect($Replicator.start_replication)
	# Solo lo hago aquí mismo para no abultar el código y porque es un ambiente
	# controlado
	#set_physics_process(false)
	
func _physics_process(delta):
	if state.invertedIsIdle==true:
		playback.travel("idle")
	if state.invertedIsJumping==true:
		playback.travel("jump")
	if (state.invertedIsRunning == true && arrivedAtPortal == false):
		playback.travel("run")
	if arrivedAtPortal==true:
		playback.travel("idle")
	
func start_replication(storage: Array[MovementStorage], pos: Vector2) -> void:
#	set_physics_process(true)
	global_position = pos
	storage.reverse()
	var tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	for movement in storage:
		replicate(movement, tween)

func replicate(movement : MovementStorage, tween : Tween):
	match movement.type:
		MovementStorage.MOVEMENT_TYPE.STANDING:
			
			replicate_standing(movement, tween)
		MovementStorage.MOVEMENT_TYPE.WALK:
			
			replicate_walking(movement, tween)
		MovementStorage.MOVEMENT_TYPE.JUMP:
			
			replicate_jumping(movement, tween)

func replicate_standing(movement : MovementStorage.Standing, tween : Tween):
	tween.tween_callback(playback.travel.bind("idle"))
	# setear la posición y esperar
	tween.tween_callback(set.bind("global_position", movement.final_position))
	tween.tween_interval(movement.duration)

func replicate_walking(movement : MovementStorage.Walking, tween : Tween):
	tween.tween_callback(playback.travel.bind("run"))
	# setear la posición final e interpolar a la inicial
	# (es lineal, se puede cambiar a otras cosas usando set_ease y set_trans, ver easings.net)
	tween.tween_callback(set.bind("global_position", movement.final_position))
	tween.tween_property(self, "global_position", movement.initial_position, movement.duration)

func replicate_jumping(movement : MovementStorage.Jumping, tween : Tween):
	tween.tween_callback(playback.travel.bind("jump"))
	# setear la posición final e interpolar X e Y por separado.
	tween.tween_callback(set.bind("global_position", movement.final_position))
	# X se interpola linealmente entre la final y la inicial
	tween.tween_property(self, "global_position:x", movement.initial_position.x, movement.jump_duration + movement.fall_duration)
	# Y se interpola en 2 pasos:
	# primero de la posición final a la de máxima altura
	tween.parallel().tween_property(self, "global_position:y", movement.max_height_position.y, movement.fall_duration) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	# y luego de la posición de máxima altura a la inicial
	tween.parallel().tween_property(self, "global_position:y", movement.initial_position.y, movement.jump_duration) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD) \
			.set_delay(movement.fall_duration).from(movement.max_height_position.y)


func Teleport(area):
	for portal in get_tree().get_nodes_in_group("portal"):
		if portal!= area:
			if (portal.id==area.id):
				if (!portal.lockPortal):
					area.LockedPortalNPC()
					

					await(get_tree().create_timer(2).timeout)
					
					global_position=portal.global_position

					isInverted = false	


func _on_player_player_arrived_at_portal():
	playerArrivedAtPortal = true
	

func _on_area_2d_area_entered(area):
	if area.is_in_group("portal"):
		if !area.lockPortalNPC:
			arrivedAtPortal = true
			emit_signal("replicatorArrivedAtPortal")

			if playerArrivedAtPortal == true:
				Teleport(area)	
	pass # Replace with function body.
