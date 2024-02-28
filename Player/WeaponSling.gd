extends Node3D


@export var ammo_pouch: AmmoPouch


@onready var weapon_sling_label_container: HBoxContainer = %WeaponSlingLabelContainer


var weapon_index := 0:
	set(value):
		toggle_weapon_selection_state()
		weapon_index = wrapi(value, 0, get_children().size())
		toggle_weapon_selection_state()
		update_weapon_sling_labels()
		update_pouch_ammo_type()


func _ready():
	toggle_weapon_selection_state()
	update_weapon_sling_labels()
	update_pouch_ammo_type()

func _input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	
	if Input.is_action_just_pressed("scroll_up") and event.is_pressed(): weapon_index += 1
	if Input.is_action_just_pressed("scroll_down") and event.is_pressed(): weapon_index -= 1


func toggle_weapon_selection_state() -> void:
	var weapon_node = get_children()[weapon_index] as Node3D
	if not weapon_node: return
	
	weapon_node.visible = !weapon_node.visible
	weapon_node.process_mode = Node.PROCESS_MODE_INHERIT if weapon_node.process_mode == Node.PROCESS_MODE_DISABLED else Node.PROCESS_MODE_DISABLED

func update_weapon_sling_labels() -> void:
	for label in weapon_sling_label_container.get_children():
		weapon_sling_label_container.remove_child(label)
		label.queue_free()
	
	var weapons = get_children()
	for index in range(weapons.size()):
		var weapon = weapons[index]
		var label = Label.new()
		weapon_sling_label_container.add_child(label)
		
		label.name = weapon.name + "SlingLabel"
		label.text = weapon.name
		if weapon_index != index: label.modulate.a = .5

func update_pouch_ammo_type() -> void: ammo_pouch.active_ammo_type = get_children()[weapon_index].ammo_type
