extends GridMap

signal canSpawn

var wallList = []
var visitedCells = []
var playerSpawn = []
var enemySpawns = []
var levelEnd = []
var spawnSignalArgs = []

func placeCell(x, y, id):
	set_cell_item(x, 0, y, id, 0)

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

func getRandomOpenCell(xSize, ySize):
	var cell = [randi() % xSize, randi() % ySize]
	if get_cell_item(cell[0], 0, cell[1]) != -1:
		getRandomOpenCell(xSize, ySize)
	return cell

func setPlayerSpawn(xSize, ySize):
	for x in xSize:
		for y in ySize:
			if get_cell_item(x, 0, y) == -1:
				return [x, y]

func setLevelEnd(xSize, ySize):
	for x in range(xSize, 1, -1):
		for y in range(ySize, 1, -1):
			if get_cell_item(x, 0, y) == -1:
				return [x, y]

func getOpenNeighbors(x, y):
	var neighborCount = 0
	for z in getNeighbors(x, y):
		if get_cell_item(z[0], 0, z[1]) == -1:
			neighborCount += 1
	return neighborCount

func getPossibleEnemySpawns(xSize, ySize):
	var possibleEnemySpawns = []
	for x in range(xSize - 3, 1, -1):
		for y in range(ySize - 3, 1, -1):
			if get_cell_item(x, 0, y) == -1 and getOpenNeighbors(x, y) > 3:
				var neighbouringEnemy = false
				for neighbor in getNeighbors(x, y):
					if neighbor in possibleEnemySpawns:
						neighbouringEnemy = true
						break
				if !neighbouringEnemy:
					possibleEnemySpawns.append([x, y])
	return possibleEnemySpawns

func setEnemySpawns(xSize, ySize, quantity):
	while enemySpawns.size() < quantity:
		var spawn = getPossibleEnemySpawns(xSize, ySize)[randi() % getPossibleEnemySpawns(xSize, ySize).size()]
		if !spawn in enemySpawns:
			enemySpawns.append(spawn)
			

func generateMaze(x, y):
	visitedCells = []
	wallList = []
	enemySpawns = []
	#Standard Maze generator
	eraseBorder(x, y)
	fillMaze(x, y)
	prim(x, y)
	fillBorder(x, y)
	#Game specific generator
	secondPass(x, y)
	playerSpawn = setPlayerSpawn(x, y)
	levelEnd = setLevelEnd(x, y)
	placeCell(playerSpawn[0], playerSpawn[1], 2)
	placeCell(levelEnd[0], levelEnd[1], 3)
	setEnemySpawns(x, y, 10)
	var enemyList = []
	for enemy in enemySpawns:
		enemyList.append(map_to_world(enemy[0], 0, enemy[1]))
	spawnSignalArgs = [map_to_world(playerSpawn[0], 0, playerSpawn[1]), map_to_world(levelEnd[0], 0, levelEnd[1]), enemyList]
	emit_signal("canSpawn", spawnSignalArgs)
	

func _ready():
	connect("canSpawn", $"../entitiesManager", "_onMapGenerated")
	generateMaze(20, 20)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("generateMap"):
		generateMaze(20, 20)
