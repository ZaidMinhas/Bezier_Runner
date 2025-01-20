extends AnimatedSprite2D

static var counter := 0

@onready var timer: Timer = $Timer
@export var notice_time:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(notice_time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	play("ShootingPosition")
	counter += 1
	print("Enemy " + str(counter) + " in position")




func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
