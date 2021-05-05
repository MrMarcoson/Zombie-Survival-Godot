extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _play_bass():
	$bass.play()
	print("1")
	yield($bass, "finished")

func _play_intro():
	$intro.play()
	print("2")
	yield($intro, "finished")


func _play_verse():
	yield(get_tree().create_timer(0.1), "timeout")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
