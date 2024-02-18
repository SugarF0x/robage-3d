extends Node3D


@export var fire_rate := 14.0


@onready var cooldown_timer: Timer = %CooldownTimer


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not Input.is_action_pressed("fire"): return
	if not cooldown_timer.is_stopped(): return
	
	cooldown_timer.start(1.0 / fire_rate)
	print("weapon fired")
