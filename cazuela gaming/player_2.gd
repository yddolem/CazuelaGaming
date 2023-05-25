extends CharacterBody2D


@export var positions : PackedVector2Array

var newInputs = []

const SPEED = 200.0
const JUMP_VELOCITY = -200.0
@onready var pivot= $Pivot
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback=animation_tree.get("parameters/playback")

const GRAVITY = 400
const ACCELERATION= 1000


var stunned = false
var isNPCInverted = true
var currentWaypointIndex
var inputIndex = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if get_parent().has_node("PathFollow2D"):
		look_at(get_parent().get_node("PathFollow2D").get_position() + get_parent().get_node("PathFollow2D").get_offset())
	
	if isNPCInverted ==false and inputIndex<len(newInputs):
		var direction = newInputs[inputIndex]
		velocity.x = move_toward(velocity.x,direction*SPEED ,ACCELERATION*delta)
		
		if not is_on_floor():
			#print("esta en el aire")
			velocity.y += GRAVITY * delta
		if direction:
			pivot.scale.x=-sign(direction)
		if is_on_floor():
			if velocity.x!=0 or direction:
				#print("corriendo")
				playback.travel("run")
			
			else:
				playback.travel("idle")
		else:
			if velocity.y<0:
				playback.travel("jump")
		move_and_slide()
		inputIndex+=1


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
					


func _on_area_2d_area_entered(area):
	if (area.is_in_group("portal")):
		if(!area.lockPortal):
			Teleport(area)

func move_to_waypoint(waypoint: Vector2, delta: float) -> void:
	var velocity = (waypoint - position).normalized() * SPEED
	$CharacterBody2D.move_and_slide(velocity)


func _on_player_enviar_inputs(inputs):
	inputs.reverse()
	newInputs=inputs
	
func _on_player_player_inverted(isInverted):
	isNPCInverted=false
