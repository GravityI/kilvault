extends Spatial
const sensitivity = 1

var time = 1
var initialPos = Vector3(0.3, -0.22, 0)
var maxAmount = 1
var smooth = 0.2
var amount = Vector3()

onready var body = $"../.."
onready var stateMachine = $"../../../PlayerStateMachine"
	
func _process(delta):
	if body.aiming: initialPos = Vector3(0, -0.22, 0)
	if stateMachine.state == stateMachine.states.SPRINT: Vector3(0.3, -0.22, 0)
	if !(body.aiming or stateMachine.state == stateMachine.states.SPRINT): initialPos = Vector3(0.3, -0.22, 0)
	time = delta
	var final = amount + initialPos
	var position = translation
	translation = lerp(position, -amount + initialPos, time)
	
func _input(event):
	if event is InputEventMouseMotion:
		amount = event.relative * sensitivity * time
		amount = Vector3(clamp(amount.x, -maxAmount, maxAmount), clamp(amount.y, -maxAmount, maxAmount), 0)
