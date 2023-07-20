extends Control

var currentLevel
var nextMissionId 
@onready var ost = $OSTPLAYER
# Called when the node enters the scene tree for the first time.
func _ready():
	currentLevel = CurrentScene
	setMissionSuccessInfo()
	ost.play(Ostplayer.songPosition)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Ostplayer.songPosition=ost.get_playback_position()
	
func setMissionSuccessInfo():
	updateUI()
func updateUI():
	$"MarginContainer/VBoxContainer/MISSION NUMBER".text = " MISSION 00" + str(CurrentScene.misionId) + " COMPLETED"



func _on_back_to_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/GUI/main_menu.tscn")
	CurrentScene.misionId = 0


func _on_next_mission_button_pressed():
	nextMissionId = CurrentScene.misionId + 1
	CurrentScene.misionId = nextMissionId
	var nextScene = CurrentScene.levelArray[nextMissionId]
	get_tree().change_scene_to_file(nextScene)	
	
func _on_quit_to_desktop_button_pressed():
	get_tree().quit()
