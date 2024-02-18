extends CharacterBody3D


@export var aggro_range := 12.0
@export var attack_range := 1.5


@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var player: CharacterBody3D
var provoked := false


func _ready() -> void:
	player = get_tree().get_first_node_in_group('player')


func _process(delta: float) -> void:
	navigation_agent_3d.target_position = player.global_position

func _physics_process(delta: float) -> void:
	if not is_on_floor(): velocity.y -= gravity * delta
	
	check_aggro()
	if not provoked: return
	
	attack_sequence()
	
	apply_velocity()
	move_and_slide()


func check_aggro() -> void: provoked = provoked or global_position.distance_to(player.global_position) <= aggro_range

func attack_sequence() -> void: if global_position.distance_to(player.global_position) <= attack_range: animation_player.play("Attack")

func attak() -> void: print("Attack!")

func apply_velocity() -> void:
	var next_position = navigation_agent_3d.get_next_path_position()
	var direction := global_position.direction_to(next_position)
	
	if direction:
		look_at_target(direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func look_at_target(direction: Vector3) -> void:
	var adjusted_direction = direction
	adjusted_direction.y = 0
	look_at(global_position + adjusted_direction, Vector3.UP, true)
