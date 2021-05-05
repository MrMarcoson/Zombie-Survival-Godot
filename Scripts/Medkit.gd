extends Area2D

var state = "spawned"

func _on_Medkit_body_entered(body):
	if body.is_in_group("Player"):
		body.get_node("Weapon/Reload_sound").play()
		if(body.hp < 10):
			body.hp += 1
		queue_free()


func _on_Despawn_timeout():
	
	if(state == "spawned"):
		for i in 10:
			$Sprite.modulate = Color(1,1,1,0.5)
			yield(get_tree().create_timer(0.3), "timeout")
			$Sprite.modulate = Color(1,1,1,1)
			yield(get_tree().create_timer(0.3), "timeout")
	queue_free()
