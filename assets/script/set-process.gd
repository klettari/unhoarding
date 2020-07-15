extends Node2D

func _ready():
	$level1.set_process(false)
	$level2.set_process(false)

func _unhandled_key_input(event : InputEventKey) -> void:
	if event.pressed:
		match event.scancode:
			KEY_1:
				$level2.set_process(false)
				$level2.visible = false
				$level1.set_process(true)
				$level1.visible = true
			KEY_2:
				$level1.set_process(false)
				$level1.visible = false
				$level2.set_process(true)
				$level2.visible = true
