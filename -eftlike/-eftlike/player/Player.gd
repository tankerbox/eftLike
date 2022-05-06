extends KinematicBody2D

onready var player = $AnimationPlayer
onready var cam = $Camera2D
onready var eTimer = $effectTimer
onready var build1 = preload("res://structure/sheild/sheild.tscn")
onready var build2 = preload("res://structure/tripWire/tripWire.tscn")

export var health = 100

var dir = Vector2.ZERO
var odir = Vector2.ZERO

var build
var speed = 100
var curSpeed = 0
var accel = .15

func _ready():
	Global.player = self

func _physics_process(delta):
	if Input.is_action_just_pressed("build1"):
		instanceBuild(build1)
	elif Input.is_action_just_pressed("build2"):
		instanceBuild(build2)
	elif Input.is_action_pressed("build1") || Input.is_action_pressed("build2"):
		showBuild()
	elif Input.is_action_just_released("build1") || Input.is_action_just_released("build2"):
		builds()
	movement()

func movement():
	if Input.is_action_pressed("forward"):
		dir.y = -1
	elif Input.is_action_pressed("backward"):
		dir.y = 1
	else:
		dir.y = 0
	
	if Input.is_action_pressed("right"):
		dir.x = 1
	elif Input.is_action_pressed("left"):
		dir.x = -1
	else:
		dir.x = 0
	
	dir = dir.normalized()
	handleAccel()
	handleMouse()
	move_and_slide(odir * speed)

func instanceBuild(structure):
	if build != null:
		build.queue_free()
	build = structure.instance()
	self.add_child(build)
	build.global_position = get_global_mouse_position()
	build.rotation = get_node("weapon").get_child(0).rotation

func showBuild():
	if get_global_mouse_position().x >= self.global_position.x:
		build.sprite.flip_v = false
	elif get_global_mouse_position().x <= self.global_position.x:
		build.sprite.flip_v = true
	build.global_position = get_global_mouse_position()
	build.rotation = get_node("weapon").get_child(0).rotation
	build.sprite.frame = 1

func builds():
	if build.price <= Global.money:
		build.position = get_global_mouse_position()
		if get_global_mouse_position().x >= self.global_position.x:
			build.spawn(false)
		elif get_global_mouse_position().x <= self.global_position.x:
			build.spawn(true)
		get_parent().newStructure(build)
	else:
		build.queue_free()
	build = null

func handleAccel():
	if dir == Vector2.ZERO:
		odir.x = lerp(odir.x, 0, accel * 2)
		odir.y = lerp(odir.y, 0 , accel * 2)
		player.play("Idle")
	else:
		odir.x = lerp(odir.x, dir.x, accel)
		odir.y = lerp(odir.y, dir.y , accel)
		player.play("Run")

func handleMouse():
	if get_global_mouse_position().x >= self.global_position.x:
		$Sprite.flip_h = true
	elif get_global_mouse_position().x <= self.global_position.x:
		$Sprite.flip_h = false

func damage(damage):
	health -= damage
	if health <= 0:
		die()

func die():
	self.set_physics_process(false)
	Ui.playerDeath()

func startEffect():
	var rand = randi() % 3 + 1
	if rand == 1:
		speed = 200 
		eTimer.start(10)
	elif rand == 2:
		speed = 150
		eTimer.start(15)
	elif rand == 3:
		speed = 400
		eTimer.start(2)

func _on_effectTimer_timeout():
	speed = 100
