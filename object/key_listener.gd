extends Sprite2D

@onready var falling_key = preload("res://object/falling_key.tscn")
@onready var score_text = preload("res://object/score_press_text.tscn")
@export var key_name: String = ""

var falling_key_queue = []

var perfect_press_threshold: float = 30
var great_press_threshold: float = 50
var good_press_threshold: float = 60
var ok_press_threshold: float = 80

var perfect_press_score: float = 250
var great_press_score: float = 100
var good_press_score: float = 50
var ok_press_score: float = 20
var miss_press_score: float = -100

func _ready():
	$GlowOveray.frame = frame + 4
	Signals.CreatFallingKey.connect(CreatFallingKey)

func _process(_delta):
	if Input.is_action_just_pressed(key_name):
		Signals.KeyListenerPress.emit(key_name, frame)

	if falling_key_queue.size() > 0:
		var front_key = falling_key_queue.front()

		# 삭제된 노드가 아닌 경우에만 접근
		if is_instance_valid(front_key) and front_key.has_passed:
			falling_key_queue.pop_front()

			var st_inst = score_text.instantiate()
			get_tree().get_root().call_deferred("add_child", st_inst)
			st_inst.SetTextInfo("Miss")
			st_inst.global_position = global_position + Vector2(0, -20)
			Signals.IncrementScore.emit(miss_press_score)
			Signals.RestCombo.emit()

		# 키가 눌렸을 때도 마찬가지로 유효한지 확인 후 처리
		if Input.is_action_just_pressed(key_name) and is_instance_valid(falling_key_queue.front()):
			var key_to_pop = falling_key_queue.pop_front()

			var distance_from_pass = abs(key_to_pop.pass_threshold - key_to_pop.global_position.y)

			$AnimationPlayer.stop()
			$AnimationPlayer.play("key_hit")

			var press_score_text: String = ""
			if distance_from_pass < perfect_press_threshold:
				Signals.IncrementScore.emit(perfect_press_score)
				press_score_text = "PERFECT!"
				Signals.IncermentCombo.emit()
			elif distance_from_pass < great_press_threshold:
				Signals.IncrementScore.emit(great_press_score)
				press_score_text = "Great"
				Signals.IncermentCombo.emit()
			elif distance_from_pass < good_press_threshold:
				Signals.IncrementScore.emit(good_press_score)
				press_score_text = "Good"
				Signals.IncermentCombo.emit()
			elif distance_from_pass < ok_press_threshold:
				Signals.IncrementScore.emit(ok_press_score)
				press_score_text = "Ok"
				Signals.IncermentCombo.emit()
			else:
				Signals.IncrementScore.emit(miss_press_score)
				press_score_text = "Miss"
				Signals.RestCombo.emit()

			key_to_pop.queue_free()

			var st_inst = score_text.instantiate()
			get_tree().get_root().call_deferred("add_child", st_inst)
			st_inst.SetTextInfo(press_score_text)
			st_inst.global_position = global_position + Vector2(0, -20)

func CreatFallingKey(button_name: String):
	if button_name == key_name:
		var fk_inst = falling_key.instantiate()
		get_tree().get_root().call_deferred("add_child", fk_inst)
		fk_inst.Setup(position.x, frame + 4)
		falling_key_queue.push_back(fk_inst)

func _on_random_spawn_timer_timeout():
	#CreatFallingKey()
	$RandomSpawnTimer.wait_time = randf_range(0.4, 3)
	$RandomSpawnTimer.start()
