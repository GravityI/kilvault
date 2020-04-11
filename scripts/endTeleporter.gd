extends Area

func _ready():
	pass

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		$"../../../ProceduralMaze".generateMaze(20,20)
