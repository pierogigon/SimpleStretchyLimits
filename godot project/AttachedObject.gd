extends RigidBody2D

#adjustabe constants
const SHOT_POWER: float = 5.0
const FORCE_POWER: float = 20.0
const DAMP_POWER: float = 0.16
const FREE_MOVING_DISTANCE: float = 300.0

#gets the vector between the mouse and the attached object.
func get_shot_vector():
	return get_viewport().get_mouse_position() - global_position

#gets the vector between the attachment point and the attached object.
func get_point_vector():
	return %AttachmentPoint.global_position - global_position

#replaces its value with Vector2(0,0) if the attached object is inside the boundary.
#replaces its value with a vector that points towards the attachment point and strengthens with extra attached object distance outside the boundary.
func get_rebound_force():
	if get_point_vector().length() < FREE_MOVING_DISTANCE:
		return Vector2.ZERO
	else:
		var force_magnitude: float
		force_magnitude = FORCE_POWER * (get_point_vector().length() - FREE_MOVING_DISTANCE)
		var force_direction: Vector2
		force_direction = get_point_vector().normalized()
		return force_magnitude * force_direction
	

#replaces its value with 0.0 if the attached object is inside the boundary
#replaces its value with a number that increases with extra attached object distance outside the boundary.
func get_damp_value():
	if get_point_vector().length() < FREE_MOVING_DISTANCE:
		return 0.0
	else:
		var damp_value: float
		damp_value = DAMP_POWER * (get_point_vector().length() - FREE_MOVING_DISTANCE)
		return damp_value

#gets the velocity relative to the vector pointing from the attached object to the attachment point.
func get_velocity_relative_to_point():
	return linear_velocity.dot(get_point_vector())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if     you just pressed       (left mouse button)
	if Input.is_action_just_pressed("Left Click"):
		#set linear velocity towards the mouse at a speed of SHOT_POWER
		linear_velocity = SHOT_POWER * get_shot_vector()

	#sets the constant constant force continuously
	constant_force = get_rebound_force()

	#if the object is moving towards the attachment point:
	if get_velocity_relative_to_point() > 0:
		#set the linear damp to 0
		linear_damp = 0.0
	else: #if the objecct is moving away from the attachment point:
		linear_damp = get_damp_value()
		#set the linear damp continuously
