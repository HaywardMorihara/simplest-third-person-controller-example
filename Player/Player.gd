extends KinematicBody

export var speed = 10.0

export var camera_rotation_sensitivity = 0.01


func _ready():
	# Makes your mouse disappear from the screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	var input_direction = Vector3()
	input_direction.x = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	input_direction.z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	input_direction = input_direction.normalized()
	
	var movement_direction = Vector3()
	if input_direction != Vector3.ZERO:
		# The direction of movement will be the input direction rotated in the direction of the camera
		movement_direction = input_direction.rotated(Vector3.UP, $CameraYaw.rotation.y)
		# Rotate the model so that it's facing the direction of movement 
		$ModelPivot.look_at(self.translation - movement_direction, Vector3.UP)

	var velocity = Vector3()
	velocity.x = movement_direction.x * speed
	velocity.z = movement_direction.z * speed
	
	move_and_slide(velocity, Vector3.UP)


func _input(event):
	if event is InputEventMouseMotion:
		var camera_rotation = event.relative * camera_rotation_sensitivity
		# "yaw" is the term for side-to-side turning of the camera (around a vertical axis)
		$CameraYaw.rotate(Vector3.DOWN, camera_rotation.x)
		# "pitch" is the term for up-and-down movement of the camera (around a horizontal axis)
		$CameraYaw/CameraPitch.rotate(Vector3.RIGHT, camera_rotation.y)
	
	if event is InputEventKey and event.is_pressed() and event.is_action("quit_game"):
		get_tree().quit()
