extends Node2D

@export var speed:float = 100

var lefty:= false
var righty:= false
func _process(delta: float) -> void:
	if lefty:
		leftControls(delta)
	if righty:
		rightControls(delta)


func leftControls(delta):
		position.x += Input.get_axis("ControlPointMove_LEFT", "ControlPointMove_RIGHT")*speed*delta
		position.y += Input.get_axis("ControlPointMove_UP", "ControlPointMove_DOWN")*speed*delta


func rightControls(delta):
	position.x += Input.get_axis("EndPointMove_LEFT", "EndPointMove_RIGHT")*speed*delta
	position.y += Input.get_axis("EndPointMove_UP", "EndPointMove_DOWN")*speed*delta
