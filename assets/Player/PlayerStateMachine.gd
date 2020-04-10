extends StateMachine

enum states { IDLE, WALK, SPRINT }

onready var playerBody = $"../PlayerBody"

func _ready():
	call_deferred("set_state", states.IDLE)

func _state_logic(delta):
	match state:
		states.IDLE:
			pass
		states.WALK:
			pass
		states.SPRINT:
			pass

func _get_transition(delta):
	match state:
		states.IDLE:
			if playerBody.motion2d.x + playerBody.motion2d.y != 0 and playerBody.moveSpeed < 5:
				return states.WALK
			elif playerBody.motion2d.x + playerBody.motion2d.y != 0 and Input.is_action_pressed("sprint"):
				return states.SPRINT
		states.WALK:
			if playerBody.motion2d.x + playerBody.motion2d.y == 0:
				return states.IDLE
			elif Input.is_action_pressed("sprint"):
				return states.SPRINT
		states.SPRINT:
			if playerBody.motion2d.x + playerBody.motion2d.y == 0:
				return states.IDLE
			elif !Input.is_action_pressed("sprint"):
				return states.WALK
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.IDLE:
			pass
		states.WALK:
			pass
		states.SPRINT:
			playerBody.moveSpeed = 5

func _exit_state(old_state, new_state):
	match old_state:
		states.IDLE:
			pass
		states.WALK:
			pass
		states.SPRINT:
			pass
