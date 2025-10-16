class_name Sandwich
extends Node

var bread: GM.BreadType
var toppings: Array[GM.Toppings]

func setup(bread: GM.BreadType, toppings: Array[GM.Toppings]):
	self.bread = bread
	self.toppings = toppings
	pass
