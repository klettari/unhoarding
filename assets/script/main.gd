extends Node2D

func _ready():
	get_tree().change_scene( Global.levelsMap[Global.level] )
