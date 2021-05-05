extends KinematicBody2D

var direction = Vector2()
var speed = 50
var hp = 10
var mg_ammo = 100
var sn_ammo = 10
var target
var can_shoot = true
var hurt = false
var cash = 0

signal shoot(target)

func _process(delta):
	#changing state of sprite and movement
	get_input()
	move_and_slide(direction.normalized() * speed)
	change_Sprite()
	

func get_input():
	#horizontal movement
	if(Input.is_action_pressed("BUTTON_A")):
		direction.x = -1.0
	elif(Input.is_action_pressed("BUTTON_D")):
		direction.x = 1.0
	else:
		direction.x = 0
	
	#vertical movement
	if(Input.is_action_pressed("BUTTON_W")):
		direction.y = -1.0
	elif(Input.is_action_pressed("BUTTON_S")):
		direction.y = 1.0
	else:
		direction.y = 0
	
	#sending signal to battlefield, with position of mouse, and starting reloading
	if(Input.is_action_pressed("BUTTON_SPACE") && can_shoot == true):
		if($Weapon.type == "rifle"):
			shoot()
		elif($Weapon.type == "machine_gun" && mg_ammo != 0):
			mg_ammo -= 1
			shoot()
		elif($Weapon.type == "sniper" && sn_ammo != 0):
			sn_ammo -= 1
			shoot()
			
	

func shoot():
	target = get_global_mouse_position()
	can_shoot = false
	$Weapon/Reload.start()
	$Weapon/Gun_sound.play()
	emit_signal("shoot", target)
	

#flip sprite depending of position player is going
func change_Sprite():
	if(direction.x != 0 || direction.y != 0):
		$Sprite.animation = 'walk'
	else:
		$Sprite.animation = 'idle'
	
	if(get_global_mouse_position() < position):
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false


func hurt_Player():
	if(hurt == false):
		$Hurt_sound.play()
		hurt = true
		hp -= 1
		for i in 5:
			$Sprite.modulate = Color(10,10,10,10)
			yield(get_tree().create_timer(0.1), "timeout")
			$Sprite.modulate = Color(1,1,1,1)
			yield(get_tree().create_timer(0.1), "timeout")
		hurt = false
		
		
func kill_Player():
	queue_free()


func _on_Reload_timeout():
	can_shoot = true


#generate random chance of flashing flashlight, and start timer
func _on_Flashing_timeout():
	var random_f = randi()%5+1
	if(random_f == 5):
		flash_Flashlight()
	$Flashing.start()


#draw random number 10 times and turn off light for 0.2 seconds (visible off)
func flash_Flashlight():
	var on
	for i in 10:
		on = randi()%2
		if(on == 1):
			$Weapon/Flashlight.visible = false
		else:
			$Weapon/Flashlight.visible = true
			
		yield(get_tree().create_timer(0.2), "timeout")
		
	$Weapon/Flashlight.visible = true
