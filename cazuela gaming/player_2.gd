extends CharacterBody2D


@export var positions : PackedVector2Array

var newInputs = []

const SPEED = 300.0
const JUMP_VELOCITY = -200.0


const GRAVITY = 400
const ACCELERATION= 1000


var stunned = false
var isNPCInverted = true
var currentWaypointIndex
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if get_parent().has_node("PathFollow2D"):
		look_at(get_parent().get_node("PathFollow2D").get_position() + get_parent().get_node("PathFollow2D").get_offset())
	
	if isNPCInverted ==false:
		for input in newInputs:
			print(input)
			var direction = input
			velocity.x = move_toward(velocity.x,direction*SPEED ,ACCELERATION*delta)
			move_and_slide()


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
