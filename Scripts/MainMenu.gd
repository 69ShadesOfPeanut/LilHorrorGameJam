# Handles the main menu
extends Node3D



func PlayPressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")
