'''
credits to geegaz's Multiple-Windows-tutorial
'''

extends Window

var settings = [] #actually a 2D array b/c you append arrays into it

var my_camera : Camera3D

var last_position : = Vector2i.ZERO
var velocity : = Vector2i.ZERO

func _ready():
	get_settings()
	
	my_camera = get_node("Camera3D")
	
	transient = true
	close_requested.connect(queue_free)
	
	get_tree().get_root().set_transparent_background(true)
	get_viewport().transparent_bg = true
	ProjectSettings.set_setting("display/window/per_pixel_transparency/allowed", true)
	borderless = true
	unresizable = true
	always_on_top = true
	gui_embed_subwindows = false
	transparent = true
	
	transparent_bg = true
	
	size = Vector2i(floor(0.1 * settings[1][1].to_int()), floor(0.2 * settings[2][1].to_int()))
	
	position = Vector2i(400, 500)
	#position = Vector2i(floor(0.45 * settings[1][1].to_int()), floor(0.4 * settings[2][1].to_int())) #initial position offset; otherwise window spawns too high and I can't reach the border to move it

func get_camera_pos_from_window():
	return position + velocity

func get_settings():
	var settings_file = FileAccess.open("user://settings.txt", FileAccess.READ)
	while !settings_file.eof_reached():
		settings.append(settings_file.get_csv_line(" "))
	settings_file.close()

func _process(delta):
	velocity = position - last_position
	last_position = position
	
	var camera_position_2d = get_camera_pos_from_window()
	my_camera.position.x = camera_position_2d.x / 100.0 - 0.0045 * settings[1][1].to_int()
	my_camera.position.y = camera_position_2d.y / -100.0 + 0.00475 * settings[2][1].to_int()
	my_camera.position.z = settings[0][1].to_float()
	
	#print(my_camera.position)
	
