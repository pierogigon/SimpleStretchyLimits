extends RigidBody2D

const SHOT_POWER: float = 2.0
const FORCE_POWER: float = 10.0
const DAMP_POWER: float = 0.16

const FREE_MOVING_DISTANCE: float = 300.0

func get_shot_vector():
	return get_viewport().get_mouse_position() - global_position

func get_point_vector():
	return %AttachmentPoint.global_position - global_position

func get_rebound_force():
	if get_point_vector().length() < FREE_MOVING_DISTANCE:
		return Vector2.ZERO
	else:
		var force_magnitude: float
		force_magnitude = FORCE_POWER * (get_point_vector().length() - FREE_MOVING_DISTANCE)
		var force_direction: Vector2
		force_direction = get_point_vector().normalized()
		return force_magnitude * force_direction
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Left Click"):
		linear_velocity = SHOT_POWER * get_shot_vector()

	constant_force = get_rebound_force()
