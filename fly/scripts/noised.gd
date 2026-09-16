extends Node2D

var rng = RandomNumberGenerator.new()
var velocity: Vector2 = Vector2(0, 0)
@onready var window = get_parent().get_window()
@onready var size = self.get_child(0).texture.get_size()

enum State {DEAD, ALIVE}
var state: State = State.ALIVE

var noise: FastNoiseLite
var time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var x = rng.randi_range(size.x, window.size.x - size.x)
	var y = rng.randi_range(size.y, window.size.y - size.y)
	position.x = x
	position.y = y
	
	velocity.x = rng.randi_range(10, 100)
	velocity.y = rng.randi_range(10, 100)
	
	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.fractal_octaves = 3
	noise.fractal_lacunarity = 2.0
	noise.fractal_gain = 0.5
	noise.frequency = rng.randf() + 0.1
	noise.seed = 42


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == State.DEAD:
		return
	var nx = noise.get_noise_2d(time * 0.02, 0.0)
	var ny = noise.get_noise_2d(time * 0.02, 100.0)
	time += delta * 20
	position.x = remap(nx, -1, 1, 0, window.size.x)
	position.y = remap(ny, -1, 1, 0, window.size.y)

func kill():
	state = State.DEAD
	scale.y = 0.1

func arise():
	state = State.ALIVE
	scale.y = 1.0

func _input(event):
	if event is InputEventMouseButton:
		var x_c = false
		var y_c = false
		if event.pressed:
			var mpos= event.position
			if ((position.x - size.x / 2) < mpos.x and 
				(position.x + size.x / 2) > mpos.x):
				x_c = true
			if ((position.y - size.y / 2) < mpos.y and 
				(position.y + size.y / 2) > mpos.y):
				y_c = true
			if x_c and y_c:
				if event.button_index == MOUSE_BUTTON_LEFT:
					kill()
				if event.button_index == MOUSE_BUTTON_RIGHT:
					arise()
