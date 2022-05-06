extends TileMap
class_name walker

var directions = null

var pos = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var stepHist = []
var stepsSinceTurn = 0

func _init(startPos, newBorder, dirs):
	print(startPos)
	assert(newBorder.has_point(startPos))
	directions = dirs
	pos = startPos
	stepHist.append(pos)
	borders = newBorder

func walk(steps):
	for step in steps:
		if randf() <= 0.4 || stepsSinceTurn >= 3:
			changeDir()
		if step():
			stepHist.append(pos)
		else:
			changeDir()
	return stepHist

func step():
	var targetPos = pos + direction
	if borders.has_point(targetPos):
		stepsSinceTurn += 1
		pos = targetPos
		return true
	else:
		return false

func changeDir():
	randomize()
	stepsSinceTurn = 0
	var directionl = directions.duplicate()
	directionl.erase(direction)
	directionl.shuffle()
	direction = directionl.pop_front()
	while !borders.has_point(pos + direction):
		direction = directionl.pop_front()
