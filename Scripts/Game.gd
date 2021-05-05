extends Node2D


var x
var y
var song = 0
var prev_song = 0
var score = 0
var wave = 0
var wave_finished = true
var count_enemies = 0
var bullet_instance
var zombie_instance
var blood_instance
var drop_instance
onready var bullet = preload("res://Scenes/Bullet.tscn")
onready var zombie = preload("res://Scenes/Zombie.tscn")
onready var tank = preload("res://Scenes/Tank.tscn")
onready var blood = preload("res://Scenes/Blood.tscn")
onready var medkit = preload("res://Scenes/Medkit.tscn")
onready var mg_ammo = preload("res://Scenes/Mg_ammo.tscn")
onready var sn_ammo = preload("res://Scenes/Sn_ammo.tscn")


func _ready():
	$Player.connect("shoot", self, "create_bullet")
	$CanvasLayer/GUI.connect("begin", self, "start_wave")
	update_GUI()
	change_to_day()
	choose_song()
	
	
func update_GUI():
	$CanvasLayer/GUI/HP.text = "HP: " + String($Player.hp)
	$CanvasLayer/GUI/Score.text = "Score: " + String(score)
	$CanvasLayer/GUI/Wave.text = "Wave: " + String(wave)
	$CanvasLayer/GUI/Remaining.text = "Remaining: " + String(count_enemies)
	$CanvasLayer/Inventory/mg_num.text = String($Player.mg_ammo)
	$CanvasLayer/Inventory/sn_num.text = String($Player.sn_ammo)
	$CanvasLayer/Inventory/hp.text = String($Player.hp)
	$CanvasLayer/Inventory/cash.text = String($Player.cash) + "$"
	
	if($Player/Weapon.type == "rifle"):
		$CanvasLayer/GUI/Ammo.text = "inf"
	elif($Player/Weapon.type == "machine_gun"):
		$CanvasLayer/GUI/Ammo.text = String($Player.mg_ammo)
	else:
		$CanvasLayer/GUI/Ammo.text = String($Player.sn_ammo)


#start new wave, and change song
func start_wave():
	if(wave_finished == true):
		$CanvasLayer/GUI/Button.visible = false
		$CanvasLayer/GUI/Wave.visible = true
		$CanvasLayer/GUI/Remaining.visible = true
		change_to_night()
		create_wave()
		
		if(prev_song == 1):
			song = 2
		elif(prev_song == 2):
			song = 3
		elif(prev_song == 3):
			song = 4
		elif(prev_song == 4):
			song = 4
		else:
			song = 1
		
		
#spawning wave of enemies
func create_wave():
	wave_finished = false
	wave += 1
	
	#create zombie every second
	for i in wave*10:
		create_zombie("Zombie")
		update_GUI()
		yield(get_tree().create_timer(1), "timeout")
	
	for i in wave:
		create_zombie("Tank")
		update_GUI()
		yield(get_tree().create_timer(1), "timeout")


#end wave
func end_wave():
	wave_finished = true
	song = 0
	$Player.cash += 1
	change_to_day()
	$CanvasLayer/GUI/Button.visible = true
	$CanvasLayer/GUI/Wave.visible = false
	$CanvasLayer/GUI/Remaining.visible = false


#creating instance of bullet - calculating vector to target
func create_bullet(target):
	bullet_instance = bullet.instance()
	bullet_instance.connect("kill_zombie", self, "kill_zombie")
	bullet_instance.damage = $Player/Weapon.damage
	bullet_instance.type = $Player/Weapon.type
	bullet_instance.global_position = $Player/Weapon.global_position
	bullet_instance.direction = (target - bullet_instance.global_position).normalized()
	bullet_instance.look_at(target)
	update_GUI()
	add_child(bullet_instance)


#create instance of item droped in position of killed zombie
func create_drop(pos):
	#determine kind of drop
	var rand = randi()%10
	if(rand < 2):
		drop_instance = medkit.instance()
	elif(rand >= 2 && rand <= 7):
		drop_instance = mg_ammo.instance()
	else:
		drop_instance = sn_ammo.instance()
	
	drop_instance.position = pos
	add_child(drop_instance)


#spawning zombies depending on type
func create_zombie(type):
	if(type == "Zombie"):
		zombie_instance = zombie.instance()
	elif(type == "Tank"):
		zombie_instance = tank.instance()
	
	#picking position for spawn
	var rand = randi()%5
	if(rand == 0):
		x = rand_range(-310, 310)
		y = -310
	elif(rand == 1):
		x = -310
		y = rand_range(-310, 310)
	elif(rand == 2):
		x = 310
		y = rand_range(-310, 310)
	else:
		x = rand_range(-310, 310)
		y = 310
	zombie_instance.global_position = Vector2(x, y)
	
	zombie_instance.connect("hurt_player", self, "hurt_player")
	add_child(zombie_instance)
	count_enemies += 1


func kill_zombie(pos):
	score += 1
	count_enemies -= 1
	update_GUI()
	
	var rand = randi()%100
	if(rand < 25):
		create_drop(pos)
	
	if(count_enemies == 0):
		end_wave()
	

#decrement enemy count, check if player is hurt and hurt him
func hurt_player():
	if($Player.hurt == false):
		blood_instance = blood.instance()
		$Player.add_child(blood_instance)
		$Player.hurt_Player()
		$CanvasLayer/GUI/HP.text = "HP: " + String($Player.hp)
	
	if($Player.hp == 0):
		_end_game()
		

	
func _end_game():
	$CanvasLayer/GUI/Wave.text = "Game Over"
	$Player.kill_Player()
	get_tree().reload_current_scene() #tu bedzie end screen


func change_to_day():
	$Player/Weapon/Flashlight.enabled = false
	$Fade.play("Fade in")


func change_to_night():
	$Player/Weapon/Flashlight.enabled = true
	$Fade.play_backwards("Fade in")


#depending on situation play diffrent song, after finish play next one
func choose_song():
	if(song == 0):
		$Music_player/bass.play()
		yield($Music_player/bass, "finished")
	elif(song == 1):
		song = 2
		$Music_player/intro.play()
		yield($Music_player/intro, "finished")
	elif(song == 2):
		song = 3
		$Music_player/v1.play()
		yield($Music_player/v1, "finished")
	elif(song == 3):
		song = 4
		$Music_player/v2.play()
		yield($Music_player/v2, "finished")
	elif(song == 4):
		$Music_player/v3.play()
		yield($Music_player/v3, "finished")
	
	prev_song = song
	choose_song()


func _process(delta):
	if(count_enemies < 0):
		count_enemies = 0
		end_wave()
	
	update_GUI()


