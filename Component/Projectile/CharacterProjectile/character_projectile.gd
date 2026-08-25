extends CharacterBody2D
class_name CharaProjectile

@export var speed : float = 200
@export var direction : Vector2 = Vector2.UP
@export var fire_angle : float = 30 :
	set(value):
		velocity = speed * direction.rotated(deg_to_rad(value))
@export var is_gravity : bool = false

@onready var sprite: AnimatedSprite2D = $VisualRoot/AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hitbox: Hitbox = $Hitbox

func _ready() -> void:
	velocity = speed * direction.rotated(deg_to_rad(fire_angle))

func _physics_process(delta: float) -> void:
	#position += speed * direction * delta
	if is_gravity:
		var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")
		velocity.y += gravity_value * delta
		
	sprite.rotation = direction.angle()
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()

#func parry_reflect(weapon : Weapon) -> void:
	#hitbox.set_collision_layer_value(3, false) #layer Enemy off
	#hitbox.set_collision_layer_value(2, true) #layer Player on
	#hitbox.set_collision_layer_value(5, true) #layer Reflect on
	#hitbox.set_collision_mask_value(2, false)
	#hitbox.set_collision_mask_value(3, true)
	#direction = Vector2( -direction.x, -direction.y )
	###direction = direction * weapon.angle * 1.2
	#if weapon.angle > 0.5:
		#direction = direction * weapon.angle
	#else:
		#direction = direction 

func destory() -> void:
	speed = 0
	queue_free()

func _on_timer_timeout() -> void:
	destory()
