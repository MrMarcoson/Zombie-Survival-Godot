extends CanvasLayer


func _input(event):
	if event.is_action_pressed("BUTTON_E"):
		$Inventory.visible = !$Inventory.visible
		get_parent().update_GUI()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
