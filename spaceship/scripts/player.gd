extends Node2D

var speed: float = 0
var max_speed: float = 500
var velocity: Vector2 = Vector2(0, 0)
var shield_restoraion: float = 0
@onready var speedLabel: Label = get_node("Speedometer")
@onready var sprite: Sprite2D = get_node("ShipSprite/ShieldSprite")
@onready var window = get_parent().get_window()
@onready var size = $ShipSprite.texture.get_size()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_pressed("ui_up"):
		speed += 500 * delta
		speed = min(speed, max_speed)
	if Input.is_action_pressed("ui_down"):
		speed -= 500 * delta
		speed = max(0, speed)
	if Input.is_action_pressed("ui_left"):
		rotation -= 5 * delta
	if Input.is_action_pressed("ui_right"):
		rotation += 5 * delta
	
	var x = 0.1 * cos(rotation + PI/2)
	var y = 0.1 * sin(rotation + PI/2)
	
	velocity = speed * delta * Vector2(x, y).normalized()
	speedLabel.text = "%d" % velocity.length()
	speedLabel.rotation = velocity.angle_to(Vector2(0,1))
	position += velocity
	
	borders()
	
	if shield_restoraion > 0:
		shield_restoraion -= delta
	if shield_restoraion <= 0:
		sprite.visible = true
	
func damaged():
	sprite.visible = false
	shield_restoraion = 1.0

func borders():
	if position.x < -size.x:
		position.x = window.size.x
	if position.x > window.size.x:
		position.x = -size.x
	if position.y < -size.y:
		position.y = window.size.y
	if position.y > window.size.y:
		position.y = -size.y
