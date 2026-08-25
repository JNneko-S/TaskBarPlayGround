extends State
class_name TesterIdle

@export var parent : Tester
@export var anim_player : AnimationPlayer
@export var idle_timer : Timer

func Enter() -> void:
	anim_player.play("Idle")
	idle_timer.start()

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	pass

func _on_idle_timer_timeout() -> void:
	StateTransitioned.emit(self, "Walk")
