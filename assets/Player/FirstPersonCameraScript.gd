extends Camera

const bulletHole = preload("res://UI/crosshairs/image0007.png")

var sensitivity = 10
var time = 0
var canShoot = true
var fireRate = 5

onready var gun = $"gun"
onready var ray = $"RayCast"
onready var playerBody = get_parent()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$"FireRate".wait_time = 10/fireRate

func _process(delta):
	time = delta
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if Input.is_action_pressed("fire") and canShoot:
		checkRayCollision()
		canShoot = false
		$"FireRate".start()
		gun.translation.z += 0.2

#	if Input.is_action_pressed("aim"):
#		gun.translation.x = lerp(gun.translation.x, 0, 0.1)
#		fov = lerp(fov, 50, 0.1)
#		playerBody.moveSpeed = playerBody.moveSpeed/2
#	else:
#		gun.translation.x = lerp(gun.translation.x, 0.3, 0.1)
#		fov = lerp(fov, 70, 0.1)
#		playerBody.moveSpeed = 3
	
	if gun.translation.z > -0.3:
		gun.translation.z = lerp(gun.translation.z, -0.3, 0.1)
	
	if playerBody.motion.x + playerBody.motion.z != 0:
		gun.translation.y = lerp(gun.translation.y, -0.3, 0.1)
#		gun.rotation_degrees.y = lerp(gun.rotation_degrees.y, -180, 0.1)
	else:
		gun.translation.y = lerp(gun.translation.y, -0.22, 0.1)
		gun.rotation_degrees.y = lerp_angle(gun.rotation_degrees.y, -180, 0.1)

# Gun running animation - Doesn't work yet
#	if playerBody.motion.x + playerBody.motion.z != 0:
#		var dir = true
#		if dir:
#			gun.rotation_degrees.y = lerp_angle(gun.rotation_degrees.y, 200, 0.5)
#		else:
#			gun.rotation_degrees.y = lerp_angle(gun.rotation_degrees.y, 100, 0.5)
#		if gun.rotation_degrees.y >= 200:
#			dir = false
#		elif gun.rotation_degrees.y <= 100:
#			dir = true
#		print(gun.rotation_degrees.y)
#	else:
#		gun.rotation_degrees.y = lerp_angle(gun.rotation_degrees.y, 180, 0.1)

func _input(event):
	if event is InputEventMouseMotion:
		var amount = event.relative * sensitivity * time
		
		rotation_degrees.x -= amount.y
		rotation_degrees.x = clamp(rotation_degrees.x, -60, 60)
		rotation_degrees.y -= amount.x
		transform = transform.orthonormalized()

func _on_FireRate_timeout():
	canShoot = true

func checkRayCollision():
	var collider = ray.get_collider()
	if collider != null:
		if collider.is_in_group("enemy"):
			print("Shot Enemy")
		else:
			print("Missed")
	else:
		print("Missed")
