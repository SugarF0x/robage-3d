class_name Player
extends CharacterBody3D


#region Exports
@export_range(0.5, 2.0) var jump_height := 1.0
@export_range(1.0, 5.0) var fall_multiplier := 2.5
@export var max_health := 100
@export var zoom_multiplier := .7
#endregion

#region On ready
@onready var camera_pivot: Node3D = %CameraPivot
@onready var player_health_label: Label = %PlayerHealthLabel
@onready var damage_animation_player: AnimationPlayer = %DamageAnimationPlayer
@onready var game_over_menu: GameOverMenu = $CanvasLayer/GameOverMenu
@onready var ammo_pouch: AmmoPouch = %AmmoPouch

@onready var smooth_camera: Camera3D = %SmoothCamera
@onready var smooth_camera_fov := smooth_camera.fov
@onready var weapon_camera: Camera3D = %WeaponCamera
@onready var weapon_camera_fov := weapon_camera.fov
#endregion

#region Consts
const SPEED := 5.0
const MOUSE_SENSITIVITY := .003
#endregion

#region Variables
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion := Vector2.ZERO
#endregion

#region Smart variables
var health := max_health:
	set(value):
		if (value < health): 
			damage_animation_player.stop()
			damage_animation_player.play("TakeDamage")
			
		health = value
		update_health_label()
		if health <= 0: game_over_menu.game_over()
#endregion

#region Overrides
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	update_health_label()

func _process(delta: float) -> void:
	handle_zoom(delta)

func _physics_process(delta: float) -> void:
	handle_camera_rotation()
	handle_fall(delta)
	handle_jump()
	handle_movement()

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	
	if event is InputEventMouseMotion: mouse_motion = -event.relative * MOUSE_SENSITIVITY * zoom_multiplier if Input.is_action_pressed("aim") else -event.relative * MOUSE_SENSITIVITY
	if Input.is_action_just_pressed("restart"): get_tree().reload_current_scene()
#endregion

#region Own logic
func handle_camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	
	camera_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(camera_pivot.rotation_degrees.x, -90, 90)
	
	mouse_motion = Vector2.ZERO

func handle_fall(delta: float) -> void: 
	if is_on_floor(): return
	
	if velocity.y >= 0: velocity.y -= gravity * delta
	else: velocity.y -= gravity * delta * fall_multiplier

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
	
	if Input.is_action_pressed("aim"):
		velocity.x *= zoom_multiplier
		velocity.z *= zoom_multiplier

func update_health_label(): player_health_label.text = "Health: " + str(health)

func add_ammo(ammo_type: AmmoPouch.AmmoType, amount: int) -> void: ammo_pouch.add(ammo_type, amount)

func handle_zoom(delta: float) -> void:
	smooth_camera.fov = lerp(smooth_camera.fov, smooth_camera_fov * zoom_multiplier if Input.is_action_pressed("aim") else smooth_camera_fov, delta * 20)
	weapon_camera.fov = lerp(weapon_camera.fov, weapon_camera_fov * zoom_multiplier if Input.is_action_pressed("aim") else weapon_camera_fov, delta * 20)
#endregion
