extends Area2D
class_name Hitbox

@export var damage : float = 0 : set = _set_damage , get = _get_damage
@export var knockback_force : float = 0 ##ノックバック力
@export var is_continuous : bool = false ##継続ダメージか
@export var damage_multiplier : float = 1.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var is_active : bool = true :
	set(value):
		is_active = value
		if collision_shape:
			collision_shape.disabled = not value

var knockback_direction : Vector2 = Vector2.ZERO
var is_body_inside : bool = false

func _set_damage(new_dmg : float) -> void:
	damage = new_dmg

func _get_damage() -> float:
	return damage
