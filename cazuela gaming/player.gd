extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -200.0


const GRAVITY = 400
const ACCELERATION= 1000

@onready var pivot= $Pivot

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback=animation_tree.get("parameters/playback")
func _ready():
	animation_tree.active = true
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y=JUMP_VELOCITY
	
	var direction = Input.get_axis("move_left","move_right")
	
	
	velocity.x = move_toward(velocity.x,direction*SPEED ,ACCELERATION*delta)
	
	move_and_slide()
	
	#Animation
	if direction:
		pivot.scale.x=sign(direction)
	if is_on_floor():
		
		if velocity.x!=0:
			playback.travel("run")
		
		else:
			playback.travel("idle")
	else:
		if velocity.y<0:
			playback.travel("jump")
		
		
		
		
	
