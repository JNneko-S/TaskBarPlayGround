extends State
class_name WizardWalk

@export var parent : Character
@export var anim_player : AnimationPlayer
@export var walk_timer : Timer

func Enter() -> void:
	walk_timer.wait_time = randf_range(1.0, 3.0)
	anim_player.play("Walk")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

func _on_walk_timer_timeout() -> void:
	StateTransitioned.emit(self, "Idle")
