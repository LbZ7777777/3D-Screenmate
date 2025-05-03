extends Window

var my_camera : Camera2D

var last_position : = Vector2i.ZERO
var velocity : = Vector2i.ZERO

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
	


func get_camera_pos_from_window():
	return position + velocity


func _process(delta):
	velocity = position - last_position
	last_position = position
	
	var camera_position_2d = get_camera_pos_from_window()
	position = camera_position_2d
