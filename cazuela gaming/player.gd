class_name Player
extends CharacterBody2D
var alreadyTeleported = false
## Player 
## CharacterBody con almacenamiento de movimientos para replicación

signal movement_finished(storage:Array[MovementStorage], starting_position:Vector2)
signal playerArrivedAtPortal 
signal PlayerIsInverted
signal GameOver(reason:String)
var replicatorArrivedAtPortal = false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

## To store airborne state
var airborne := false 
var movement_storage : Array[MovementStorage] = []
var current_movement : MovementStorage = MovementStorage.Standing.new()
var portal_id = 0
var stunned = false
var isInverted = false
@onready var pivot= $Pivot
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback=animation_tree.get("parameters/playback")



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _unhandled_key_input(_event):
	var event := _event as InputEventKey
	if event.keycode==KEY_C and event.pressed and not event.is_echo():
		#set_physics_process(false)
		emit_signal("movement_finished", movement_storage, global_position)

## Physics process separado por estado del jugador
func _physics_process(delta):
	# Obtener estados anteriores
	var was_standing := is_zero_approx(velocity.x) and not airborne
	var was_walking_left := not was_standing and velocity.x < 0 and not airborne
	var was_walking_right := not was_standing and velocity.x > 0 and not airborne
	var was_airborne := airborne
	# caso especial: diferenciar salto de caída
	var just_jumping := false
	# caso especial: diferenciar subida y bajada en salto
	var going_up := false
	var max_height_reached := false
	
	if not is_on_floor():
		going_up = velocity.y < 0 # está subiendo
		
		airborne = true
		velocity.y += gravity * delta
		
		max_height_reached = going_up and velocity.y >= 0 # estaba subiendo y ahora bajando

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		airborne = true
		just_jumping = true
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if is_on_floor(): # esto hace que no se pueda controlar en el aire
		if stunned==false:
			
			var direction = Input.get_axis("ui_left", "ui_right")
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
		if stunned == true:
			velocity = Vector2.ZERO
	move_and_slide()
	# estados actuales
	if is_on_floor() and not just_jumping:
		airborne = false
	var standing := is_zero_approx(velocity.x) and not airborne
	var walking_left := not standing and velocity.x < 0 and not airborne
	var walking_right := not standing and velocity.x > 0 and not airborne
	
	# cambio de estado, parte 1: dejó de hacer algo
	if was_standing and not standing: # si dejó de estar quieto
		(current_movement as MovementStorage.Standing).final_position = global_position
		movement_storage.append(current_movement)
	elif (was_walking_left and not walking_left) or \
			(was_walking_right and not walking_right): # si dejó de moverse en una dirección
		(current_movement as MovementStorage.Walking).final_position = global_position
		movement_storage.append(current_movement)
	elif was_airborne and not airborne: # si dejó de estar en el aire
		(current_movement as MovementStorage.Jumping).final_position = global_position
		movement_storage.append(current_movement)
	
	# cambio de estado, parte 2: comenzó a hacer algo
	if standing and not was_standing: # si comenzó a quedarse quieto
		current_movement = MovementStorage.Standing.new()
	elif airborne and not was_airborne: # si comenzó a estar en el aire...
		current_movement = MovementStorage.Jumping.new(global_position)
		if just_jumping: # ... debido a un salto 
			pass # no se hace nada especial, solo crear el storage
		else: # pero si es por una caída de un ledge hay que setear que no está subiendo
			(current_movement as MovementStorage.Jumping).max_height_position = global_position
	elif (walking_left and not was_walking_left) or \
			(walking_right and not was_walking_right): # si comenzó a moverse en una dirección
		current_movement = MovementStorage.Walking.new(global_position)
	if max_height_reached: # si estaba subiendo y comenzó a bajar
		(current_movement as MovementStorage.Jumping).max_height_position = global_position


func Teleport(area):
	for portal in get_tree().get_nodes_in_group("portal"):
		if portal!= area:
			if (portal.id==area.id):
				if (!portal.lockPortal):
					area.LockedPortal()
					

					await(get_tree().create_timer(2).timeout)
					
					global_position=portal.global_position
					alreadyTeleported = true
					stunned=false
					isInverted = true
					emit_signal("movement_finished", movement_storage, global_position)
					emit_signal("PlayerIsInverted")
					

func _on_area_2d_area_entered(area):
	if area.is_in_group("portal"):
		if !area.lockPortal && alreadyTeleported == false:
			emit_signal("playerArrivedAtPortal")
			stunned=true
			if replicatorArrivedAtPortal == true:	
				Teleport(area)
		
func _on_replicator_replicator_arrived_at_portal():
	replicatorArrivedAtPortal = true




