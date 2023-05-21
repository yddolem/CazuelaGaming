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

var jumping = false
var stunned = false
var isNPCInverted = true
var currentWaypointIndex
var inputIndex = 0
var jumpIndex =0
var curvePoints = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if get_parent().has_node("PathFollow2D"):
		look_at(get_parent().get_node("PathFollow2D").get_position() + get_parent().get_node("PathFollow2D").get_offset())
	
	if isNPCInverted ==false and inputIndex<len(newInputs):
		
		var input  = newInputs[inputIndex]
		var direction
		
		if typeof(input) == TYPE_ARRAY:
			jumping = true
			print("Ejecutando salto invertido")
			var jumpParameters = input
			#Necesitamos pasarle los parametros invertidos, ya que primero partimos desde la caída y
			#vamos hacia atrás en el tiempo hasta el inicio del salto
			jumpParameters.reverse()
			#Ahora, le pasamos estos parametros invertidos a nuestro generador de curvas para que las
			#interpole
			print("generando curva con los puntos " , jumpParameters)
			curvePoints = generateJumpCurve(jumpParameters[0],jumpParameters[1],jumpParameters[2])
			print("curva resultante",curvePoints)
			
		if len(curvePoints) > 0:
			var currentPoint = curvePoints[0]
			var movementDirection = currentPoint - position
			velocity.x = move_toward(velocity.x, movementDirection.x * SPEED, ACCELERATION * delta)
			velocity.y = move_toward(velocity.y, movementDirection.y * SPEED, ACCELERATION * delta)
			curvePoints.remove(0)
			
		
		if jumpIndex == len(curvePoints):
			jumping = false
			
				
		if typeof(input)==TYPE_FLOAT:
			direction=input
			velocity.x = move_toward(velocity.x,direction*SPEED ,ACCELERATION*delta)
			
		if direction:
			pivot.scale.x=-sign(direction)
		
		if is_on_floor():
			if velocity.x!=0 or direction:
				
				playback.travel("run")
			
		if velocity.x == 0: 
				playback.travel("idle")
		else:
			if velocity.y<0:
				playback.travel("jump")
		
		move_and_slide()
		inputIndex+=1
		jumpIndex+=1


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




func _on_player_enviar_inputs(inputs):
	inputs.reverse()
	newInputs=inputs
	
func _on_player_player_inverted(isInverted):
	isNPCInverted=false




func generateJumpCurve(startPosition, maxJumpPosition, endPosition):
	var curvePoints = []
	var numPoints = 10
	
	for i in range(numPoints):
		var t = i / float(numPoints - 1)
		var position = quadraticInterpolation(startPosition, maxJumpPosition, endPosition, t)
		curvePoints.append(position)
		
	return curvePoints

func quadraticInterpolation(startPos, midPos, endPos, t):
	var p0 = lerp(startPos, midPos, t)
	var p1 = lerp(midPos, endPos, t)
	return lerp(p0, p1, t)
