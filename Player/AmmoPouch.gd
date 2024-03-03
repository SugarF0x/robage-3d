class_name AmmoPouch
extends Node


@onready var weapon_ammo_label: Label = %WeaponAmmoLabel
@onready var ammo_pouch_label_container: VBoxContainer = %AmmoPouchLabelContainer


enum AmmoType {
	SMALL,
	LARGE
}


const DEFAULT_LABEL_SETTINGS = preload("res://UI/default_label_settings.tres")
const AmmTypeLocaleMap := {
	AmmoType.SMALL: "Small rounds",
	AmmoType.LARGE: "Hi-cal rounds"
}


var ammo_storage := {
	AmmoType.SMALL: 0,
	AmmoType.LARGE: 0
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
	display_added_ammo_label(type, amount)

func update_ammo_label() -> void:
	if not active_ammo_type is AmmoType or not weapon_ammo_label: return
	weapon_ammo_label.text = str(ammo_storage[active_ammo_type])

func display_added_ammo_label(type: AmmoType, amount: int) -> void:
	var label = Label.new()
	label.label_settings = DEFAULT_LABEL_SETTINGS
	label.label_settings.font_size = 32
	label.name = "AddedAmmoLabel"
	label.text = AmmTypeLocaleMap[type] + " +" + str(amount)
	
	ammo_pouch_label_container.add_child(label)
	ammo_pouch_label_container.move_child(label, 0)
	
	var position_tween = create_tween()
	var opacity_tween = create_tween()
	position_tween.tween_property(label, "position", Vector2(label.position.x, label.position.y - 100), 2.0)
	opacity_tween.tween_property(label, "modulate:a", 0.0, 2.0)
	opacity_tween.tween_callback(label.queue_free)
