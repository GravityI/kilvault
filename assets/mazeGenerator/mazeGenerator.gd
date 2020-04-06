extends GridMap

var wallList = []
var visitedCells = []

func fillMaze(xSize, ySize):
	for x in xSize:
		for y in ySize:
			placeCell(x, y, 0)
			#Add Floor
			set_cell_item(x, -1, y, 1)

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

func eraseBorder(xSize, ySize):
	for x in xSize+1:
		placeCell(x, -1, -1)
		placeCell(x, ySize, -1)
	for y in ySize+1:
		placeCell(-1, y, -1)
		placeCell(xSize, y, -1)
	placeCell(-1, -1, -1)


func prim(xSize, ySize):
	randomize()
	var startingPoint = generateStartingPoint(xSize, ySize)
	visitedCells.append(startingPoint)
	placeCell(startingPoint[0], startingPoint[1], -1)
	for neighbor in getNeighbors(startingPoint[0], startingPoint[1]):
		wallList.append(neighbor)
	while !wallList.empty():
		#yield lets you see each iteration step by step
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
				if get_cell_item(neighbor[0], 0, neighbor[1]) == 0:
					wallList.append(neighbor)
			wallList.erase(randomWall)
		else:
			wallList.erase(randomWall)

func secondPass(xSize, ySize):
	for x in xSize:
		for y in ySize:
			if get_cell_item(x, 0, y) == 0:
				var emptyNeighborCount = 0
				for neighbor in getNeighbors(x, y):
					if get_cell_item(neighbor[0], 0, neighbor[1]) == 0:
						emptyNeighborCount += 1
				if emptyNeighborCount == 0:
					placeCell(x, y, -1)
			
func generateMaze(x, y):
	visitedCells = []
	wallList = []
	eraseBorder(x, y)
	fillMaze(x, y)
	prim(x, y)
	fillBorder(x, y)
	secondPass(x, y)

func _ready():
	generateMaze(20, 20)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("jump"):
		generateMaze(20, 20)

func placeCell(x, y, id):
	set_cell_item(x, 0, y, id, 0)
