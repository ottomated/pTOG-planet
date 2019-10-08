extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var linear_velocity = Vector3()
var cam_rot = Vector2()
var rot_helper;
var dir;
var vel = Vector3();
var camera;

# Called when the node enters the scene tree for the first time.
func _ready():
	rot_helper = $Rotation_Helper;
	camera = $Rotation_Helper/Camera;
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	dir = Vector3()
	var cam_xform = camera.get_global_transform()
	var input_movement_vector = Vector2()
	if (Input.is_action_pressed("move_forward")):
		input_movement_vector.y += 1
	if Input.is_action_pressed("move_back"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("move_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_movement_vector.x += 1
	input_movement_vector = input_movement_vector.normalized()
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
		
	dir.y = 0
	
	dir = dir.normalized()
	
	vel.y += delta * -24.8
	var hvel = vel
	hvel.y = 0
	var target = dir
	target *= 20
	
	var accel
	if dir.dot(hvel) > 0:
		accel = 4.5
	else:
		accel = 16
	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	
	vel = move_and_slide(vel, Vector3.UP, 0.05, 4, deg2rad(40))

func _input(event):
	if event is InputEventMouseMotion:
		rot_helper.rotate_x(event.relative.y * -0.005);
		rotate_y(event.relative.x * -0.005);
		print(event.relative.x)
		var camera_rot = rot_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rot_helper.rotation_degrees = camera_rot