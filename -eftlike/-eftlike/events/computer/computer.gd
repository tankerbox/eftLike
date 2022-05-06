extends Area2D

onready var sprite = $Cache
onready var timer = $Timer
onready var navPoint = $navPoint

var tileSet = null
var waitTime = .5
var object = null
var started = false
var finished = false
var nests = []
var area = 20
var difficulty = 10
var newDrill = null
var on = false

func _input(event):
	if object != null:
		if event.is_action_pressed("Interact") && object.is_in_group("player") && !started:
			startEvent()
		if event.is_action_pressed("Interact") && object.is_in_group("player") && finished:
			print("event done")
			sprite.frame = 4
			finished = false
			Global.updateMoney(120)
			on = false

func getNests():
	for nest in Global.nests:
		if (self.global_position.distance_to(nest.global_position)) <=  65:
			nest.queue_free()
		elif (self.global_position.distance_to(nest.global_position)) <=  161:
			Global.nests.append(nest)

func startEvent():
	if Global.eventOn == false:
		on = true
		timer.start()
		started = true
		startSpawning()

func startSpawning():
	print(str(nests))
	Global.eventOn = true
	sprite.frame = 1
	for nest in nests:
		if nest.exists(nest.get_path()):
			nest.startSpawning(nests.size() * 2 + 1)
			nest.curObj = self

func eventDeath():
	finished = false
	Global.eventOn = false
	sprite.frame = 3
	for nest in nests:
		nest.eventDone()

func eventFinish():
	finished = true
	Global.eventOn = false
	sprite.frame = 2
	for nest in nests:
		nest.eventDone()

func _on_Timer_timeout():
	eventFinish()

func _on_computer_body_entered(body):
	if body.is_in_group("bomber") && Global.eventOn && on:
		eventDeath()
	if body.is_in_group("player"):
		object = body

func _on_computer_body_exited(body):
	if object != null:
		object = null

func getNavPoint():
	return navPoint.global_position
