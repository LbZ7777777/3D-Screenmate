@tool
extends Node3D

var scene #PackedScene
var character #instantiated scene
var node #node in scene tree
var my_script

func _ready():
	scene = preload("res://tutorial_fairy.vrm")
	character = scene.instantiate()
	add_child(character)
	
	print_tree()
	
	node = get_node("tutorial_fairy")
	#print(node)
	my_script = load("res://tutorial_fairy_animation_version.gd") #.new()
	#print(my_script)
	node.set_script(my_script)
	#print(node.get_script())
	
	node._ready() #these two lines are both necessary for the script to actually run in full
	node.set_process(true)
	

'''expected input is just the model name, no file extension'''
func _swap_model(filename : String):
	character.quene_free()
	
	var path = "res://" + filename + ".vrm"
	
	scene = load(path)
	character = scene.instantiate()
	add_child(character)
	
	node = get_node(filename)
	node.set_script(my_script)
	node._ready()
	node.set_process(true)
