extends RigidBody2D

const SHOT_POWER: float = 5.0
const FORCE_POWER: float = 20.0
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
	

func get_damp_value():
	if get_point_vector().length() < FREE_MOVING_DISTANCE:
		return 0.0
	else:
		var damp_value: float
		damp_value = DAMP_POWER * (get_point_vector().length() - FREE_MOVING_DISTANCE)
		return damp_value

func get_velocity_relative_to_point():
	return linear_velocity.dot(get_point_vector())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Left Click"):
		linear_velocity = SHOT_POWER * get_shot_vector()

	constant_force = get_rebound_force()

	if get_velocity_relative_to_point() > 0:
		linear_damp = 0.0
	else:
		linear_damp = get_damp_value()
