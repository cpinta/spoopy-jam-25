class_name Order

# each slice has a bread stat. index 0 is the bottom slice
var breadStatsArray: Array[SliceStats] = []

const SCORE_PER_BREAD: int = 1
const SCORE_PER_TOPPING: int = 1

var scoreAmount: int = 0

func _init(breadStats: Array[SliceStats]):
	self.breadStatsArray = breadStats
	pass

static func generate_new(toppingChoices: Array[GM.Toppings], maxToppingsPerSlice: int = 1, maxSandwichSize: int = 2) -> Order:
	var order: Order = Order.new([])
	var sandwichSize: int = randi_range(1, maxSandwichSize)
	order.scoreAmount += SCORE_PER_BREAD * sandwichSize
	
	for i in range(0, maxSandwichSize):
		var toppingAmount: int = randi_range(1, maxToppingsPerSlice)
		var sliceStats: SliceStats = SliceStats.new(GM.BreadType.Wheat)
		order.scoreAmount += SCORE_PER_TOPPING * toppingAmount
		for j in range(0, toppingAmount):
			var topping: GM.Toppings = toppingChoices[randi_range(0, toppingChoices.size()-1)]
			sliceStats.add_topping_percent(topping, 1/toppingAmount)
			pass
		pass
		order.breadStatsArray.append(sliceStats)
	order.breadStatsArray.append(SliceStats.new(GM.BreadType.Wheat))
	return order

func does_sandwich_match_stats(bread: Bread3D) -> bool:
	var curSlice: Bread3D = bread
	var i = 0
	while curSlice:
		if i >= breadStatsArray.size():
			return false
		var curBreadStats: SliceStats = curSlice.get_bread_stats()
		if not curBreadStats.is_valid_stats(breadStatsArray[i]):
			return false
		curSlice = curSlice.breadOnTop
		i+=1
		pass
	return true
