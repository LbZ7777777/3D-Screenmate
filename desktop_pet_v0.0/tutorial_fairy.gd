@tool
extends VRMTopLevel

var skeleton
var id

func _ready():
	skeleton = get_node("GeneralSkeleton")
	var count = skeleton.get_bone_count()
	print("bone count:", count)
	
	'''
	for i in range(count):
		print(skeleton.get_bone_name(i))
	'''
	
	'''
	other useful functions:
		skeleton.find_bone("LeftEye")
		skeleton.get_bone_parent(12)
	'''
	
	id = skeleton.find_bone("LeftUpperArm")
	
	var t = skeleton.get_bone_pose(id)
	print(skeleton.get_bone_name(id))
	print("bone transform: ", t)
	#oh gosh that's a 4x3 matrix, not a 3x3 matrix
	
	set_process(true)


func _process(delta):
	var t = skeleton.get_bone_pose(id)
	t = t.rotated(Vector3(1.0, 0.0, 0.0), 0.1 * delta)
	skeleton.set_bone_pose(id, t)
	
	#print("bone transform: ", t)
