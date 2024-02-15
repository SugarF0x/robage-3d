extends Camera3D


@export_range(30.0, 90.0) var speed := 44.0


@onready var camera_pivot: Node3D = %CameraPivot


func _physics_process(delta: float) -> void:
	var weight = clamp(delta * speed, 0, 1)
	global_transform = global_transform.interpolate_with(camera_pivot.global_transform, weight)
	global_position = camera_pivot.global_position
