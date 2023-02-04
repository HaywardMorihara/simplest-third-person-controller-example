extends KinematicBody

# TODO Optimize
# TODO Move Camera code

export var speed = 10.0
export var gravity : float = -9.8
export var mouse_camera_sensitivity = 0.01
export var controller_camera_sensitivity = 0.1
export var cam_max_v = 1.0
export var cam_min_v = -1.0
export var player_turn_smoothing = 0.5

var velocity = Vector3()
var camera_movement = Vector2()

func _ready():
	# Makes your mouse disappear from the screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	var input_direction = Vector3()
	input_direction.x = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	input_direction.z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	input_direction = input_direction.normalized()

	if Input.is_action_pressed("camera_right") or Input.is_action_pressed("camera_left") or Input.is_action_pressed("camera_down") or Input.is_action_pressed("camera_up"):
		camera_movement.x = (Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left")) * controller_camera_sensitivity
		camera_movement.y = (Input.get_action_strength("camera_down") - Input.get_action_strength("camera_up")) * controller_camera_sensitivity
	
	var movement_direction = Vector3()
	if input_direction != Vector3.ZERO:
		# The direction of movement will be the input direction rotated in the direction of the camera
		movement_direction = input_direction.rotated(Vector3.UP, $CameraYaw.rotation.y)
		# (angle() is calculated by comparing the +X (1, 0) and the point)
		# so z is x and x is y when converting 3D to 2D because it appears the Y-axis rotation in 3D is relative to the +Z axis
		# TODO Bug when turning towards the camera left to towards the camera right
		var new_rotation = Vector2(movement_direction.z, movement_direction.x).angle()
		$ModelPivot.rotation.y = lerp($ModelPivot.rotation.y, new_rotation, player_turn_smoothing)

	var velocity = Vector3()
	velocity.x = movement_direction.x * speed
	velocity.z = movement_direction.z * speed
	velocity.y += gravity * delta
	
	move_and_slide(velocity, Vector3.UP)
	
	# "yaw" is the term for side-to-side turning of the camera (around a vertical axis)
	$CameraYaw.rotate(Vector3.DOWN, camera_movement.x)
	# "pitch" is the term for up-and-down movement of the camera (around a horizontal axis)
	$CameraYaw/CameraPitch.rotation.x = clamp($CameraYaw/CameraPitch.rotation.x + camera_movement.y, cam_min_v, cam_max_v)
	camera_movement = Vector2.ZERO


func _input(event):
	if event is InputEventMouseMotion:
		camera_movement = event.relative * mouse_camera_sensitivity
	
	if event is InputEventKey and event.is_pressed() and event.is_action("quit_game"):
		get_tree().quit()
