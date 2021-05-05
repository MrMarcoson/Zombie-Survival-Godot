extends KinematicBody2D


onready var player = get_parent().get_node("Player")
onready var death_sound = $Death_sound
var direction
var colision
var on_wall = false
var speed = 30
var hp = 30

signal hurt_player

func _ready():
	$HP_bar.text = "HP: " + String(hp)

	
func hurt_zombie(damage):
	hp -= damage
	$HP_bar.text = "HP: " + String(hp)
	$Sprite.modulate = Color(10,10,10,10)
	yield(get_tree().create_timer(0.1), "timeout")
	$Sprite.modulate = Color(1,1,1,1)
	yield(get_tree().create_timer(0.1), "timeout")
	

func kill_zombie():
	$Hitbox.queue_free()
	$HP_bar.queue_free()
	$Sprite.visible = false
	death_sound.play()
	yield(death_sound, "finished")
	queue_free()
	

func change_Sprite():
	if(position.x > player.position.x):
		$Sprite.flip_h = true
		$Sprite/Eye.flip_h = true
	else:
		$Sprite.flip_h = false
		$Sprite/Eye.flip_h = false

		
#get position of player and move to him
func _process(delta):
	player = get_parent().get_node("Player")
	change_Sprite()
	direction = (player.position - position).normalized()
	colision = move_and_collide(direction * speed * delta)
	
	if(colision):		
		if(colision.collider.is_in_group("Player")):
			emit_signal("hurt_player")
		else:
			direction.slide(colision.normal)
	
	
