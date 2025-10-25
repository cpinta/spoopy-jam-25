class_name Order

# each slice has a bread stat. index 0 is the bottom slice
var breadStatsArray: Array[BreadStats] = []

func _init(breadStats: Array[BreadStats]):
	self.breadStatsArray = breadStats
	pass

func does_sandwich_match_stats(bread: Bread3D) -> bool:
	var curSlice: Bread3D = bread
	var i = 0
	while curSlice:
		if i >= breadStatsArray.size():
			return false
		var curBreadStats: BreadStats = curSlice.get_bread_stats()
		if not curBreadStats.is_valid_stats(breadStatsArray[i]):
			return false
		i+=1
		pass
	return true
