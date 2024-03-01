extends Area3D


@export var ammo_type := AmmoPouch.AmmoType.SMALL
@export var amount := 20


func pick_up(player: Player):
	player.add_ammo(ammo_type, amount)
	queue_free()


func _on_body_entered(body: Node3D) -> void: if body is Player: pick_up(body)
