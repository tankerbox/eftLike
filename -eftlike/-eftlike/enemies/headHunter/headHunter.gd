extends KinematicBody2D

var health = 100
var speed = 30
var dmg = 30
var hitTime = 2
var velocity = Vector2.ZERO
var path: Array = []
var threshold = 16
var nav = null
var player = null
var navNum = 0
var canHit = true
var lootTable = ["apple", "bannana", "pen"]

onready var corpse = preload("res://enemies/corpse.tscn")
onready var animPlayer: AnimationPlayer = $AnimationPlayer
onready var sprite = $HeadHunter
onready var hitHand = $hitHandler
onready var hitCast = $hitHandler/RayCast2D
onready var timer = $Timer
onready var line = $Line2D
onready var col = $CollisionShape2D
onready var lootCol = $lootCol

func _ready():
	yield(get_tree(), "idle_frame")
	animPlayer.play("run")
	var tree = get_tree()
	if tree.has_group("levelNav"):
		nav = tree.get_nodes_in_group("levelNav")[0]
	if tree.has_group("player"):
		player = tree.get_nodes_in_group("player")[0]

func _physics_process(delta):
	if navNum <= 0:
		line.global_position = Vector2.ZERO
		genPath()
		navigate()
		navNum = 4
	else:
		navNum -= 1
	
	if player != null:
		hitHand.look_at(player.global_position)
	
	if hitCast.is_colliding():
		attack()
	
	move()

func _process(delta):
	pass

func navigate():
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * speed
		if global_position == path[0]:
			path.pop_front()

func genPath():
	if nav != null && player != null:
		path = nav.get_simple_path(self.global_position, player.global_position, false)
	line.points = path

func move():
	velocity = move_and_slide(velocity)

func attack():
	if canHit == true:
		print("attack")
		hitCast.get_collider().damage(dmg)
		timer.start(hitTime)
		canHit = false

func damage(hp):
	health -= hp
	if health <= 0:
		die()

func die():
	randomize()
	sprite.frame = 3
	animPlayer.stop(false)
	col.queue_free()
	lootCol.set_deferred("monitorable", true)
	lootCol.set_deferred("monitoring", true)
	sprite.z_index = 1
	self.set_physics_process(false)

func _on_Timer_timeout():
	canHit = true

func _on_lootCol_body_entered(body):
	randomize()
	if body.is_in_group("player"):
		var shouldEffect = randi() % 5 + 1
		if shouldEffect == 2:
			player.startEffect()
		if shouldEffect == 4:
			getLoot()
		Global.updateMoney(10)
		self.queue_free()

func getLoot():
	print("got loot")
