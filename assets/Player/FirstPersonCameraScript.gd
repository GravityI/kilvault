extends Camera

var sensitivity = 10
var time = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	time = delta
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	

func _input(event):
	if event is InputEventMouseMotion:
		var amount = event.relative * sensitivity * time
		
		rotation_degrees.x -= amount.y
		rotation_degrees.x = clamp(rotation_degrees.x, -60, 60)
		rotation_degrees.y -= amount.x
		transform = transform.orthonormalized()
