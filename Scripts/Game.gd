# Main script on the main node of the game to control critical things...
extends Node3D

# Vars
# Nodes
@onready var IntroTextNode : CenterContainer = get_node("%IntroText")

func _ready() -> void:
	IntroTextNode.show()
	await get_tree().create_timer(3).timeout
	FadeOut()

# Fade out the intro text
func FadeOut() -> void:
	IntroTextNode.get_node("AnimationPlayer").play("FadeOut")
