extends Control

var player
var gun_price = 1
var mg_price = 1
var sn_price = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent().get_node("Player")
	$gun_dmg.text = "DMG: " + String(player.get_node("Weapon").damage_gun)
	$mg_dmg.text = "DMG: " + String(player.get_node("Weapon").damage_mg)
	$sn_dmg.text = "DMG: " + String(player.get_node("Weapon").damage_sn)


func _on_gun_up_pressed():
	if(player.cash >= gun_price):
		player.cash -= gun_price
		player.get_node("Weapon").damage_gun += 1
		$gun_dmg.text = "DMG: " + String(player.get_node("Weapon").damage_gun)
		gun_price += 2
		$gun_price.text = String(gun_price) + "$"
		$cash.text = String(player.cash) + "$"

func _on_mg_up_pressed():
	if(player.cash >= mg_price):
		player.cash -= mg_price
		player.get_node("Weapon").damage_mg += 1
		$mg_dmg.text = "DMG: " + String(player.get_node("Weapon").damage_mg)
		mg_price += 2
		$mg_price.text = String(mg_price) + "$"
		$cash.text = String(player.cash) + "$"


func _on_sn_up_pressed():
	if(player.cash >= sn_price):
		player.cash -= sn_price
		player.get_node("Weapon").damage_sn += 1
		$sn_dmg.text = "DMG: " + String(player.get_node("Weapon").damage_sn)
		sn_price += 2
		$sn_price.text = String(sn_price) + "$"
		$cash.text = String(player.cash) + "$"
