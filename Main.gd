extends Spatial

enum Focus { CENTER, LEFT, RIGHT }

onready var left_panel = get_node("LeftPanel")
onready var right_panel = get_node("RightPanel")
onready var camera = get_node("Camera")
onready var tween = get_node("Tween")

var focus = Focus.CENTER

func _process(delta):
	if Input.is_action_just_pressed("focus_left_panel"):
		if focus == Focus.LEFT:
			tween.interpolate_property(camera, "rotation_degrees:y", null, 0.0, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
			left_panel.close()
			focus = Focus.CENTER
		else:
			tween.interpolate_property(camera, "rotation_degrees:y", null, 70.0, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
			left_panel.open()
			if focus == Focus.RIGHT:
				right_panel.close()
			focus = Focus.LEFT
		tween.start()
	if Input.is_action_just_pressed("focus_right_panel"):
		if focus == Focus.RIGHT:
			tween.interpolate_property(camera, "rotation_degrees:y", null, 0.0, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
			right_panel.close()
			focus = Focus.CENTER
		else:
			tween.interpolate_property(camera, "rotation_degrees:y", null, -70.0, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
			right_panel.open()
			if focus == Focus.LEFT:
				left_panel.close()
			focus = Focus.RIGHT
		tween.start()
