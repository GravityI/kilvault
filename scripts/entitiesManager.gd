extends Node

const player = preload("res://assets/Player/Player.tscn")
const enemy = preload("res://assets/models/cube.glb")
#const endTeleporter = load()

func _onMapGenerated(args):
	for child in get_children():
		child.queue_free()
	var newPlayer = player.instance()
	newPlayer.translation = args[0]
	add_child(newPlayer)
	for enemyPosition in args[2]:
		var enemyInstance = enemy.instance()
		enemyInstance.translation = enemyPosition
		add_child(enemyInstance)
