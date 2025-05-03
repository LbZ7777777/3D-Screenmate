'''
credits to geegaz's Multiple-Windows-tutorial
'''

extends Node

var my_main_window : Window
var my_sub_window : Window

var settings = []

@export_range(0, 19) var player_visibility_layer : int = 1
@export_range(0, 19) var world_visibility_layer : int = 0

@export_node_path("Camera2D") var main_camera : NodePath
var my_main_camera : Camera2D

var my_subviewport : SubViewport


func _ready():
	#windows configurations
	my_main_window = get_window()
	my_sub_window = get_node("Window")
	my_main_camera = get_node(main_camera) #. . .why geegaz . . . why do this export_node_path thing?
	my_subviewport = get_node("Screenmate/SubViewport")
	
	my_sub_window.world_2d = my_main_window.world_2d
	
	get_tree().get_root().set_transparent_background(true)
	get_viewport().transparent_bg = true
	ProjectSettings.set_setting("display/window/per_pixel_transparency/allowed", true)
	my_main_window.borderless = true
	my_main_window.unresizable = true
	my_main_window.always_on_top = true
	my_main_window.gui_embed_subwindows = false
	my_main_window.transparent = true
	
	my_main_window.transparent_bg = true
	
	my_sub_window._ready()
	
	get_settings()
	my_sub_window.set_size(Vector2i(settings[3][1].to_int(), settings[4][1].to_int()))
	
	#my_sub_window.set_position(Vector2i(0, 0))
	
	#visibility layer things
	my_main_window.set_canvas_cull_mask_bit(player_visibility_layer, false)
	my_main_window.set_canvas_cull_mask_bit(world_visibility_layer, true)


func get_settings():
	settings = [] #reset array
	
	var settings_file = FileAccess.open("user://settings.txt", FileAccess.READ)
	while !settings_file.eof_reached():
		settings.append(settings_file.get_csv_line(" "))
	settings_file.close()

func get_window_pos_from_camera():
	var player_size = my_subviewport.get_size()
	return Vector2i(my_main_camera.global_position + my_main_camera.offset) - player_size[0] / 2

func _process(delta):
	my_main_window.position = get_window_pos_from_camera()
