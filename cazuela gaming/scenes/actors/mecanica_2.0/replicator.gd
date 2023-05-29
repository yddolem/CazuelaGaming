class_name Replicator
extends CharacterBody2D

## Objeto que replica en reversa el movimiento recibido

var movement_storage : Array[MovementStorage]
var current_movement : MovementStorage = null
var current_duration : float = 0.0

func _ready():
	($"../Player" as Player).movement_finished.connect(start_replication)
	# NOTA: evitar obtener nodos de esta forma. Si es necesario conectar dos
	# nodos hermanos, lo correcto es que el nodo superior les conecte.
	# En este caso habría que crear un script en TestScene que en su _ready haga
	# $Player.movement_finished.connect($Replicator.start_replication)
	# Solo lo hago aquí mismo para no abultar el código y porque es un ambiente
	# controlado
	set_physics_process(false)

func _physics_process(delta:float):
	if movement_storage.is_empty():
		set_physics_process(false)
		return
	
	if not is_instance_valid(current_movement):
		current_movement = movement_storage.pop_back()
		current_duration = 0.0
	
#	print(current_movement.type)
	match current_movement.type:
		MovementStorage.MOVEMENT_TYPE.STANDING:
			replicate_standing(delta)
		MovementStorage.MOVEMENT_TYPE.WALK:
			replicate_walking(delta)
		MovementStorage.MOVEMENT_TYPE.JUMP:
			replicate_jumping(delta)
			
	# NOTA: para evitar pasar delta como parámetro a cada rato, 
	# se puede utilizar el método get_physics_process_delta_time()
	# de la clase Node dentro de los métodos que lo necesiten.

## Replica un movimiento de tipo standing
## Espera [MovementStorage.Standing.duration] segundos
func replicate_standing(delta:float) -> void:
	var current = current_movement as MovementStorage.Standing
	if current_duration > current.duration:
		current_movement = null
		current_duration = 0.0
		return
	current_duration += delta

## Replica un movimiento de tipo walking
## Se mueve hacia el destino
func replicate_walking(delta:float) -> void:
	var current = current_movement as MovementStorage.Walking
	if current_duration > current.duration:
		global_position = current.initial_position
		current_movement = null
		current_duration = 0.0
		return
	global_position = current.final_position.lerp(current.initial_position, current_duration/current.duration)
	current_duration += delta

## Replica un movimiento de tipo jumping
func replicate_jumping(delta:float) -> void:
	var current = current_movement as MovementStorage.Jumping
	var total_duration = current.jump_duration + current.fall_duration
	if current_duration > total_duration:
		current_movement = null
		current_duration = 0.0
		return
	global_position.x = lerp(current.final_position.x, current.initial_position.x, current_duration/total_duration)
	if current_duration < current.fall_duration: # está en la etapa de caída
		global_position.y = lerp(current.final_position.y, current.max_height_position.y, ease(current_duration/current.fall_duration, 0.4))
	else: # está en la etapa de salto
		var jump_duration = current_duration - current.fall_duration
		global_position.y = lerp(current.max_height_position.y, current.initial_position.y, ease(jump_duration/current.jump_duration, 1.8))
	current_duration += delta

func start_replication(storage: Array[MovementStorage], pos: Vector2) -> void:
	set_physics_process(true)
	global_position = pos
	movement_storage = storage
