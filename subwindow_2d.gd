'''
credits to geegaz's Multiple-Windows-tutorial
'''

extends Window

var my_camera : Camera2D

var last_position : = Vector2i.ZERO
var velocity : = Vector2i.ZERO

@export_range(0, 19) var player_visibility_layer : int = 1
@export_range(0, 19) var world_visibility_layer : int = 0

func _ready():
	my_camera = get_node("Camera2D")
	
	my_camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	
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
	
	set_canvas_cull_mask_bit(player_visibility_layer, false)
	set_canvas_cull_mask_bit(world_visibility_layer, true)


func get_camera_pos_from_window():
	return position + velocity


func _process(delta):
	velocity = position - last_position
	last_position = position
	
	var camera_position_2d = get_camera_pos_from_window()
	my_camera.position = camera_position_2d
	
	#print(camera_position_2d, position, velocity)

#this function also exists already as set_size(Vector2i)
'''func resize(x, y):
	size = Vector2i(x, y)'''

#the Window class already has a set_position(Vector2i) member
