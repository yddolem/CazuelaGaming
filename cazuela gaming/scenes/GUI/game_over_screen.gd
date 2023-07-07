extends Control
var gameoverReason: String
var gameoverTip: String
var game_over_reason
var currentLevel
# Called when the node enters the scene tree for the first time.
func _ready():
	game_over_reason = GameOverReason
	setGameoverInfo()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func setGameoverInfo():
	print("cambiando la pantalla del game over")
	gameoverReason = game_over_reason.reason
	gameoverTip = game_over_reason.tip
	updateUI()
func updateUI():
	$MarginContainer/VBoxContainer/REASON.text = gameoverReason
	$MarginContainer/VBoxContainer/TIP.text = gameoverTip


func _on_quit_to_desktop_button_pressed():
	get_tree().quit()


func _on_retry_button_pressed():
	var currentMissionId =CurrentScene.misionId
	var currentScene = CurrentScene.levelArray[currentMissionId]
	get_tree().change_scene_to_file(currentScene)

func _on_back_to_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/GUI/main_menu.tscn")
