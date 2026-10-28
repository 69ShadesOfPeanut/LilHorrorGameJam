extends AnimatableBody3D

# Vars
# Nodes
@onready var AnimNode : AnimationPlayer = get_node("%DoorAnimationPlayer")
@onready var AudioStreamNode : AudioStreamPlayer3D = get_node("%DoorAudioStreamPlayer")

# Handles interactions
func Interact():
	AnimNode.play("Door")
	AudioStreamNode.play()
	queue_free()
