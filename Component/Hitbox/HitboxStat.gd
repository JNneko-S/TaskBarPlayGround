extends RefCounted
class_name HitboxStat

var damage : float
var knockback_force : float

static func new_stat(_damage : float, _knockback_force : float) -> HitboxStat:
	var hitbox_stat : HitboxStat = new()
	hitbox_stat.damage = _damage
	hitbox_stat.knockback_force = _knockback_force
	return hitbox_stat
