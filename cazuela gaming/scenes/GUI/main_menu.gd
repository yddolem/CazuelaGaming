extends Control
var currentLevel
@onready var ost = $OSTPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	ost.play(Ostplayer.guiSongPosition)
	
func _physics_process(delta):
	Ostplayer.guiSongPosition = ost.get_playback_position()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_1_0.tscn")


func _on_how_to_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/GUI/how_to_play_screen.tscn")

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/GUI/credits.tscn")

func _on_quit_button_pressed():
	get_tree().quit()



