extends KinematicBody2D

var health = 50
var speed = 30
var dmg = 30
var hitTime = 2
var velocity = Vector2.ZERO
var path: Array = []
var threshold = 0
var nav = null
var obj = null
var navNum = 0
var lootTable = ["apple", "bannana", "pen"]

onready var line = $Line2D
onready var sprite = $Bobmer

func _ready():
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("levelNav"):
		nav = tree.get_nodes_in_group("levelNav")[0]

func _physics_process(delta):
	if navNum <= 0:
		line.global_position = Vector2.ZERO
		genPath()
		navigate()
		navNum = 4
	else:
		navNum -= 1
	
	move()

func navigate():
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * speed
		if global_position == path[0]:
			path.pop_front()

func genPath():
	if nav != null && obj != null:
		path = nav.get_simple_path(self.global_position, obj.global_position, false)
	line.points = path

func move():
	velocity = move_and_slide(velocity)

func damage(hp):
	health -= hp
	if health <= 0:
		die()

func die():
	randomize()
	sprite.frame = 1
	#animPlayer.stop(false)
	self.queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.die()
