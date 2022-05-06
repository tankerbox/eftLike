extends Camera2D

var player = null
var multiplyer = 1
var pRot 

var shakeAmount = 0
var defaulOffset = offset

func _ready():
	player = get_parent()
	self.set_as_toplevel(true)

func shoot(amount, delta):
	shakeAmount = amount
	offset = Vector2(rand_range(-shakeAmount, shakeAmount), rand_range(shakeAmount, - shakeAmount)) * delta + defaulOffset
	applyRecoil()

func _physics_process(delta):
	self.global_position = lerp(global_position, player.global_position, .3)

func applyRecoil():
	shakeAmount += 3
	shakeAmount = clamp(shakeAmount, 0, 20)
