extends Node2D

onready var nav = $Navigation2D

func _on_Timer_timeout():
	get_tree().call_group("enemy", "getTargetPath", Global.player.global_position)
