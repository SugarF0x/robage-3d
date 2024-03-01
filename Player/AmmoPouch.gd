class_name AmmoPouch
extends Node


@onready var weapon_ammo_label: Label = %WeaponAmmoLabel


enum AmmoType {
	SMALL,
	LARGE
}


var ammo_storage := {
	AmmoType.SMALL: 60,
	AmmoType.LARGE: 10
}


var active_ammo_type: AmmoType:
	set(value):
		active_ammo_type = value
		update_ammo_label()


func _ready():
	update_ammo_label()


func use_ammo(type: AmmoType) -> bool:
	if ammo_storage[type] <= 0: return false
	ammo_storage[type] -= 1
	update_ammo_label()
	return true

func add(type: AmmoType, amount: int) -> void: 
	ammo_storage[type] += amount
	update_ammo_label()

func update_ammo_label() -> void:
	if not active_ammo_type is AmmoType or not weapon_ammo_label: return
	weapon_ammo_label.text = str(ammo_storage[active_ammo_type])
