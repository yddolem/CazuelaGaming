extends PathFollow2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta:float)->void:
	const move_speed=200
	$".".progress += move_speed	 * delta
