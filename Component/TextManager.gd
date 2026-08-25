extends Node
class_name TextManager

#const MARUKIYA = preload("res://Assets/Fonts/marukiya.ttf")

#func display_number(value : int, position : Vector2):
	##var number = DamageText.new()
	#var setting = LabelSettings.new()
	#setting.font = MARUKIYA
	#setting.font_size = 24
	#setting.outline_size = 4
	#setting.outline_color = Color("000000")
	#number.global_position = position
	#number.text = str(value)
	#number.z_index = 1
	#number.label_settings = setting
	#call_deferred("add_child", number)
	#
	#await number.resized
	#number.pivot_offset = Vector2(number.size / 2)
	#
	#var tween : Tween = get_tree().create_tween()
	#tween.set_parallel(true)
	#tween.tween_property(number, "position:y", number.position.y - 24, 0.25).set_ease(Tween.EASE_OUT)
	#tween.tween_property(number, "position:y", number.position.y, 0.5).set_ease(Tween.EASE_IN)
	#tween.tween_property(number, "scale", Vector2.ZERO, 0.25).set_ease(Tween.EASE_IN).set_delay(0.5)
	#await tween.finished
	#number.queue_free()
	
