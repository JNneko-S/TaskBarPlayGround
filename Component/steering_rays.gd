extends Node2D
class_name SteeringRay

@export var num_rays : int = 8

var ray_directions : Array = []
var interest : Array[float] = []
var danger : Array[float] = []

func _ready() -> void:
	interest.resize(num_rays)
	danger.resize(num_rays)
	for i in num_rays:
		var angle = deg_to_rad(360 / num_rays * i)
		var raycast2d : RayCast2D = RayCast2D.new()
		self.add_child(raycast2d)
		raycast2d.target_position = Vector2.RIGHT.rotated(angle)
		ray_directions.append(raycast2d)
		
		#見やすさ重視
		raycast2d.scale = Vector2(10,10)
		raycast2d.target_position *= 20

func _calc_intrest(dir : Vector2) -> void:
	for i in num_rays:
		var d : float = ray_directions[i].target_position.dot(dir)
		interest[i] = max(0, d)

func _calc_danger() -> void:
	for i in num_rays:
		var ray : RayCast2D = ray_directions[i]
		if ray.is_colliding():
			danger[i] = 1.0
		else:
			danger[i] = 0.0

func _choose_dir() -> Vector2:
	var move_direction : Vector2
	for i in num_rays:
		if danger[i] > 0.0:
			interest[i] = 0.0
	move_direction = Vector2.ZERO
	for i in num_rays:
		move_direction += ray_directions[i].target_position * interest[i]
	move_direction = move_direction.normalized()
	
	return move_direction

#dirは正規化しないといけない
func convert_steering(dir : Vector2) -> Vector2:
	_calc_intrest(dir)
	_calc_danger()
	
	return _choose_dir()
