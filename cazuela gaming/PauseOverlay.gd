extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused= true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _input(event):
	if event is InputEventKey and event.keycode == KEY_SPACE and event.pressed:
		get_tree().paused = false
		hide()
		queue_free()
	
