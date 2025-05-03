'''
Lemon-Boy-'s code was only slighlty modified for the dragging code
https://www.reddit.com/r/godot/comments/1brmbuk/how_to_set_up_click_and_drag
'''

extends Node2D

var my_subwindow : Window
var my_sprite : Sprite2D
#var node_index
var texture_size : Vector2i

var my_area : Area2D
var my_collider : CollisionShape2D
var shape : RectangleShape2D

var has_mouse : bool = false
var speed : int

var settings = []

func _ready():
	my_subwindow = get_node("Window")
	my_sprite = my_subwindow.get_node("Sprite2D")
	my_area = my_subwindow.get_node("Area2D")
	my_collider = my_area.get_node("CollisionShape2D")
	#node_index = get_index()
	
	texture_size = Vector2i(520, 520) #default values
	my_subwindow.set_size(texture_size)
	#my_collider.set_size(texture_size)
	shape = RectangleShape2D.new()
	shape.size = texture_size
	my_collider.set_shape(shape)
	#print("Texture size: ", texture_size)
	
	#print_tree()
	get_settings()
	speed = settings[5][1].to_int()
	
	my_area.mouse_entered.connect(_on_area_2d_mouse_entered)
	my_area.mouse_exited.connect(_on_area_2d_mouse_exited)
	
	'''position = my_subwindow.position
	my_sprite.position = my_subwindow.position
	my_area.position = my_subwindow.position
	my_collider.position = my_subwindow.position'''
	
	set_process(true)

func _process(delta):
	
	position = my_subwindow.position
	my_sprite.position = my_subwindow.position
	my_area.position = 1.0 * my_subwindow.position + 0.5 * texture_size #offset and coordinate system scaling differences
	#my_collider.position = 0.5 * my_subwindow.position
	#position = Vector2i(0, 0)
	#my_subwindow.position = Vector2i(100, 100)
	
	#print(position, my_subwindow.position, my_area.position)
	

#var setup_wackiness = true

func _physics_process(delta: float):
	'''if setup_wackiness:
		var float_position = Vector2(my_subwindow.position.x, my_subwindow.position.y)
		my_subwindow.position = float_position.lerp(get_global_mouse_position(), speed * delta)
		setup_wackiness = false'''
	
	if has_mouse and Input.is_action_pressed("left_click"):
		var float_position = Vector2(my_subwindow.position.x, my_subwindow.position.y)
		my_subwindow.position = float_position.lerp(get_global_mouse_position(), speed * delta)
	
	#print("mouse is at: ", get_global_mouse_position())
	#print("window is at: ", my_subwindow.position)



func set_texture(my_texture):
	my_sprite.set_texture(my_texture)
	
	texture_size = Vector2i(my_texture.get_width(), my_texture.get_height())
	my_subwindow.set_size(texture_size)
	#shape.set_size(texture_size)
	#print("texture size: ", texture_size)
	shape = RectangleShape2D.new()
	shape.size = texture_size
	my_collider.set_shape(shape)
	
	#attempt to trigger the strange jump without clicking
	#. . . did not work, or at least not as intended
	'''my_subwindow.position = 0.5 * Vector2(settings[1][1].to_int(), settings[2][1].to_int())
	position = my_subwindow.position
	my_sprite.position = my_subwindow.position
	my_area.position = my_subwindow.position
	my_collider.position = my_subwindow.position'''


func _on_area_2d_mouse_entered():
	has_mouse = true
	print("furniture has mouse: ", has_mouse)

func _on_area_2d_mouse_exited():
	
	while Input.is_action_pressed("left_click"):
		has_mouse = true
		await get_tree().create_timer(0.1).timeout
	
	has_mouse = false
	print("furniture has mouse: ", has_mouse)

func get_settings():
	settings = [] #reset array
	
	var settings_file = FileAccess.open("user://settings.txt", FileAccess.READ)
	while !settings_file.eof_reached():
		settings.append(settings_file.get_csv_line(" "))
	settings_file.close()
