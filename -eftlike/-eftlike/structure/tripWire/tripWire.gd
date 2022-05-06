extends Area2D

onready var sprite = $Tripwire

var disabled = false
var coolDown = 15
var price = 12

func _on_tripWire_body_entered(body):
	if (body.is_in_group("bomber") || body.is_in_group("enemy")) && !disabled:
		body.queue_free()
		disable()

func disable():
	disabled = true
	$Timer.start(coolDown)
	sprite.frame = 2

func _on_Timer_timeout():
	disabled = false
	sprite.frame = 0

func spawn(uselessVar):
	self.set_as_toplevel(true)
	sprite.frame = 0
	self.global_position = get_global_mouse_position()
