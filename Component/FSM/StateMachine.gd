extends Node
class_name StateMachine

@export var initial_state : State ##最初のステートを設定する

var current_state : State
var states : Dictionary

## true の間、通常のステート遷移（自発的なWalk⇔Idleなど）を無効化する。
## NPC同士の会話イベント中など、外部からステートを固定したいときに使う。
var locked : bool = false

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.StateTransitioned.connect(on_child_transition)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state : State, new_state_name) -> void:
	if locked:
		return
	if state != current_state:
		return
	_switch_to(new_state_name)

## 通常の遷移条件を無視して、外部から強制的にステートを切り替える。
## 例: NPCManager.force_state("idle")
func force_state(new_state_name : String) -> void:
	_switch_to(new_state_name)

func _switch_to(new_state_name : String) -> void:
	var new_state : State = states.get(new_state_name.to_lower())
	if new_state == null:
		return
	if current_state:
		current_state.Exit()
	new_state.Enter()
	current_state = new_state
