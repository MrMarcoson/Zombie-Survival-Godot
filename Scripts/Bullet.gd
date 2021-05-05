extends Area2D

var speed = 300
var damage = 5
var type
var direction = Vector2()

signal kill_zombie(pos)

func _process(delta):
	position += direction * speed * delta


#determine collision, free if wall, minus hp if zombie
func _on_Bullet_body_entered(body):
	if body.is_in_group("Enemy"):
		if(body.hp - damage > 1):
			body.hurt_zombie(damage)
		else:
			emit_signal("kill_zombie", body.position)
			body.kill_zombie()
	
	if (!body.is_in_group("Player")) && (type != "sniper" || body.is_in_group("Wall")):
		queue_free()

