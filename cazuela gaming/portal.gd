extends Area2D

var lockPortal = false

@export var id = 0

func LockedPortal():
	lockPortal = true
	await(get_tree().create_timer(0.5).timeout	)
	lockPortal=false


func _ready():
	pass
