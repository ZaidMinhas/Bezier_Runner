extends RigidBody2D
class_name Player


enum State {IDLE, PLANNING, ATTACK}
var currstate = null

var endPointPrefab =  preload("res://EndPoint.tscn")
var controlPointPrefab = preload("res://ControlPoint.tscn")
@onready var path_2d: Path2D = $"../Path2D"
@onready var path_follow_2d: PathFollow2D = $"../Path2D/PathFollow2D"


var endPoint:EndPoint
var points
@onready var line_2d: Line2D = $"../Line2D"


func _ready() -> void:
	pauseGravity()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currstate == null:
		transition(State.IDLE)
	elif currstate == State.IDLE:
		if (Input.is_action_just_pressed("ENDPOINT_TERMINATE")):
			endPoint.set_process(false)
			transition(State.PLANNING)
			
	elif currstate == State.PLANNING:
		drawBezierCurve()
		if (Input.is_action_just_pressed("ENDPOINT_TERMINATE")):
			points[1].set_process(false)
			points[2].set_process(false)
			transition(State.ATTACK)
	elif currstate == State.ATTACK:
		PathFollow(delta)
		angular_velocity = 10
		if (path_follow_2d.progress_ratio == 1):
			leftControlPoint.queue_free()
			rightControlPoint.queue_free()
			endPoint.queue_free()
			var N = line_2d.get_point_count()
			linear_velocity = (line_2d.get_point_position(N-1) - line_2d.get_point_position(N-2)).normalized()*600
			 
			for i in range(N):
				line_2d.set_point_position(i, Vector2.ZERO)
			path_follow_2d.progress_ratio = 0
			resumeGravity()
			transition(State.IDLE)
			
		
func transition(state:State):
	currstate = state
	if currstate == State.IDLE:
		CreateEndPoint()
	if currstate == State.PLANNING:
		angular_velocity = 0
		pauseGravity()
		CreateControlPoints()
	if currstate == State.ATTACK:
		
		bake_curve()
		
func CreateEndPoint():
	endPoint = endPointPrefab.instantiate()
	add_sibling(endPoint)
	
	endPoint.position =  position #Vector2(600,300)

var leftControlPoint
var rightControlPoint
func CreateControlPoints():
	
	leftControlPoint = controlPointPrefab.instantiate()
	rightControlPoint = controlPointPrefab.instantiate()
	leftControlPoint.lefty = true
	rightControlPoint.righty = true
	get_parent().add_child(leftControlPoint)
	get_parent().add_child(rightControlPoint)
	var direction = endPoint.position -  position
	print(rotation)
	leftControlPoint.position = position + Vector2(cos(rotation), sin(rotation))*500
	
	rightControlPoint.position = endPoint.position + Vector2(cos(rotation), sin(rotation))*500
	#leftControlPoint.position = position + direction*0.1
	rightControlPoint.position = endPoint.position - direction*0.1
	
	points = [self, leftControlPoint, rightControlPoint, endPoint]


func drawBezierCurve():
	
	var N = line_2d.get_point_count()
	
	for i in range(N-1):
		var t = (i*1.0)/N
		
		var p_t = _cubic_bezier(position, points[1].position, points[2].position, points[3].position, t)
		line_2d.set_point_position(i, p_t)
	line_2d.set_point_position(N-1, points[3].position)
	
func PathFollow(delta):
	path_follow_2d.progress += delta*1000*1.5
	move_and_collide(path_follow_2d.position-position)
	#rotation = path_follow_2d.rotation
	rotate(delta*10)
		
	

func resumeGravity():
	#pass
	gravity_scale = 0.2
	var collision:CollisionPolygon2D =  get_child(0)
	collision.disabled = false
	
func pauseGravity():
	
	gravity_scale = 0
	linear_velocity = Vector2.ZERO
	var collision:CollisionPolygon2D =  get_child(0)
	#collision.disabled = true

func bake_curve():
	path_2d.curve.clear_points()
	for i in range(100):
		var t = i/100.0
		var p_t = _cubic_bezier(points[0].position, points[1].position, points[2].position, points[3].position, t)
		path_2d.curve.add_point(p_t)
	
		

func _cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var q2 = p2.lerp(p3, t)

	var r0 = q0.lerp(q1, t)
	var r1 = q1.lerp(q2, t)

	var s = r0.lerp(r1, t)
	return s
