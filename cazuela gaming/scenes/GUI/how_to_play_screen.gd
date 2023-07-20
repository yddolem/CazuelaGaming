extends Control

@onready var ost = $OSTPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	ost.play(Ostplayer.guiSongPosition)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Ostplayer.guiSongPosition =ost.get_playback_position()


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/GUI/main_menu.tscn")
