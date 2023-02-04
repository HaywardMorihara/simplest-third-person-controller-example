extends KinematicBody

export var speed = 10.0

export var camera_rotation_sensitivity = 0.01

var gravity : float = -9.8

var velocity : Vector3 = Vector3()


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _physics_process(delta):
	
	var input_direction = Vector3()
	input_direction.x = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	input_direction.z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	input_direction = input_direction.normalized()
	
	if input_direction != Vector3.ZERO:
		input_direction = input_direction.rotated(Vector3.UP, $CameraPitch.rotation.y)
		$Pivot.look_at(self.translation - input_direction, Vector3.UP)

	
	velocity = Vector3(
		input_direction.x * speed, 
		velocity.y + (gravity * delta), 
		input_direction.z * speed)
	move_and_slide(velocity, Vector3.UP)


func _input(event):
	# Called "yaw" (turning side-to-side) and pitch (vertical angle up-and-down)
	if event is InputEventMouseMotion:
		var camera_rotation = event.relative * camera_rotation_sensitivity
		$CameraPitch.rotate(Vector3.DOWN, camera_rotation.x)
		$CameraPitch/CameraYaw.rotate(Vector3.RIGHT, camera_rotation.y)
