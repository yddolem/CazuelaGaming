extends Area2D

var lockPortal = false
@onready var animated_sprite=$AnimatedSprite2D
@export var id = 0

var isReadyNPC = false
var isReadyPlayer = false

func LockedPortal():
	lockPortal = true
	await(get_tree().create_timer(10).timeout	)
	lockPortal=false


func _ready():
	pass
