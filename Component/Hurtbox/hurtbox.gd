extends Area2D
class_name Hurtbox

@export var character : Character

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var cool_down: Timer = $CoolDown

var current_area : Area2D

signal recieved_damage(damage : float, knockback_dir : Vector2)

func _apply_damage(hitbox : Hitbox) -> void:
	if hitbox:
		recieved_damage.emit(hitbox.damage * hitbox.damage_multiplier, hitbox.knockback_force * hitbox.knockback_direction)

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		current_area = area
		_apply_damage(area)
		if area.is_continuous:
			cool_down.start()
		character.is_damaged = true

func _on_area_exited(area: Area2D) -> void:
	if area == current_area:
		current_area = null
		cool_down.stop()
		character.is_damaged = false

func _on_cool_down_timeout() -> void:
	if current_area == null:
		return
	
	_apply_damage(current_area)
	if (current_area.is_continuous):
		cool_down.start()
