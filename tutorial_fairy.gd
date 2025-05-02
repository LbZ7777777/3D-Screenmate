@tool
extends VRMTopLevel

#@onready var skeleton = get_node("GeneralSkeleton")
var skeleton
#var id

var bone
var coordinate

func _ready():
	#super._ready()
	
	print("Hello, script launched")
	
	skeleton = get_node("GeneralSkeleton")
	var count = skeleton.get_bone_count()
	print("bone count:", count)
	
	
	'''
	other useful functions:
		skeleton.find_bone("LeftEye")
		skeleton.get_bone_parent(12)
	'''
	
	'''
	id = skeleton.find_bone("LeftUpperArm")
	
	var t = skeleton.get_bone_pose(id)
	print(skeleton.get_bone_name(id))
	print("bone transform: ", t)
	#oh gosh that's a 4x3 matrix, not a 3x3 matrix
	'''
	
	bone = "LeftUpperArm"
	coordinate = 0
	
	set_process(true)
	#skeleton.set_process(true)

var LLowerArm = Vector3()
var LUpperArm = Vector3()

#copied these functions nearly straight out of the tutorial
func set_bone_rot(my_bone, ang):
	var id = skeleton.find_bone(my_bone) #identifies bone
	var rest_rotation = skeleton.get_bone_rest(id) #gets bone default position
	
	
	var newpose = rest_rotation.rotated_local(Vector3(1.0, 0.0, 0.0), ang.x) #sequentially performs x, y, and z rotations
	newpose = newpose.rotated_local(Vector3(0.0, 1.0, 0.0), ang.y)
	newpose = newpose.rotated_local(Vector3(0.0, 0.0, 1.0), ang.z)
	
	skeleton.set_bone_pose(id, newpose)
	


func _process(delta):
	#print("process running")

	if Input.is_action_pressed("X"):
		coordinate = 0
	elif Input.is_action_pressed("Y"):
		coordinate = 1
	elif Input.is_action_pressed("Z"):
		coordinate = 2
	elif Input.is_action_pressed("1"):
		bone = "LeftUpperArm"
	elif Input.is_action_pressed("2"):
		bone = "LeftLowerArm"
	
	if Input.is_action_pressed("Q"):
		if bone == "LeftLowerArm":
			LLowerArm[coordinate] += 1
		elif bone == "LeftUpperArm":
			LUpperArm[coordinate] += 1
	elif Input.is_action_pressed("E"):
		if bone == "LeftLowerArm":
			LLowerArm[coordinate] -= 1
		elif bone == "LeftUpperArm":
			LUpperArm[coordinate] -= 1
	
	set_bone_rot("LeftLowerArm", LLowerArm * delta)
	set_bone_rot("LeftUpperArm", LUpperArm * delta)
	
