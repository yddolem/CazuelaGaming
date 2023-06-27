extends Control

var currentLevel
# Called when the node enters the scene tree for the first time.
func _ready():
	currentLevel = CurrentScene
	setMissionSuccessInfo()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func setMissionSuccessInfo():
	updateUI()
func updateUI():
	$"MarginContainer/VBoxContainer/MISSION NUMBER".text = " MISSION 00" + str(currentLevel.current_level_number) + " COMPLETED"



func _on_back_to_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/GUI/main_menu.tscn")


func _on_next_mission_button_pressed():
	pass
	

func _on_quit_to_desktop_button_pressed():
	get_tree().quit()
