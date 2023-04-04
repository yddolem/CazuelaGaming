extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


const GRAVITY = 400
const ACCELERATION= 1000

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y=JUMP_VELOCITY
	
	var direction = Input.get_axis("move_left","move_right")
	
	
	velocity.x = move_toward(velocity.x,direction*SPEED ,ACCELERATION*delta)
	



	move_and_slide()
