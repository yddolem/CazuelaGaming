extends Area2D

var lockPortal = false
var lockPortalNPC = false
@onready var animated_sprite=$AnimatedSprite2D
@export var id = 0

var isReadyNPC = false
var isReadyPlayer = false

func LockedPortal():
	lockPortal = true
	await(get_tree().create_timer(10).timeout	)
	lockPortal=false

func LockedPortalNPC():
	lockPortalNPC = true
	await(get_tree().create_timer(10).timeout	)
	lockPortalNPC=false
	
	
func readyToTeleport():
	if isReadyNPC & isReadyPlayer:
		return true
	else:
		return false

func _ready():
	pass
