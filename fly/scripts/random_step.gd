extends Node2D

var rng = RandomNumberGenerator.new()
var velocity: Vector2 = Vector2(0, 0)

@onready var window = get_parent().get_window()
@onready var size = self.get_child(0).texture.get_size()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var x = rng.randi_range(size.x, window.size.x - size.x)
	var y = rng.randi_range(size.y, window.size.y - size.y)
	position.x = x
	position.y = y
	velocity.x = rng.randi_range(10, 100)
	velocity.y = rng.randi_range(10, 100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var value = rng.randf()
	if value < 0.55:
		position.x += velocity.x * delta
	elif value >= 0.55 and value < 0.70:
		position.x -= velocity.x * delta
	elif value >= 0.70 and value < 0.85:
		position.y += velocity.y * delta
	else:
		position.y -= velocity.y * delta
