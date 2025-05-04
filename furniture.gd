'''
Lemon-Boy-'s code was only slighlty modified for the dragging code
https://www.reddit.com/r/godot/comments/1brmbuk/how_to_set_up_click_and_drag
'''

extends Node2D

var my_subwindow : Window
var my_sprite : Sprite2D
#var node_index
var texture_size : Vector2i

var has_mouse : bool = false
var speed : int

var settings = []

func _ready():
	my_subwindow = get_node("Window")
	my_sprite = my_subwindow.get_node("Sprite2D")
	#node_index = get_index()
	
	texture_size = Vector2i(520, 520) #default values
	my_subwindow.set_size(texture_size)
	#my_collider.set_size(texture_size)
	#print("Texture size: ", texture_size)
	
	#print_tree()
	get_settings()
	speed = settings[5][1].to_int()
	
	
	'''position = my_subwindow.position
	my_sprite.position = my_subwindow.position
	my_area.position = my_subwindow.position
	my_collider.position = my_subwindow.position'''
	
	set_process(true)
	set_physics_process(true)

func _process(delta):
	
	position = my_subwindow.position
	my_sprite.position = my_subwindow.position
	#my_area.position = 1.0 * my_subwindow.position + 0.5 * texture_size #offset and coordinate system scaling differences
	#my_collider.position = 0.5 * my_subwindow.position
	#position = Vector2i(0, 0)
	#my_subwindow.position = Vector2i(100, 100)
	
	#print(position, my_subwindow.position, my_area.position)
	

#var setup_wackiness = true

func _physics_process(delta: float):
	mouse_in_window()
	
	if has_mouse and Input.is_action_pressed("left_click"):
		#print("triggered")
		
		var float_position = Vector2(my_subwindow.position.x, my_subwindow.position.y)
		my_subwindow.position = float_position.lerp(DisplayServer.mouse_get_position(), speed * delta)
	
	'''print("mouse clicked", Input.is_action_pressed("left_click"))
	print("mouse collision", has_mouse)
	print("mouse is at: ", get_global_mouse_position())
	print("mouse is actually at: ", DisplayServer.mouse_get_position())
	print("node is at: ", position)
	print("window is at: ", my_subwindow.position)
	print("target is at: ", Vector2(my_subwindow.position.x, my_subwindow.position.y).lerp(get_global_mouse_position(), speed * delta))
'''


func set_texture(my_texture):
	my_sprite.set_texture(my_texture)
	
	texture_size = Vector2i(my_texture.get_width(), my_texture.get_height())
	my_subwindow.set_size(texture_size)
	#shape.set_size(texture_size)
	#print("texture size: ", texture_size)
	

func get_settings():
	settings = [] #reset array
	
	var settings_file = FileAccess.open("user://settings.txt", FileAccess.READ)
	while !settings_file.eof_reached():
		settings.append(settings_file.get_csv_line(" "))
	settings_file.close()

func mouse_in_window():
	var mouse_pos = DisplayServer.mouse_get_position()
	
	if Input.is_action_pressed("left_click"):
		return has_mouse
	
	has_mouse = false
	if mouse_pos.x > my_subwindow.position.x:
		if mouse_pos.y > my_subwindow.position.y:
			if mouse_pos.x < (my_subwindow.position.x + texture_size.x):
				if mouse_pos.y < (my_subwindow.position.y + texture_size.y):
					has_mouse = true
	
	#print(collision)
	
	return has_mouse
