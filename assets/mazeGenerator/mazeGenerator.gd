extends GridMap

var wallList = []
var visitedCells = []
var iterations = 0

func generateCheckers(xSize, ySize):
	for x in xSize:
		for y in ySize:
			if x % 2 != 0 or y % 2 != 0:
				placeCell(x,y,0)

func fillMaze(xSize, ySize):
	for x in xSize:
		for y in ySize:
			placeCell(x, y, 0)

func generateStartingPoint(xRange, yRange):
	return [randi() % xRange, randi() % yRange]

func getNeighbors(x, y):
	return [[x - 1, y], [x + 1, y], [x, y + 1], [x, y - 1]]

func getUnvisitedNeighbors(x, y):
	var neighborList = getNeighbors(x, y)
	for neighbor in neighborList:
		if neighbor in visitedCells:
			neighborList.erase(neighbor)
	return neighborList

func fillBorder(xSize, ySize):
	for x in xSize+1:
		placeCell(x, -1, 0)
		placeCell(x, ySize, 0)
	for y in ySize+1:
		placeCell(-1, y, 0)
		placeCell(xSize, y, 0)
	placeCell(-1, -1, 0)


func prim(xSize, ySize):
	randomize()
	var startingPoint = generateStartingPoint(xSize, ySize)
	visitedCells.append(startingPoint)
	placeCell(startingPoint[0], startingPoint[1], -1)
	for neighbor in getNeighbors(startingPoint[0], startingPoint[1]):
		wallList.append(neighbor)
	while !wallList.empty() and iterations < 5000:
		#
		#yield(get_tree(), 'idle_frame')
		var randomWall = wallList[randi() % wallList.size()]
		var visitedNeighborCount = 0
		for neighbor in getNeighbors(randomWall[0], randomWall[1]):
			if neighbor in visitedCells:
				visitedNeighborCount += 1
		if visitedNeighborCount == 1:
			placeCell(randomWall[0], randomWall[1], -1)
			visitedCells.append(randomWall)
			for neighbor in getUnvisitedNeighbors(randomWall[0], randomWall[1]):
				wallList.append(neighbor)
			wallList.erase(randomWall)
		else:
			wallList.erase(randomWall)
		iterations += 1
	fillBorder(xSize, ySize)
		
func generateMaze(x, y):
	fillMaze(x, y)
	prim(x, y)

func _ready():
	generateMaze(20,20)
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func placeCell(x, y, id):
	set_cell_item(x, 0, y, id, 0)
