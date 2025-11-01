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

func time_changed_interval(newTime: int):
	var hour: int = newTime/60
	var min: int = newTime
	if min > 59:
		min = newTime - (hour * 60)
		
	
	
	if hour == 0:
		lblTimeAmt.text = "12"
	else:
		lblTimeAmt.text = str(hour)
	if min < 10:
		lblTimeAmt.text += ":0"+str(min)
		pass
	else:
		lblTimeAmt.text += ":"+str(min)
	lblTimeAmt.text += " A.M."
	pass

func score_changed(newScore: int):
	lblScoreAmt.text = "$"+str(newScore)
	pass
