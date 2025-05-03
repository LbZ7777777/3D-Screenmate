@tool
extends VRMTopLevel

var skeleton
var current_animation : String
var new_animation : String
var runtime : float
var action_script
var bone_list

func _ready():
	var secondary_node = get_node("secondary") #calling all constructors in the vrm scene
	secondary_node._ready()
	
	#setting up animation stuff
	skeleton = get_node("GeneralSkeleton")
	var count = skeleton.get_bone_count()
	print("bone count:", count)
	
	for i in range(count):
		print(i, "\t", skeleton.get_bone_name(i))
	
	current_animation = "test_animation"
	new_animation = current_animation
	
	#load animation file
	load_animation("test_animation")
	
	set_process(true)

#copied these functions nearly straight out of the tutorial
func set_bone_rot(my_bone, ang):
	var id = skeleton.find_bone(my_bone) #identifies bone
	var rest_rotation = skeleton.get_bone_rest(id) #gets bone default position
	
	
	var newpose = rest_rotation.rotated_local(Vector3(1.0, 0.0, 0.0), ang.x) #sequentially performs x, y, and z rotations
	newpose = newpose.rotated_local(Vector3(0.0, 1.0, 0.0), ang.y)
	newpose = newpose.rotated_local(Vector3(0.0, 0.0, 1.0), ang.z)
	
	skeleton.set_bone_pose(id, newpose)
	

#new_animation shoud be changed by a func on_signal
func load_animation(filename : String = "idle"):
	var file_position = "res://" + filename + ".txt"
	var content
	if FileAccess.file_exists(file_position):
		current_animation = filename
		var file = FileAccess.open(file_position, FileAccess.READ)
		
		runtime = 0.0 #reset animation information
		action_script = [] #reset action script
		
		bone_list = []
		while !file.eof_reached():
			content = file.get_csv_line(" ") #reads line into several strings
			
			if !bone_list.has(content[0]): #helps organize action_script
				bone_list.append(content[0])
				action_script.append([content])
				'''
				action_script is an array of arrays of arrays, so effectively a
				3D array.
				1st organizational level: different bones
				2nd organizational level: different times
				3rd organizational level: different transform informations
				'''
			else:
				var index = action_script.find(content[0])
				action_script[index].append(content)
		#print(action_script)



func _process(delta):
	#print("process running")
	#set_bone_rot(placeholder, angles)
	
	if current_animation != new_animation: #change animations
		#print("animation changer triggered")
		
		#load new animation file
		load_animation(new_animation)
	
	#continue/run animation
	for i in range(bone_list.size()): #loop through all bones with animations
		#print("entered bone loop for bone: ", bone_list[i])
		
		#identify animation
		var action0 = 0 #bone pose index occuring just before runtime
		var action1 = 0 #bone pose index occuring just after runtime
		var stylus = 0 #named after the turntable part of similar function
		var keepgoing = true
		var end_of_array = action_script[i].size()
		var action0_full
		var action1_full
		
		if action_script[i][0][1].to_float() > runtime: #need to use current bone position as action0
			#print("triggered before 1st keyframe if statement")
			
			keepgoing = false
			var current_rotationQ = skeleton.get_bone_pose_rotation(skeleton.find_bone(action_script[i][0][0])) #this is a quarternion
			var current_rotation = current_rotationQ.get_euler()
			action0_full = [action_script[i][0][0], "0.00", str(current_rotation.x), str(current_rotation.y), str(current_rotation.z)]
			action1_full = action_script[i][0]
		
		while keepgoing:
			#print("triggered keyframe searcher")
			
			if stylus >= end_of_array: #identify bone's animation finished
				#print("triggered out of keyframes")
				
				action1 = action0
				break
			
			if action_script[i][stylus][1].to_float() < runtime:
				action0 = stylus
				stylus += 1
			else:
				#print("triggered found next keyframe")
				
				action1 = stylus #stylus exits loop as the index of action1
				keepgoing = false
		
		#clean up action_script
		action0_full = action_script[i][action0]
		action1_full = action_script[i][action1]
		while stylus > 1:
			#print("cleaning array")
			action_script[i].pop_front() #this might be a bad idea
			stylus -= 1
		
		#perform animation
		#calculate interpolation
		var a : float = action0_full[1].to_float() #time 1
		var b : float = action1_full[1].to_float() #time 2
		var c = Vector3(action0_full[2].to_float(), action0_full[3].to_float(), action0_full[4].to_float())
		var d = Vector3(action1_full[2].to_float(), action1_full[3].to_float(), action1_full[4].to_float())
		var s : float = action1_full[5].to_float()
		
		var angles : Vector3
		if a != b: #possibly causing computational issues? Yes!!!!
			angles = pow(((runtime - a) / (b - a)), s) * (d - c) + c
		else:
			angles = c
		
		#print("updating skeleton rotations")
		set_bone_rot(action_script[i][0][0], angles * delta)
		
		#print("Current Bone Position", skeleton.get_bone_pose_position(skeleton.find_bone(action_script[i][0][0])))
	
	
	#increment runtime
	#print("incrementing time")
	runtime = runtime + delta
	
	#print_tree()
