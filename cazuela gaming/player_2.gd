extends CharacterBody2D


@export var positions : PackedVector2Array

var newPositions = []
const SPEED = 300
var stunned = false
var isInverted = true
var currentWaypointIndex
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().has_node("PathFollow2D"):
		look_at(get_parent().get_node("PathFollow2D").get_position() + get_parent().get_node("PathFollow2D").get_offset())

	
	
func Teleport(area):
	for portal in get_tree().get_nodes_in_group("portal"):
		if portal!= area:
			if (portal.id==area.id):
				if (!portal.lockPortal):
					area.LockedPortal()
					
					print("Stuneando al personaje")
					stunned=true
					await(get_tree().create_timer(2).timeout)
					
					global_position=portal.global_position
					print("Teletransportado con éxito")
					print("Personaje liberado")
					stunned=false
					


func _on_area_2d_area_entered(area):
	print("Se entró al area de portal")
	if (area.is_in_group("portal")):
		if(!area.lockPortal):
			Teleport(area)



func _on_player_enviar_positions(positions):
	isInverted = false
	newPositions = positions


func move_to_waypoint(waypoint: Vector2, delta: float) -> void:
	var velocity = (waypoint - position).normalized() * SPEED
	$CharacterBody2D.move_and_slide(velocity)
