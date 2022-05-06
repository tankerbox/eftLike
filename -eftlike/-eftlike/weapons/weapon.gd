extends Node2D

export (NodePath) var spritePath
export (NodePath) var muzzlePath
onready var bullet = preload("res://bullets/bullet.tscn")

var muzzle = null
var sprite = null

export (Vector2) var start = Vector2(0, 0)
export (Vector2) var end = Vector2(0, 0)
export (int) var fireRate = 0
var curFireRate = 0
export (int) var speed = 0
export (float) var rec = 0
export (float) var angRec = 0
export (float) var maxRec = 0

func _ready():
	muzzle = get_node(muzzlePath)
	sprite = get_node(spritePath)

func _process(delta):
	self.look_at(get_global_mouse_position())
	handleMouse()

func shoot(delta):
	var newBullet = bullet.instance()
	self.add_child(newBullet)
	newBullet.global_position = muzzle.global_position
	newBullet.look_at(get_global_mouse_position())
	newBullet.set_linear_velocity(Vector2(cos(rotation + deg2rad(rand_range(-angRec,angRec))), sin(rotation + deg2rad(rand_range(-angRec,angRec)))) * speed)
	curFireRate = fireRate
	applyRecoil(delta)
	randomize()

func applyRecoil(delta):
	self.position.x -= abs(cos(self.rotation) * rec)
	self.position.y -= abs(sin(self.rotation) * rec)
	self.position.x = clamp(self.position.x, -3, 3)
	self.position.y = clamp(self.position.y, -3, 3)
	angRec += rec
	get_parent().get_parent().cam.shoot(angRec * 3, delta)
	angRec = clamp(angRec, 0, maxRec)

func handleMouse():
	if get_global_mouse_position().x >= self.global_position.x:
		sprite.scale.y = 1
	elif get_global_mouse_position().x <= self.global_position.x:
		sprite.scale.y = -1
