extends Node2D

var rng = RandomNumberGenerator.new()
@export var nflies: int = 10
@onready var fly_scene = preload("res://scenes/fly.tscn")
@onready var bee_scene = preload("res://scenes/bee.tscn")
@onready var scripts = [preload("res://scripts/simple_motion.gd"),
						preload("res://scripts/random_step.gd"),
						preload("res://scripts/noised.gd"),]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in nflies:
		var insect_instance
		if rng.randf() <= 0.3: 
			insect_instance = bee_scene.instantiate()
		else: 
			insect_instance = fly_scene.instantiate()
		insect_instance.set_script(scripts.pick_random())
		add_child(insect_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
