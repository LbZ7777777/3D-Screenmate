'''
credits to geegaz's Multiple-Windows-tutorial
'''

extends Node

var my_main_window : Window
var my_sub_window : Window
var my_character : Node3D
#var my_char_camera : Camera3D

var settings = []

func _ready():
	#initializing sub-nodes
	my_main_window = get_window()
	my_sub_window = get_node("Window")
	my_character = get_node("animated_character")
	#my_char_camera = get_node("animated_character/Camera3D")
	
	#my_character._ready()
	my_sub_window._ready()
	
	my_sub_window.world_3d = my_main_window.world_3d
	#print(my_character.get_world_3d())
	#print(my_main_window.get_world_3d())
	#get_tree().get_root().set_transparent_background(true) #web advice for fixing black background issue
	
	#main window settings
	#ProjectSettings.set_setting("display/window/per_pixel_transparency/allowed", true)
	#my_main_window.borderless = true
	#my_main_window.unresizable = true
	#my_main_window.always_on_top = true
	#my_main_window.gui_embed_subwindows = false
	#my_main_window.transparent = true
	
	my_main_window.transparent_bg = true
	#my_sub_window.transparent_bg = true #done in subwindow's script
	
	get_settings()
	my_main_window.size = Vector2i(floor(0.1 * settings[1][1].to_int()), floor(0.2 * settings[2][1].to_int()))
	my_main_window.position = Vector2i(floor(0.45 * settings[1][1].to_int()), floor(0.4 * settings[2][1].to_int())) #initial position offset; otherwise window spawns too high and I can't reach the border to move it
	
	#print_tree()

func get_settings():
	var settings_file = FileAccess.open("user://settings.txt", FileAccess.READ)
	while !settings_file.eof_reached():
		settings.append(settings_file.get_csv_line(" "))
	settings_file.close()


func _process(delta):
	print("hello")
	
	'''my_character.position.x += delta
	my_character.position.y += delta
	#as a child node of my_character, the camera auto follows my_character's position
	#but I do need to move the main window
	my_main_window.position.x += delta / 100.0
	my_main_window.position.y += delta / -100.0'''
