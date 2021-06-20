extends Spatial

onready var animation_player = get_node("AnimationPlayer")

func open():
	animation_player.play("open")
	
func close():
	animation_player.play("close")
