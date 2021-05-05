extends Area2D


func _on_Mg_ammo_body_entered(body):
	if body.is_in_group("Player"):
		body.get_node("Weapon/Reload_sound").play()
		body.mg_ammo += 25
		if(body.mg_ammo > 999):
			body.mg_ammo = 999
		queue_free()


#modulate visibility and despawn
func _on_Despawn_timeout():
	for i in 10:
		$Sprite.modulate = Color(1,1,1,0.5)
		yield(get_tree().create_timer(0.3), "timeout")
		$Sprite.modulate = Color(1,1,1,1)
		yield(get_tree().create_timer(0.3), "timeout")
	queue_free()
