extends Node

var my_camera : Camera3D
var settings = [] #actually a 2D array b/c you append arrays into it

func _ready():
	my_camera = get_node("Camera3D")
	
	var settings_file = FileAccess.open("user://settings.txt", FileAccess.READ)
	while !settings_file.eof_reached():
		settings.append(settings_file.get_csv_line(" "))
	settings_file.close()

func _process(delta):
	my_camera.position.x = get_window().position.x
	my_camera.position.y = get_window().position.y
	my_camera.position.z = settings[0][1].to_float()
