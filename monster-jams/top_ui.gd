extends Control
class_name TopUI

var lblScoreAmt: Label
var lblTimeAmt: Label

func _ready() -> void:
	lblScoreAmt = $scoreParent/scoreAmt
	lblTimeAmt = $timeParent/timeAmt
	pass
	

func time_changed(newTime: int):
	if newTime == 0:
		lblTimeAmt.text = "12"
	else:
		lblTimeAmt.text = str(newTime)
	lblTimeAmt.text += " A.M."
	pass

func score_changed(newScore: int):
	lblScoreAmt.text = "$"+str(newScore)
	pass
