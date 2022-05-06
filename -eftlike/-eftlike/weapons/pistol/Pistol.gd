extends "res://weapons/weapon.gd"

func _physics_process(delta):
	if Input.is_action_just_pressed("shoot") && curFireRate < 1:
		shoot(delta)
	else:
		self.position = lerp(self.position, start, .2)
	if Input.is_action_just_released("shoot"):
		angRec = 0
	curFireRate -= 1
