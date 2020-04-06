extends RigidBody

const fallingSpeed = 1

var moveSpeed = 100
var side = 0
var front = 0
var jumping = 0
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
		jumping = 10
	
	linear_velocity.y = jumping
	
	if !touchingFloor:
		jumping -= 1
	elif touchingFloor:
		linear_velocity.y = 0
		jumping = 0
		
	print(linear_velocity)

	if front != 0 or side != 0:
		#Movement
		var velocity = -Vector3(side, 0, front).rotated(Vector3.UP, camera.rotation.y) * delta * moveSpeed
		linear_velocity.x = velocity.x
		linear_velocity.z = velocity.z
	
		
		#Rotation
#		var angle = atan2(linear_velocity.x, linear_velocity.z)
#		var direction = playerMeshPivot.rotation
#		direction.y = angle
#		playerMeshPivot.transform.basis = Basis(Quat(playerMeshPivot.transform.basis).slerp(Basis(direction), 0.2).normalized())
	else:
		#Brake smoothly when not moving
		linear_velocity.x = lerp(linear_velocity.x, 0, 0.5)
		linear_velocity.z = lerp(linear_velocity.z, 0, 0.5)

func isTouchingFloor():
	if touchingFloor:
		jumping = 0.1

func _on_RigidBody_body_entered(body):
	if body.is_in_group("floor"):
		touchingFloor = true
		jumping = 0
