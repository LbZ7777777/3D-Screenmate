extends StaticBody2D

var detector : Node
var shape : RectangleShape2D
var collider : CollisionShape2D

var rect = [0.0, 0.0, 100.0, 100.0] #stores previous foreground window coords

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#initialize all the child nodes
	detector = get_node("window_detector")
	detector.ForegroundWindow.connect(_on_window_update)
	
	collider = get_node("CollisionShape2D")
	
	shape = RectangleShape2D.new()
	shape.set_size(Vector2(100, 100))
	collider.set_shape(shape)


# Called every frame. 'delta' is the elapsed time since the previous frame.
'''func _process(delta: float) -> void:
	pass'''


func _on_window_update(x1, y1, x2, y2):
	var rectangle = [x1, y1, x2, y2]
	
	if rectangle != rect:
		#adjust collider size
		shape = RectangleShape2D.new()
		shape.set_size(Vector2(x2 - x1, y2 - y1))
		collider.set_shape(shape)
		
		#adjust collider position
		position.x = 0.5 * (x1 + x2) #collision object attaches to center of window
		position.y = 0.5 * (y1 + y2)
