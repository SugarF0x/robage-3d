extends Node3D


@export var enemy_scene: PackedScene


@onready var spawn_points = $SpawnPoints.get_children()
@onready var enemies = $Enemies


func _ready() -> void: spawn()


func spawn() -> void:
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_points.pick_random().global_position
	enemy.provoked = true
	enemy.death.connect(spawn)
	enemies.add_child(enemy)
