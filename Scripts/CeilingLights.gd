# Handles the ceiling lights
extends Node3D

# Vars
# Nodes
@onready var OnNode : Node3D = get_node("On")
@onready var OffNode : Node3D = get_node("Off")
@onready var AreaLight : AreaLight3D = get_node("AreaLight3D")
@onready var FlickingOffSoundNode : AudioStreamPlayer3D = get_node("FlickingOffSound")
@onready var HummingSoundNode : AudioStreamPlayer3D = get_node("AudioStreamPlayer3D")
# Export vars
@export var LightStatus : bool = true


# Handle if lights are on or off at start
func _ready() -> void:
	if LightStatus == false:
		ToggleLight()

# Toggle lights to alternative position
func ToggleLight():
	await get_tree().create_timer(randf_range(0.0, 1.0)).timeout
	FlickingOffSoundNode.play()
	
	HummingSoundNode.playing = !HummingSoundNode.playing
	OffNode.visible = !OffNode.visible
	OnNode.visible = !OnNode.visible
	AreaLight.visible = !AreaLight.visible
