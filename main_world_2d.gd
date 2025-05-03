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

#click and drag variables
var my_area : Area2D
var my_collider : CollisionShape2D
var shape : RectangleShape2D
var has_mouse : bool = false
var speed : int



func _ready():
	#windows configurations
	my_main_window = get_window()
	#my_sub_window = get_node("Window")
	my_main_camera = get_node("Camera2D") #. . .why geegaz . . . why do this export_node_path thing?
	my_subviewport = get_node("Screenmate/SubViewport")
	character_sprite = get_node("Screenmate")
	#my_sub_window.world_2d = my_main_window.world_2d
	
	my_area = character_sprite.get_node("Area2D")
	my_collider = my_area.get_node("CollisionShape2D")
	
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
	
	my_area.mouse_entered.connect(_on_area_2d_mouse_entered)
	my_area.mouse_exited.connect(_on_area_2d_mouse_exited)
	
	#my_area.visible = true
	
	set_process(true)


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

func _process(delta):
	#print(get_window_pos_from_camera())
	#print(my_main_camera.offset)
	#print(my_main_window.position)
	#print_tree()
	
	my_main_window.set_position(get_window_pos_from_camera())
	my_area.position = my_main_window.position
	my_collider.position = my_area.position
	
	

func _physics_process(delta: float):
	
	if has_mouse and Input.is_action_pressed("left_click"):
		var float_position = Vector2(my_main_window.position.x, my_main_window.position.y)
		my_main_window.position = float_position.lerp(my_subviewport.get_global_mouse_position(), speed * delta)


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
	

func _on_area_2d_mouse_entered():
	if not Input.is_action_pressed("left_click"):
		has_mouse = true
		print("character has mouse: ", has_mouse)

func _on_area_2d_mouse_exited():
	if not Input.is_action_pressed("left_click"):
		has_mouse = false
		print("character has mouse: ", has_mouse)
