extends KinematicBody

const fallingSpeed = 9.8

var currentMoveSpeed = 3
var moveSpeed = 3
var side = 0
var front = 0
var up = 0
var pressedOnce = false
var motion2d = Vector3()
var motion = Vector3()
var crouching = false
var aiming = false

onready var camera = $"Camera"
onready var stateMachine = $"../PlayerStateMachine"
onready var gun = $"Camera/gun"

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
	
	if Input.is_action_pressed("aim") and stateMachine.state != stateMachine.states.SPRINT:
		gun.translation.x = lerp(gun.translation.x, 0, 0.1)
		camera.fov = lerp(camera.fov, 50, 0.1)
		if !crouching: moveSpeed = 1.5
		else: moveSpeed = 1
		aiming = true
	elif (Input.is_action_pressed("aim") and stateMachine.state == stateMachine.states.SPRINT):
		gun.translation.x = lerp(gun.translation.x, 0.3, 0.1)
		camera.fov = lerp(camera.fov, 70, 0.1)
		moveSpeed = 5
		aiming = false
	elif (!Input.is_action_pressed("aim") and stateMachine.state != stateMachine.states.SPRINT):
		gun.translation.x = lerp(gun.translation.x, 0.3, 0.1)
		camera.fov = lerp(camera.fov, 70, 0.1)
		if !crouching: moveSpeed = 3
		else: moveSpeed = 1.5
		aiming = false
	
	if (!Input.is_action_pressed("crouch") and stateMachine.state != stateMachine.states.SPRINT) or (Input.is_action_pressed("crouch") and stateMachine.state == stateMachine.states.SPRINT):
		if !aiming: moveSpeed = 1.5
		else: moveSpeed = 1
		crouching = true
	elif !Input.is_action_pressed("crouch") and stateMachine.state != stateMachine.states.SPRINT:
		if !aiming: moveSpeed = 3
		else: moveSpeed = 1.5
		crouching = false
		
	if !is_on_floor():
		up -= delta*fallingSpeed
	
	currentMoveSpeed = lerp(currentMoveSpeed, moveSpeed, 0.1)
	
	motion2d = Vector2(side, front).normalized() * currentMoveSpeed
	motion = Vector3(motion2d.x, up, motion2d.y).rotated(Vector3.UP, camera.rotation.y)
# warning-ignore:return_value_discarded
	move_and_slide(motion, Vector3.UP)
