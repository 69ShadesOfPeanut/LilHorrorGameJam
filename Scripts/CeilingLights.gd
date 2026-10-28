# Handles the ceiling lights
extends Node3D

# Vars
# Nodes
@onready var OnNode : Node3D = get_node("On")
@onready var OffNode : Node3D = get_node("Off")
@onready var AreaLight : AreaLight3D = get_node("AreaLight3D")
@onready var FlickingOffSoundNode : AudioStreamPlayer3D = get_node("FlickingOffSound")
@onready var HummingSoundNode : AudioStreamPlayer3D = get_node("AudioStreamPlayer3D")
@onready var FlickerTimer: Timer = get_node("FlickerTimer")
# Export vars
@export var LightStatus : bool = true
@export var Flickering : bool = false
@export var MainMenu : bool = false


# Handle if lights are on or off at start
func _ready() -> void:
	if LightStatus == false:
		ToggleLight()
	if Flickering == true:
		FlickerLight()

# Toggle lights to alternative position
func ToggleLight():
	await get_tree().create_timer(randf_range(0.0, 1.0)).timeout
	FlickingOffSoundNode.play()
	
	HummingSoundNode.playing = !HummingSoundNode.playing
	OffNode.visible = !OffNode.visible
	OnNode.visible = !OnNode.visible
	AreaLight.visible = !AreaLight.visible

# Handles lights with flickering turned on
func FlickerLight() -> void:
	
	var i : int = 0
	while i < randi_range(2, 6):
		await get_tree().create_timer(randf_range(0.05, 0.8)).timeout
		OnNode.visible = !OnNode.visible
		OffNode.visible = !OffNode.visible
		AreaLight.visible = !AreaLight.visible
		i += 1
		
		# MAIN MENU ONLY
		if MainMenu == true and AreaLight.visible == false:
			if randi_range(0, 350) == 350:
				#print("Face Shown")
				get_node("%FaceMask").visible = true
				await get_tree().create_timer(0.2).timeout
				get_node("%FaceMask").visible = false
	
	OnNode.visible = true
	OffNode.visible = true
	AreaLight.visible = true
	
	FlickerTimer.start(randf_range(0.5, 3.5))
