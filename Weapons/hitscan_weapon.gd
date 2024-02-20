extends Node3D


@export var fire_rate := 14.0
@export var recoil := .05
@export var weapon_mesh: Node3D


@onready var cooldown_timer: Timer = %CooldownTimer


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not Input.is_action_pressed("fire"): return
	if not cooldown_timer.is_stopped(): return
	
	shoot()


func shoot() -> void:
	print("weapon fired")
	
	var fire_duration = 1.0 / fire_rate
	cooldown_timer.start(fire_duration)
	
	var recoil_tween = create_tween()
	recoil_tween.set_trans(Tween.TRANS_CUBIC)
	recoil_tween.tween_property(weapon_mesh, "position", Vector3(weapon_mesh.position.x, weapon_mesh.position.y, weapon_mesh.position.z + recoil), fire_duration / 2)
	recoil_tween.tween_property(weapon_mesh, "position", weapon_mesh.position, fire_duration / 2)
