extends Node
class_name HitStopManager

#const FLASH = preload("res://Scenes/OtherScene/Flash.tscn")

var is_hit_stop : bool = false

func hit_stop_short() -> void:
	is_hit_stop = true
	Engine.time_scale = 0.0
	await get_tree().create_timer(0.2, true, false, true).timeout
	Engine.time_scale = 1.0
	is_hit_stop = false

func hit_stop_long() -> void:
	is_hit_stop = true
	#var flash = FLASH.instantiate()
	Engine.time_scale = 0.0
	#get_tree().current_scene.add_child(flash)
	await get_tree().create_timer(0.55, true, false, true).timeout
	#flash.queue_free()
	Engine.time_scale = 1.0
	is_hit_stop = false
