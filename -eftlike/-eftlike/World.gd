extends Node2D

var borders = Rect2(0, 0, 200, 64)
var numEvents = 3
var newPos = Vector2.ZERO
var tileStartPos = Vector2(100, 32)
var step = 1020
var eventArr = []
var nests = []
var eventDistance = 0
var map

onready var tileSet = $Navigation2D/TileMap
onready var nav = $Navigation2D

onready var events = [preload("res://events/ore/Ore.tscn"), preload("res://events/computer/computer.tscn")]
onready var nest = preload("res://enemies/nest.tscn")

func _ready():
	Global.updateMoney(Global.money)
	Global.world = self
	Global.tileSet = tileSet
	genWorld()

func _physics_process(delta):
	get_tree().call_group("enemy", "getTargetPath", Global.player.global_position)

func genWorld():
	Global.player.global_position = tileStartPos * 16
	genTer(tileStartPos, step, [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])

func genTer(start, steps, dir):
	var walk = walker.new(start, borders, dir)
	map = walk.walk(steps)
	walk.queue_free()
	randomize()
	var randE = 250
	var randN = 70
	for locations in map:
		if steps % randE == 0:
			spawnEvent(locations, events[randi() % events.size()])
		elif steps % randN == 0:
			spawnNest(locations, nest)
		steps -= 1
		tileSet.set_cellv(locations, 1)
	cleanTer()
	cleanNests()
	cleanTer()
	cleanNests()

#dont look at this code... it just works
func cleanNests():
	for event in eventArr:
		for nesti in nests:
			eventDistance = event.global_position.distance_to(nesti.global_position)
			if eventDistance <= 80:
				nesti.queue_free()
				nests.erase(nesti)
	for event in eventArr:
		for nest in nests:
			eventDistance = event.global_position.distance_to(nest.global_position)
			if eventDistance <= 288:
				event.nests.append(nest)

func cleanTer():
	for x in 140:
		for y in 86:
			if tileSet.get_cell_autotile_coord(x,y) == Vector2.ZERO:
				if needsRemove(x,y) >= 4:
					tileSet.set_cellv(Vector2(x,y), 1)

func needsRemove(x, y):
	var val = 0
	if tileSet.get_cellv(Vector2(x - 1, y - 1)) == 1:
		val += 1
	if tileSet.get_cellv(Vector2(x + 1, y - 1)) == 1:
		val += 1
	if tileSet.get_cellv(Vector2(x - 1, y + 1)) == 1:
		val += 1
	if tileSet.get_cellv(Vector2(x + 1, y + 1)) == 1:
		val += 1
	return val

func spawnEvent(location, object):
	var newEvent = object.instance()
	newEvent.position = (location * 16) + Vector2(8,8)
	eventArr.append(newEvent)
	self.add_child(newEvent)

func spawnNest(location, object):
	var newNest = object.instance()
	newNest.position = (location * 16) + Vector2(8,8)
	self.add_child(newNest)
	nests.append(newNest)

func newStructure(structure):
	Global.updateMoney(-structure.price)

func randPos(mn, mx):
	var pos = Vector2.ZERO
	var side = randi() % 2 + 1
	if side > 1:
		pos = Vector2(rand_range(-mn, -mx), rand_range(-mn, mx))
	else:
		pos = Vector2(rand_range(mn, mx), rand_range(-mn, mx))
	return pos
