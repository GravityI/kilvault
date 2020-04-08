extends KinematicBody

const fallingSpeed = 9.8

var moveSpeed = 3
var side = 0
var front = 0
var up = 0
var pressedOnce = false

onready var camera = get_node("Camera")

func _process(delta):
	#Input Handling
	if Input.is_action_just_pressed("ui_up"):
		front += 1
		pressedOnce = true
	if Input.is_action_just_pressed("ui_down"):
		front -= 1
		pressedOnce = true
	if Input.is_action_just_pressed("ui_left"):
		side += 1
		pressedOnce = true
	if Input.is_action_just_pressed("ui_right"):
		side -= 1
		pressedOnce = true
	
	if pressedOnce:
		if Input.is_action_just_released("ui_up"):
			front -= 1
		if Input.is_action_just_released("ui_down"):
			front += 1
		if Input.is_action_just_released("ui_left"):
			side -= 1
		if Input.is_action_just_released("ui_right"):
			side += 1
		
	if Input.is_action_pressed("jump") and is_on_floor():
		up = 3
		
	if !is_on_floor():
		up -= delta*fallingSpeed
		
	var motion2d = Vector2(side, front).normalized() * moveSpeed
	var motion = Vector3(motion2d.x, up, motion2d.y).rotated(Vector3.UP, camera.rotation.y)
# warning-ignore:return_value_discarded
	move_and_slide(motion, Vector3.UP)
