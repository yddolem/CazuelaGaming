extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -200.0


const GRAVITY = 400
const ACCELERATION= 1000

var teleport_time := 3
var portal_id := 0 

var positions : PackedVector2Array = []

signal PlayerInverted(isInverted)
signal enviarInputs(inputs)


@onready var pivot= $Pivot
@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback=animation_tree.get("parameters/playback")
var stunned = false
var canJump = true
var isInverted = false
var inputs = []



func _ready():
	animation_tree.active = true
	timer.start()
	set_process_input(true)

func _physics_process(delta):
	# Add the gravity.

	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
	if stunned==false:
		
		
		# Handle Jump.
		if Input.is_action_just_pressed("jump") and canJump:
			velocity.y=JUMP_VELOCITY
			canJump = false
		
		var direction = Input.get_axis("move_left","move_right")
		
		if is_on_floor():
			canJump = true
		
		if is_on_floor():
			velocity.x = move_toward(velocity.x,direction*SPEED ,ACCELERATION*delta)
		
		move_and_slide()
		
		#Animation
		if direction and is_on_floor():
			pivot.scale.x=sign(direction)
		if is_on_floor():
			
			if velocity.x!=0 or direction:
				playback.travel("run")
			
			else:
				playback.travel("idle")
		else:
			if velocity.y<0:
				playback.travel("jump")
				
		if isInverted == false:
			saveInput()
			
			
	
	if stunned == true:
		playback.travel("idle")
		



func Teleport(area):
	for portal in get_tree().get_nodes_in_group("portal"):
		if portal!= area:
			if (portal.id==area.id):
				if (!portal.lockPortal):
					area.LockedPortal()
					

					stunned=true
					await(get_tree().create_timer(2).timeout)
					
					global_position=portal.global_position

					stunned=false
					isInverted = true
					PlayerInverted.emit(isInverted)
					enviarInputs.emit(inputs)
					
				
func _on_area_2d_area_entered(area):
	if (area.is_in_group("portal")):

		
		if (!area.lockPortal):
			
			Teleport(area)
		
func saveInput():
	if canJump:
		if Input.is_action_just_pressed("jump"):
			print("Guardando salto")
			var startPosition = global_position
			var maxJumpHeight = 0
			var maxJumpPosition = Vector2.ZERO
			var endPosition = Vector2.ZERO

			if velocity.y < 0 and position.y < startPosition.y:
				maxJumpHeight = max(maxJumpHeight, startPosition.y - position.y)
				maxJumpPosition = Vector2(startPosition.x, startPosition.y - maxJumpHeight)

			if canJump:
				endPosition = global_position
				
			var jumpParameters = [startPosition, maxJumpPosition, endPosition]
			inputs.append(jumpParameters)
		else:
			var direction = -Input.get_axis("move_left", "move_right")
			inputs.append(direction)
	



