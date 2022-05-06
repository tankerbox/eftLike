extends StaticBody2D

onready var col = $CollisionShape2D
onready var sight = $Area2D/CollisionPolygon2D
onready var sprite = $TurretBase
onready var turret = $turret
onready var muzzle = $turret/muzzle
onready var turretSprite = $turret/TurretTurret
onready var bullet = preload("res://bullets/bullet.tscn")

var flip = 1
var threats = []
var defRot = 0
var speed = 500
var fireRate = 30
var curFireRate = 0
var price = 30

func _ready():
	set_physics_process(false)

func spawn(flipped):
	if !flipped:
		turret.position = Vector2(-1, -1)
	else:
		turret.position = Vector2(-1, 7)
		turretSprite.flip_v = true
		defRot = 180
	set_physics_process(true)
	turretSprite.visible = true
	col.disabled = false
	sprite.frame = 0
	self.set_as_toplevel(true)

func _process(delta):
	if threats.size() > 0:
		turret.look_at(threats[0].global_position)

func _physics_process(delta):
	if threats.size() > 0:
		attack()
	curFireRate -= 1
	curFireRate = clamp(curFireRate, -1, fireRate)

func attack():
	if curFireRate <= 0:
		var newBullet = bullet.instance()
		self.add_child(newBullet)
		newBullet.global_position = muzzle.global_position
		newBullet.rotation = muzzle.global_position.direction_to(threats[0].global_position).angle()
		newBullet.set_linear_velocity(Vector2(cos(global_position.direction_to(threats[0].global_position).angle()), sin(global_position.direction_to(threats[0].global_position).angle())) * speed)
		curFireRate = fireRate

func _on_Area2D_body_entered(body):
	if body.is_in_group("bomber"):
		threats.append(body)

func _on_Area2D_body_exited(body):
	if body.is_in_group("bomber"):
		threats.erase(body)
