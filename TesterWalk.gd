extends State
class_name TesterWalk

@export var parent : Tester
@export var anim_player : AnimationPlayer
@export var wander_timer : Timer

var direction : Vector2

func Enter() -> void:
	anim_player.play("Walk")
	wander_timer.start()
	if randf() <= 0.5:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	parent.velocity += direction * parent.acceleration

func _on_walk_timer_timeout() -> void:
	StateTransitioned.emit(self, "Idle")
