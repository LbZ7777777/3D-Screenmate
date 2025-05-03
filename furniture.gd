extends Node2D

var my_subwindow : Window
var my_sprite : Sprite2D
#var node_index

func _ready():
	my_subwindow = get_node("Window")
	my_sprite = my_subwindow.get_node("Sprite2D")
	
	#node_index = get_index()
	
	my_subwindow.set_size(Vector2i(520, 520))

func _process(delta):
	position = my_subwindow.position
	#position = Vector2i(0, 0)
	#my_subwindow.position = Vector2i(100, 100)
	
	#print(my_subwindow.size, position, my_subwindow.position)

func set_texture(my_texture):
	my_sprite.set_texture(my_texture)
