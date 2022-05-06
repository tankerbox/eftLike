extends RigidBody2D

var damage = 20

func _ready():
	set_as_toplevel(true)

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy") || body.is_in_group("bomber"):
		body.damage(damage)
		self.queue_free()
	elif body.is_in_group("empower"):
		empower(body)
	else:
		self.queue_free()

func empower(body):
	if !body.disabled:
		damage *= 2
		$Sprite.frame = 1
