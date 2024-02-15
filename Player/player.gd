extends CharacterBody3D


@export var jump_height := 1.0


@onready var camera_pivot: Node3D = %CameraPivot


const SPEED := 5.0
const MOUSE_SENSITIVITY := .003

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion := Vector2.ZERO


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	handle_camera_rotation()
	handle_fall(delta)
	handle_jump()
	handle_movement()

	move_and_slide()

func _input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	
	if event.is_action("ui_cancel"): Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if not event is InputEventMouseMotion: return
	mouse_motion = -event.relative * MOUSE_SENSITIVITY


func handle_camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	
	camera_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(camera_pivot.rotation_degrees.x, -90, 90)
	
	mouse_motion = Vector2.ZERO

func handle_fall(delta: float) -> void: if not is_on_floor(): velocity.y -= gravity * delta
func handle_jump() -> void: if Input.is_action_just_pressed("jump") and is_on_floor(): velocity.y = sqrt(jump_height * 2.0 * gravity)

func handle_movement() -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
