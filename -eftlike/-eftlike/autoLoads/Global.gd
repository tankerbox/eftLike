extends Node

var player = null
var objective = null
var world = null
var money = 20
var GUI = null
var tileSet = null
var nests = []
var eventOn = false

func updateMoney(price):
	money += price
	GUI.label.text = "$:" + str(money)
