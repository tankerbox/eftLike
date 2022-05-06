extends Area2D

onready var drill = preload("res://structure/drill/drill.tscn")
onready var sprite = $Ore
onready var timer = $Timer

var tileSet = null
var waitTime = .5
var object = null
var started = false
var finished = false
var dead = false
var nests = []
var area = 20
var difficulty = 10
var newDrill = null

func _input(event):
	if object != null:
		if event.is_action_pressed("Interact") && object.is_in_group("player") && !started:
			startEvent()
		if event.is_action_pressed("Interact") && object.is_in_group("player") && finished:
			print("event done")
			newDrill.sprite.frame = 2
			finished = false
			Global.updateMoney(80)

func getNests():
	for nest in Global.nests:
		if (self.global_position.distance_to(nest.global_position)) <=  65:
			nest.queue_free()
		elif (self.global_position.distance_to(nest.global_position)) <=  161:
			Global.nests.append(nest)

func startEvent():
	if Global.eventOn == false:
		timer.start()
		started = true
		newDrill = drill.instance()
		add_child(newDrill)
		newDrill.position = Vector2.ZERO
		startSpawning()

func startSpawning():
	print(str(nests))
	Global.eventOn = true
	for nest in nests:
		nest.startSpawning(nests.size())
		nest.curObj = self

func eventDeath():
	finished = false
	dead = true
	Global.eventOn = false
	if newDrill != null:
		newDrill.sprite.frame = 3
	sprite.frame = 1
	for nest in nests:
		nest.eventDone()

func eventFinish():
	finished = true
	Global.eventOn = false
	newDrill.sprite.frame = 1
	sprite.frame = 1
	for nest in nests:
		nest.eventDone()

func _on_Ore_body_entered(body):
	if body.is_in_group("player"):
		object = body

func _on_Ore_body_exited(body):
	if object != null:
		object = null

func _on_Timer_timeout():
	if !dead:
		eventFinish()

func _on_drillCol_body_entered(body):
	if body.is_in_group("bomber") && Global.eventOn:
		eventDeath()
