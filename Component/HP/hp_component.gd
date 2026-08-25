extends Node2D
class_name HPComponent

@export var max_hp : float = 100
@export var hp : float = 100 : set = _set_hp #setterは変数を使うときに呼び出される関数

signal hp_changed #hpが変わったときに呼び出される
signal is_dead #自身が死んだ時に呼び出される

var is_death_warning : bool = false

func _set_hp(new_hp : float) -> void:
	if hp == 0:
		return
	hp = clamp(new_hp, 0, max_hp) #hpの最大値、最小値を決めている
	hp_changed.emit()
	if hp <= 0:
		is_dead.emit()

func restore_hp() -> void:
	hp = max_hp #初期化用の関数
