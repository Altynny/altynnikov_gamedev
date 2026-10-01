extends Node2D

var acceleration: Vector2 = Vector2(0, 0)
var velocity: Vector2 = Vector2(0, 0)
var max_force: float = 10
var max_speed: float = 6
var max_distance: int = 100
var min_distance: int = 30
@onready var window = get_parent().get_window()
@onready var size = $Sprite2D.texture.get_size()

func _ready() -> void:
	var x = randi_range(size.x, window.size.x - size.x)
	var y = randi_range(size.y, window.size.y - size.y)
	position.x = x
	position.y = y
	acceleration = Vector2(randi_range(0, 50), randi_range(0, 50))

func _process(delta: float) -> void:
	velocity += acceleration * delta
	velocity = velocity.limit_length(max_speed)
	position += velocity
	borders()
	acceleration *= 0
	rotation = velocity.angle()
	
func apply_force(force: Vector2):
	acceleration = force

func seek(target: Vector2):
	var direction = target - position
	var desired_velocity = direction.normalized() * max_speed
	#var m = remap(direction.length(), min_distance, max_distance, 0, 1)
	var steering = (desired_velocity - velocity)
	steering = steering.limit_length(max_force)
	apply_force(steering)
	
func flee(target: Vector2):
	var direction = position - target
	if direction.length() > max_distance:
		return
	var desired_velocity = direction.normalized() * max_speed
	var steering = (desired_velocity - velocity)
	steering = steering.limit_length(max_force)
	apply_force(steering)
	
func pursue(target: Vector2, target_velocity: Vector2):
	var direction = target - position
	var speed: float = velocity.length()
	if speed == 0:
		speed = max_speed
	var ahead_time: float = direction.length() / speed
	var predict = target + target_velocity * ahead_time
	seek(predict)
	
func evade(target: Vector2, target_velocity: Vector2):
	var direction = target - position
	var speed: float = velocity.length()
	if direction.length() > max_distance:
		return
	if speed == 0:
		speed = max_speed
	var ahead_time: float = direction.length() / speed
	var predict = target + target_velocity * ahead_time
	flee(predict)

func separate(group: Node2D):
	var steering: Vector2 = Vector2.ZERO
	var count: int = 0
	for child in group.get_children():
		if self == child: continue
		var direction: Vector2 = child.position - position
		var distance: float = direction.length()
		if distance >= 0 and distance < max_distance:
			var away: Vector2 = -direction.normalized()
			away *= (1 / distance)
			steering += away
			count += 1
	if count > 0: 
		steering /= count
		steering = steering.normalized() * max_speed
		steering -= velocity
		steering = steering.limit_length(max_force)
		apply_force(steering)

func cohesion(group: Node2D):
	var com: Vector2 = Vector2.ZERO
	var count: int = 0
	for child in group.get_children():
		if self == child: continue
		var direction: Vector2 = child.position - position
		var distance: float = direction.length()
		if distance >= 0 and distance < max_distance:
			com += child.position 
			count += 1
	if count > 0:
		com /= count
		seek(com)

func alignment(group: Node2D):
	var mean_velocity: Vector2 = Vector2.ZERO
	var count: int = 0
	for child in group.get_children():
		if self == child: continue
		var direction: Vector2 = child.position - position
		var distance: float = direction.length()
		if distance >= 0 and distance < max_distance:
			mean_velocity += child.velocity
			count += 1
	if count > 0:
		mean_velocity /= count
		mean_velocity = mean_velocity.normalized() * max_speed
		mean_velocity -= velocity
		var steering = mean_velocity - velocity
		apply_force(steering.limit_length(max_force))

func borders():
	if position.x < -size.x:
		position.x = window.size.x
	if position.x > window.size.x:
		position.x = -size.x
	if position.y < -size.y:
		position.y = window.size.y
	if position.y > window.size.y:
		position.y = -size.y
