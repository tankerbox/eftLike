extends Node2D

onready var enemies = [preload("res://enemies/headHunter/headHunter.tscn"), preload("res://enemies/bomber/bomber.tscn")]
onready var timer = $Timer
onready var randTimer = $randTimer

var spawnTime = 0
var curObj = null
var tree = null
var randTime = 80

func _ready():
	tree = get_tree()
	randTimer.start(rand_range(randTime - 60, randTime))
	Global.nests.append(self)

func startSpawning(diff):
	if diff >= 5:
		spawnTime = 20
	elif diff == 4:
		spawnTime = 14
	elif diff == 3:
		spawnTime = 8
	else:
		spawnTime = 5
	randomize()
	timer.start(rand_range(spawnTime / 2, spawnTime + 4))

func stopSpawning():
	timer.stop()

func _on_Timer_timeout():
	instanceEnemy()

func instanceEnemy():
	randomize()
	var newE = enemies[randi() % enemies.size()].instance()
	self.add_child(newE)
	if newE.is_in_group("bomber") && curObj != null:
		newE.obj = curObj
	elif newE.is_in_group("bomber"):
		newE.obj = Global.player
	newE.global_position = self.global_position
	newE.genPath()

func eventDone():
	curObj = null
	var bombArr = tree.get_nodes_in_group("bomber")
	for bomber in bombArr:
		bomber.die()
	timer.stop()

func _on_randTimer_timeout():
	instanceEnemy()
	var newRand = (rand_range(randTime - 15, randTime + 10))
	randTime = newRand
	randTimer.start(randTime)
