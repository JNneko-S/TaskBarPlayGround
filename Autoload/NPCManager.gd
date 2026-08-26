extends Node

## Autoload登録して使う（Project Settings > Autoload）。
## 各NPCは _ready() で NPCManager.register(self) を呼ぶこと。
##
## NPC(Character.gd)側に必要なもの:
##   - state_machine : StateMachine
##   - facing_dir : Vector2
##   - talk_texts : Array[String]          … キャラごとに違うセリフをInspectorで設定
##   - continue_chance : float (0.0〜1.0)  … 話しかけられた時に返事する確率（キャラごとに違ってよい）
##   - func get_next_line() -> String
##   - func show_bubble(text: String) -> void

const CHECK_INTERVAL := 0.5
const TALK_RANGE := 60.0
const FACING_DOT_THRESHOLD := 0.5
const COOLDOWN_MIN_MS := 15000
const COOLDOWN_MAX_MS := 25000
const LINE_DURATION := 1.8      # 1セリフの表示時間
const MAX_TURNS := 6            # 暴走防止の上限ターン数

var npcs: Array[Character] = []
var pair_cooldown: Dictionary = {}


func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = CHECK_INTERVAL
	timer.autostart = true
	timer.timeout.connect(_check_pairs)
	add_child(timer)


func register(npc: Character) -> void:
	if not npcs.has(npc):
		npcs.append(npc)


func unregister(npc: Character) -> void:
	npcs.erase(npc)
	for key in pair_cooldown.keys():
		if key.begins_with(str(npc.get_instance_id())) or key.ends_with(str(npc.get_instance_id())):
			pair_cooldown.erase(key)


func _check_pairs() -> void:
	for i in npcs.size():
		var a: Character = npcs[i]
		if not is_instance_valid(a):
			continue
		for j in range(i + 1, npcs.size()):
			var b: Character = npcs[j]
			if not is_instance_valid(b):
				continue
			if not _both_available(a, b):
				continue
			if _is_facing_and_close(a, b):
				_start_conversation(a, b)


func _pair_key(a: Character, b: Character) -> String:
	var id_a := a.get_instance_id()
	var id_b := b.get_instance_id()
	return str(min(id_a, id_b)) + "-" + str(max(id_a, id_b))


func _both_available(a: Character, b: Character) -> bool:
	var key := _pair_key(a, b)
	if pair_cooldown.has(key) and Time.get_ticks_msec() < pair_cooldown[key]:
		return false
	if a.state_machine.locked or b.state_machine.locked:
		return false
	return true


func _is_facing_and_close(a: Character, b: Character) -> bool:
	if a.global_position.distance_to(b.global_position) > TALK_RANGE:
		return false
	var to_b := (b.global_position - a.global_position).normalized()
	var to_a := -to_b
	var a_facing := a.facing_dir.normalized().dot(to_b)
	var b_facing := b.facing_dir.normalized().dot(to_a)
	return a_facing > FACING_DOT_THRESHOLD and b_facing > FACING_DOT_THRESHOLD


func _start_conversation(a: Character, b: Character) -> void:
	var key := _pair_key(a, b)
	pair_cooldown[key] = Time.get_ticks_msec() + randi_range(COOLDOWN_MIN_MS, COOLDOWN_MAX_MS)

	a.state_machine.locked = true
	b.state_machine.locked = true
	a.state_machine.force_state("idle")
	b.state_machine.force_state("idle")

	await _run_conversation(a, b)

	if is_instance_valid(a):
		a.state_machine.locked = false
	if is_instance_valid(b):
		b.state_machine.locked = false


## 話す側→聞く側、のターンを繰り返す。
## 「続けるかどうか」は毎回、聞いていた側が自分の continue_chance で判断する。
## これにより両キャラの継続判断が独立して管理される。
func _run_conversation(a: Character, b: Character) -> void:
	var speaker := a
	var listener := b
	if randf() < 0.5:
		speaker = b
		listener = a

	for turn in range(MAX_TURNS):
		if not is_instance_valid(speaker) or not is_instance_valid(listener):
			return

		speaker.show_bubble(speaker.get_next_line())
		await get_tree().create_timer(LINE_DURATION).timeout

		# 聞いていた側が、自分自身の確率で「返事するか」を判断する
		if randf() >= listener.continue_chance:
			return  # 返事しない＝会話終了

		# 役割交代（聞いていた側が次の話し手になる）
		var next_speaker := listener
		var next_listener := speaker
		speaker = next_speaker
		listener = next_listener
