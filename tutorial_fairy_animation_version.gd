@tool
extends VRMTopLevel

var skeleton
var current_animation
var previous_animation

func _ready():
	
	skeleton = get_node("GeneralSkeleton")
	var count = skeleton.get_bone_count()
	print("bone count:", count)
	
	for i in range(count):
		print(i, "\t", skeleton.get_bone_name(i))
	
	current_animation = "idle"
	previous_animation = current_animation
	
	set_process(true)

#copied these functions nearly straight out of the tutorial
func set_bone_rot(my_bone, ang):
	var id = skeleton.find_bone(my_bone) #identifies bone
	var rest_rotation = skeleton.get_bone_rest(id) #gets bone default position
	
	
	var newpose = rest_rotation.rotated_local(Vector3(1.0, 0.0, 0.0), ang.x) #sequentially performs x, y, and z rotations
	newpose = newpose.rotated_local(Vector3(0.0, 1.0, 0.0), ang.y)
	newpose = newpose.rotated_local(Vector3(0.0, 0.0, 1.0), ang.z)
	
	skeleton.set_bone_pose(id, newpose)
	


#func _process(delta):
	#print("process running")
	
	#set_bone_rot(placeholder, angles)
