extends Sprite

var damage
var damage_gun = 5
var damage_mg = 2
var damage_sn = 10
var target
var type

func _ready():
	changeToRifle()

func get_input():
	if(Input.is_action_just_pressed("BUTTON_1")):
		changeToRifle()
	elif(Input.is_action_just_pressed("BUTTON_2")):
		changeToMachineGun()
	elif(Input.is_action_just_pressed("BUTTON_3")):
		changeToSniper()

func changeToRifle():
	type = "rifle"
	damage = damage_gun
	$Reload.wait_time = 0.5
	$Reload_sound.play()
	get_parent().get_parent().get_node("CanvasLayer/GUI/Ammo").text = "inf"

func changeToMachineGun():
	type = "machine_gun"
	damage = damage_mg
	$Reload.wait_time = 0.1
	$Reload_sound.play()
	get_parent().get_parent().get_node("CanvasLayer/GUI/Ammo").text = String(get_parent().mg_ammo)
		
func changeToSniper():
	type = "sniper"
	damage = damage_sn
	$Reload.wait_time = 1
	$Reload_sound.play()
	get_parent().get_parent().get_node("CanvasLayer/GUI/Ammo").text = String(get_parent().sn_ammo)

func _process(delta):
	get_input()
	target = get_global_mouse_position()
	look_at(target)
	if(target.x < global_position.x):
		flip_v = true
	else:
		flip_v = false
