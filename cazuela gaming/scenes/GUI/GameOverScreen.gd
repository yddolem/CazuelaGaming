extends CanvasLayer


func _on_retry_button_pressed():
	get_tree().change_scene_to_file("res://prueba.tscn")

func _on_back_to_menu_button_pressed():
	pass
	#get_tree().change_scene_to_file("res://menu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
