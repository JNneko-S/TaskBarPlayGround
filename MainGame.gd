extends Node2D
class_name MainGame

@onready var static_body_2d: StaticBody2D = $StaticBody2D

var dragging : bool = false
var last_mouse_pos : Vector2i = Vector2i.ZERO

func _ready() -> void:
	get_window().transparent_bg = true

func _on_static_body_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		dragging = true
		last_mouse_pos = DisplayServer.mouse_get_position()

func _process(_delta) -> void:
	if not dragging:
		return
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging = false
		return
	var current = DisplayServer.mouse_get_position()
	var delta = current - last_mouse_pos
	if delta != Vector2i.ZERO:
		get_window().position += delta
		last_mouse_pos = current
