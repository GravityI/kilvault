extends StateMachine

enum states {PATROL, SEARCH}
var target

onready var enemyBody = $".."
onready var player = $"../../Player/PlayerBody"
var spaceState

func _ready():
	call_deferred("set_state", states.SEARCH)
	spaceState = $"..".get_world().direct_space_state

func _state_logic(delta):
	match state:
		states.PATROL:
			pass
		states.SEARCH:
			if target:
				var result = spaceState.intersect_ray($"..".global_transform.origin, target.global_transform.origin)
				if result.size() > 0:
					if result.collider.is_in_group("player"):
						$"..".look_at(Vector3(target.global_transform.origin.x, 0.5 , target.global_transform.origin.z), Vector3.UP)
						$"..".move_and_slide((target.global_transform.origin - $"..".global_transform.origin).normalized() * 1, Vector3.UP)
func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass

func _on_detectionRadius_body_entered(body):
	if body.is_in_group("player"):
		target = body


func _on_detectionRadius_body_exited(body):
	if body.is_in_group("player"):
		target = null
