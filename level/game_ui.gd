extends Control

var score: int = 1000
var combo_count: int = 0

func _ready():
	Signals.IncrementScore.connect(IncrementScore)
	Signals.IncermentCombo.connect(IncrementCombo)
	Signals.RestCombo.connect(RestCombo)
	
func IncrementScore(incr: int):
	score += incr
	%ScoreLable.text = " " + str(score) + "pts"

func IncrementCombo():
	combo_count += 1
	%ComboLable.text = " " + str(combo_count) + "x combo"
	
	
func RestCombo():
	combo_count = 0
	%ComboLable.text = ""
