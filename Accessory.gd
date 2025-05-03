extends Sprite2D

var my_subwindow : Window

func _ready():
	my_subwindow = get_node("Window")
	
	my_subwindow.set_size(Vector2i(520, 520))

func _process(delta):
	position = my_subwindow.position
