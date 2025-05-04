'''
credits to geegaz's Multiple-Windows-tutorial
'''

extends Node

var my_main_window : Window
#var my_sub_window : Window
var my_sprites = []

var settings = []

@export_range(0, 19) var player_visibility_layer : int = 1
@export_range(0, 19) var world_visibility_layer : int = 0

#@export_node_path("Camera2D") var main_camera : NodePath
var my_main_camera : Camera2D

var my_subviewport : SubViewport

#var my_bookshelf : Node2D
var character_sprite : Sprite2D

var the_character_3d : Node3D
var the_camera_3d : Camera3D

#click and drag variables
var has_mouse : bool = false
var speed : int

#pseudo-gravity variable
var detector : Node
var rect = [0.0, 0.0, 100.0, 100.0]
var y_max : int #ceiling (y points down); stop pseudo-gravity when reached

func _ready():
	#windows configurations
	my_main_window = get_window()
	#my_sub_window = get_node("Window")
	my_main_camera = get_node("Camera2D") #. . .why geegaz . . . why do this export_node_path thing?
	my_subviewport = get_node("Screenmate/SubViewport")
	character_sprite = get_node("Screenmate")
	#my_sub_window.world_2d = my_main_window.world_2d
	the_character_3d = my_subviewport.get_node("animated_character")
	the_camera_3d = my_subviewport.get_node("Camera3D")
	
	detector = get_node("ForegroundWindow/window_detector")
	detector.ForegroundWindow.connect(_on_window_update)
	
	character_sprite.texture = my_subviewport.get_texture()
	character_sprite.visible = true
	the_character_3d.visible = true
	
	get_tree().get_root().set_transparent_background(true)
	get_viewport().transparent_bg = true
	ProjectSettings.set_setting("display/window/per_pixel_transparency/allowed", true)
	my_main_window.borderless = true
	my_main_window.unresizable = true
	my_main_window.always_on_top = true
	my_main_window.gui_embed_subwindows = false
	my_main_window.transparent = true
	
	my_main_window.transparent_bg = true
	
	#my_sub_window._ready()
	
	get_settings()
	#my_sub_window.set_size(Vector2i(settings[3][1].to_int(), settings[4][1].to_int()))
	
	#my_sub_window.set_position(Vector2i(0, 0))
	y_max = settings[2][1].to_int() - 0.5 * character_sprite.get_rect().size[1]
	
	#visibility layer things
	my_main_window.set_canvas_cull_mask_bit(player_visibility_layer, true)
	my_main_window.set_canvas_cull_mask_bit(world_visibility_layer, false)
	
	load_sprite("bookshelf")
	#my_bookshelf = get_node("bookshelf")
	#my_bookshelf.set_texture(load("res://bookshelf.png"))
	
	#adjust draw order
	#var character_node_level = character_sprite.get_index()
	adjust_draw_order()
	#print(character_sprite.get_index())
	#print(my_sprites[0].get_index())
	#print(my_sprites.size())
	
	#click and drag stuff
	'''shape = RectangleShape2D.new()
	shape.size = my_subviewport.size
	my_collider.set_shape(shape)'''
	#print("Texture size: ", texture_size)
	
	#print_tree()
	get_settings()
	speed = settings[5][1].to_int()
	
	
	#my_area.visible = true
	
	set_process(true)
	set_physics_process(true)


func get_settings():
	settings = [] #reset array
	
	var settings_file = FileAccess.open("user://settings.txt", FileAccess.READ)
	while !settings_file.eof_reached():
		settings.append(settings_file.get_csv_line(" "))
	settings_file.close()

func get_window_pos_from_camera():
	#print(my_main_camera)
	#return Vector2i(0, 0)
	var player_size = my_subviewport.get_size()
	return Vector2i(my_main_camera.global_position + my_main_camera.offset) - player_size / 2

func adjust_draw_order():
	#move_child(character_sprite, my_sprites.size() + 1)
	character_sprite.move_to_front()
	
	#character_sprite.visible = true
	#my_subviewport.visible = true

func _process(delta):
	#print("other target: ", get_window_pos_from_camera())
	#print(my_main_camera.offset)
	#print(my_main_window.position)
	#print_tree()
	
	my_main_window.set_position(get_window_pos_from_camera())
	
	

func _physics_process(delta: float):
	#drag and drop
	mouse_in_window()
	
	if has_mouse and Input.is_action_pressed("left_click"):
		#print("triggered")
		
		var float_position = Vector2(my_main_window.position.x, my_main_window.position.y)
		my_main_camera.position = float_position.lerp(DisplayServer.mouse_get_position(), speed * delta)
		character_sprite.position = my_main_camera.position
	else:	
		#pseudo-gravity
		print("triggered")
		
		hit_foreground_window()
		
		if character_sprite.position.y < y_max:
			var y_new = character_sprite.position.y + speed * delta
			if y_new > y_max:
				y_new = y_max - 1 #without the -1 the sprite would blow straight past the limit
			
			my_main_camera.position.y = y_new
			character_sprite.position.y = y_new
	
		#print(my_main_window.position)
	'''print("window position: ", my_main_window.position)
	print("2d camera location: ", my_main_camera.position)
	print("2d character location: ", character_sprite.position)
	print("mouse location: ", DisplayServer.mouse_get_position())
	print("collision: ", has_mouse)
	print("clicking: ", Input.is_action_pressed("left_click"))
	print("character location: ", the_character_3d.position)
	print("3d camera location: ", the_camera_3d.position)
	print(character_sprite.texture)'''
	



func load_sprite(filename):
	var furniture = load("res://furniture.tscn")
	var furniture_obj = furniture.instantiate()
	add_child(furniture_obj)
	
	my_sprites.append(get_node("furniture"))
	#my_sprites[-1]._ready() #seems extraneous
	
	#print_tree()
	
	#print(my_sprites)
	
	my_sprites[-1].set_texture(load("res://" + filename + ".png"))
	
	#print(my_sprites[-1].get_texture())
	
	var window = my_sprites[-1].get_node("Window")
	#window._ready() #might be unneeded
	window.world_2d = my_main_window.world_2d
	

func mouse_in_window():
	var mouse_pos = DisplayServer.mouse_get_position()
	
	if Input.is_action_pressed("left_click"):
		return has_mouse
	
	has_mouse = false
	if mouse_pos.x > character_sprite.position.x:
		if mouse_pos.y > character_sprite.position.y:
			if mouse_pos.x < (character_sprite.position.x + my_subviewport.size.x):
				if mouse_pos.y < (character_sprite.position.y + my_subviewport.size.y):
					has_mouse = true
	
	#print(collision)
	
	return has_mouse

func hit_foreground_window():
	var center_of_gravity = character_sprite.position #is centered, so no offset needed
	
	y_max = settings[2][1].to_int() - 0.5 * character_sprite.get_rect().size[1]
	if center_of_gravity.y < rect[1]: #screenmate is higher than the foreground window
		if (rect[0] < center_of_gravity.x) and (center_of_gravity.x < rect[2]): #screenmate is above foreground window
			y_max = rect[1]
			
			print("triggered")
			print("COG: ", center_of_gravity.y)
			print("threshold: ", rect[1])
			print("y_max: ", y_max)
	


func _on_window_update(x1, y1, x2, y2):
	rect = [x1, y1, x2, y2]
