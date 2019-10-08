extends KinematicBody

var dragging = false
var rot_x = 0
var rot_y = 0
var env
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	env = get_parent().get_node("WorldEnvironment")

func _process(delta):
	if Input.is_action_pressed("move_back"):
		env.environment = load("res://resources/space.tres")
		get_tree().change_scene_to(load("res://Surface.tscn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			get_node("Camera").fov -= 2
		if event.button_index == BUTTON_WHEEL_DOWN:
			get_node("Camera").fov += 2
		else:
			if event.is_pressed():
				dragging = true
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		rot_x += event.relative.x * 0.01;
		rot_y += event.relative.y * 0.01;
		transform.basis = Basis()
		rotate_object_local(Vector3(0, -1, 0), rot_x)
		rotate_object_local(Vector3(1, 0, 0), rot_y)