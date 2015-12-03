
extends Node2D

var ropepart_packed
var first_rope_pos
var ropes = []
var pressed = false


func _ready():
	ropepart_packed =  load("res://ropepart.xscn")
	first_rope_pos = get_node("rope_anchor").get_global_pos()
	set_process(true)
	

func _process(delta):
	#strange bug: only the first rope doesn't have collision!
	var add = Input.is_action_pressed("ui_accept")
	if add and not pressed:
		pressed = true
		add_rope()			
	elif not add:
		pressed = false
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
func add_rope():	
	var rp = ropepart_packed.instance()
	var offset = rp.get_node("pin").get_pos()
	var rope_pos
	var anchor
	
	if ropes.empty():
		rope_pos = first_rope_pos
		anchor = get_node("massive").get_path()
	else:
		rope_pos = ropes[ropes.size()-1].get_node("end").get_global_pos()
		anchor = ropes[ropes.size()-1].get_path()
#trying to set coll-shape by code doesn't help first rope having collision...	
#	var shape = SegmentShape2D.new()
#	shape.set_a(rp.get_node("pin").get_pos())
#	shape.set_b(rp.get_node("end").get_pos())
#	rp.get_node("collision").set_shape(shape)
	rp.set_global_pos(rope_pos - offset)
	rp.get_node("pin").set_global_pos(rope_pos)
	rp.get_node("pin").set_node_a(anchor)
	rp.get_node("pin").set_node_b("..")
	add_child(rp)
	ropes.push_back(rp)	