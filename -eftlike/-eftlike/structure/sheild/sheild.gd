extends StaticBody2D

onready var col = $CollisionShape2D
onready var sprite = $Sprite
onready var empowerZone = $empowerZone
onready var eCol = $empowerZone/CollisionShape2D

var disabled = false
var price = 20

func spawn(idk):
	self.set_as_toplevel(true)
	sprite.frame = 0
	col.disabled = false

func _on_empowerZone_body_entered(body):
	pass

func disable():
	col.scale = Vector2.ZERO
	eCol.scale = Vector2.ZERO
	sprite.frame = 2
	disabled = true
