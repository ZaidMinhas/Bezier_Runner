extends Node2D
class_name PathManager

@onready var start_to_end: Line2D = $StartToEnd
var start
var end
var is_ready:= false

func set_path(start_point, end_point):
	start = start_point
	end = end_point
	is_ready = true
	
func _process(delta: float) -> void:
	if is_ready:
		start_to_end.set_point_position(0, start.position) 
		start_to_end.set_point_position(1, end.position)
