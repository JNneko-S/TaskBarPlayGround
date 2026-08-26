extends CharacterBody2D
class_name Character

@export var friction : float = .15 ##摩擦力または抵抗力

@export var jump_velocity : float = -600
@export var max_speed : float = 200 
@export var acceleration : int = 30 #加速度
@export var is_fly : bool = false

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var menu_bar: Control = $MenuBar
@onready var menu_button: Control = $MenuButton

@onready var talk_bar: Control = $TalkBar
@onready var talk_label: Label = $TalkBar/Panel/TalkLabel
@onready var talk_timer: Timer = $TalkTimer

@export var talk_texts : Array[String] = []

## NPC同士のすれ違い会話で、話しかけられた時に「返事するか」の確率。0.0〜1.0
## キャラごとに変えてよい（おしゃべりなキャラは高め、無口なキャラは低めなど）
@export_range(0.0, 1.0) var continue_chance : float = 0.0

var current_acceleration : int = 0
var move_direction : Vector2 = Vector2.ZERO #移動する方向

#向いているかの判定
var facing_dir : Vector2 = Vector2.RIGHT
var _last_line_index : int = -1

var outline_tween : Tween = null

func _ready() -> void:
	current_acceleration = acceleration
	talk_bar.visible = false
	menu_bar.visible = false

func _physics_process(delta: float) -> void:
	velocity.x = lerp(velocity.x, .0, friction)
	if not is_on_floor() and not is_fly:
		velocity += get_gravity() * delta
	move()
	move_and_slide()
	
	if velocity.x > 0 and animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = false
	elif velocity.x <= 0 and not animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = true
	#lerpは線形補間、移動速度を補間している

func move() -> void:
	move_direction = move_direction.normalized() #移動する方向を0~1(正規化)している
	velocity.x += move_direction.x * current_acceleration #動く方向にスピードをかけている
	
	#velocity = velocity.limit_length(max_speed) #最大速度の設定
	
	#なぜ正規化するのかというと移動速度の統一と方向の安定をさせなければいけないから
	#Player.gdにもmove()を使っている

#region signal
func _on_button_mouse_entered() -> void:
	if outline_tween != null and outline_tween.is_running():
		outline_tween.kill()
	if not talk_timer.is_stopped():
		return
	outline_tween = create_tween()
	#outline_tween.parallel()
	outline_tween.tween_property(animated_sprite_2d.material, "shader_parameter/thickness", 1.2, 0.2)
	outline_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)

func _on_button_mouse_exited() -> void:
	if outline_tween != null and outline_tween.is_running():
		outline_tween.kill()
	if not talk_timer.is_stopped():
		return
	outline_tween = create_tween()
	#outline_tween.parallel()
	outline_tween.tween_property(animated_sprite_2d.material, "shader_parameter/thickness", 0, 0.5)
	outline_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)

func _on_button_pressed() -> void:
	if not talk_timer.is_stopped():
		return
	menu_bar.visible = !menu_bar.visible

func _on_talk_pressed() -> void:
	talk_label.text = talk_texts.pick_random()
	talk_bar.visible = true
	menu_bar.visible = false
	talk_timer.start()

func _on_talk_timer_timeout() -> void:
	talk_label.text = ""
	talk_bar.visible = false
#endregion

#region npc_conversation
## talk_texts から、直前と同じセリフが連続しないように1つ選ぶ
func get_next_line() -> String:
	if talk_texts.is_empty():
		return ""
	if talk_texts.size() == 1:
		return talk_texts[0]
	var index := randi() % talk_texts.size()
	while index == _last_line_index:
		index = randi() % talk_texts.size()
	_last_line_index = index
	return talk_texts[index]

## NPCManagerからも、プレイヤーのTalkボタンからも、ここを通して吹き出しを出す
func show_bubble(text: String) -> void:
	talk_label.text = text
	talk_bar.visible = true
	talk_timer.start()
#endregion
