extends KinematicBody

const fallingSpeed = 1

var moveSpeed = 3
var side = 0
var front = 0
var up = 0
var motion = Vector3()
var snap = Vector3()
var touchingFloor = false


onready var camera = get_node("Camera")

func _process(delta):
	#Input Handling
	if Input.is_action_just_pressed("ui_up"):
		front += 1
	if Input.is_action_just_pressed("ui_down"):
		front -= 1
	if Input.is_action_just_pressed("ui_left"):
		side += 1
	if Input.is_action_just_pressed("ui_right"):
		side -= 1

	if Input.is_action_just_released("ui_up"):
		front -= 1
	if Input.is_action_just_released("ui_down"):
		front += 1
	if Input.is_action_just_released("ui_left"):
		side -= 1
	if Input.is_action_just_released("ui_right"):
		side += 1
	
	if Input.is_action_just_pressed("jump"):
		up = 2
		snap = Vector3()
	
	up -= delta
	motion = -Vector3(side*moveSpeed, -up, front*moveSpeed).rotated(Vector3.UP, camera.rotation.y)
	move_and_slide(motion, -Vector3.UP)
	
