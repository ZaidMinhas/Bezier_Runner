extends Line2D

@onready var path_2d: Path2D = $"../Path2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	points = path_2d.curve.get_baked_points()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
