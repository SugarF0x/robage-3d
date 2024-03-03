extends Node3D


@export var fire_rate := 14.0
@export var recoil := .05
@export var damage := 15
@export var full_auto := true
@export var ammo_type := AmmoPouch.AmmoType.SMALL


@export var weapon_mesh: Node3D
@export var muzzle_flash_particles: GPUParticles3D
@export var hit_flash_particles: PackedScene
@export var ammo_pouch: AmmoPouch


@onready var cooldown_timer: Timer = %CooldownTimer
@onready var ray_cast_3d: RayCast3D = $RayCast3D


func _process(delta: float) -> void:
	if not Input.is_action_pressed("fire"): return
	if not cooldown_timer.is_stopped(): return
	
	if not full_auto:
		if Input.is_action_just_pressed("fire"): shoot()
	else:
		shoot()


func shoot() -> void:
	if not ammo_pouch.use_ammo(ammo_type): return
	
	var fire_duration = 1.0 / fire_rate
	cooldown_timer.start(fire_duration)
	
	var recoil_tween = create_tween()
	recoil_tween.set_trans(Tween.TRANS_CUBIC)
	recoil_tween.tween_property(weapon_mesh, "position", Vector3(weapon_mesh.position.x, weapon_mesh.position.y, weapon_mesh.position.z + recoil), fire_duration / 2)
	recoil_tween.tween_property(weapon_mesh, "position", weapon_mesh.position, fire_duration / 2)
	
	muzzle_flash_particles.restart()
	
	apply_damage(ray_cast_3d.get_collider(), ray_cast_3d.get_collision_point())

func apply_damage(target, hit_point: Vector3) -> void:
	if not ray_cast_3d.is_colliding(): return
	
	var hit_particles = hit_flash_particles.instantiate() as GPUParticles3D
	add_child(hit_particles)
	hit_particles.global_position = hit_point
	
	if target is Enemy: target.health -= damage
	
