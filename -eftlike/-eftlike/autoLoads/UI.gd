extends CanvasLayer

onready var label = $Label

func _ready():
	Global.GUI = self

func playerDeath():
	$Label2.visible = true
