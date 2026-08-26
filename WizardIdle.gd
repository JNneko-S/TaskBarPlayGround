extends State
class_name WizardIdle

@export var parent : Character
@export var anim_player : AnimationPlayer
@export var idle_timer : Timer

func Enter() -> void:
	idle_timer.wait_time = randf_range(2.5, 8.0)
	idle_timer.start()
	anim_player.play("Idle")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass


func _on_idle_timer_timeout() -> void:
	StateTransitioned.emit(self, "Walk")
