extends Node2D
class_name EndPoint
@export var speed:float = 100
		




func _process(delta: float) -> void:
	
	position.x += Input.get_axis("EndPointMove_LEFT", "EndPointMove_RIGHT")*speed*delta
	position.y += Input.get_axis("EndPointMove_UP", "EndPointMove_DOWN")*speed*delta
	
