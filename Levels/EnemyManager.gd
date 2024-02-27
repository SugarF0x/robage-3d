extends Node3D


@export var enemy_scene: PackedScene


@onready var spawn_points = $SpawnPoints.get_children()
@onready var enemies = $Enemies


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_text_submit"): spawn()


func spawn() -> void:
	var enemy = enemy_scene.instantiate()
	enemies.add_child(enemy)
	enemy.global_position = spawn_points.pick_random().global_position
