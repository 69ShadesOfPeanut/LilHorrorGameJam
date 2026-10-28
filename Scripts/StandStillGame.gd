# Handles the "stand still game"
# Every so often the player will hear a voice calling for them, they will have to remain completely still...
# The player gets 3 chances
extends Node3D

# Vars
var chances : int = 0
var game : bool = false
var PlayerMoved : bool = false
var MoveActions = ["WalkForward", "WalkBack", "WalkLeft", "WalkRight"]
# Exports
@export var MaxTimer : int = 180
# Nodes
@onready var TimerNode : Timer = get_node("Timer")
@onready var DontMoveText : CenterContainer = get_node("%DontMoveText")
@onready var ScreachNode : AudioStreamPlayer = get_node("%Screach")
@onready var WarningText : CenterContainer = get_node("%WarningText")
@onready var RunText : CenterContainer = get_node("%RunText")


func _ready() -> void:
	RandomTime()

# When the timer is up run the don't move section
func _on_timer_timeout() -> void:
	print("Timer up")
	
	DontMoveText.visible = true
	await get_tree().create_timer(1).timeout
	DontMoveText.visible = false
	get_tree().call_group("CeilingLamps", "ToggleLight")
	game = true
	await get_tree().create_timer(randi() % 30).timeout
	get_tree().call_group("CeilingLamps", "ToggleLight")
	game = false
	
	await get_tree().create_timer(5).timeout
	RandomTime()

# Set random time for the timer
func RandomTime():
	PlayerMoved = false
	randomize()
	var RandomNumber = randi_range(40, MaxTimer)
	print("Random number is: " + str(RandomNumber))
	TimerNode.start(RandomNumber)


# Check if player moves
func _unhandled_key_input(event: InputEvent) -> void:
	if game == true and MoveActions.any(event.is_action_pressed) and PlayerMoved == false:
		chances += 1
		PlayerMoved = true
		print("Player moved. Warning " + str(chances))
		
		if chances == 1:
			WarningText.show()
			await get_tree().create_timer(2.5).timeout
			WarningText.hide()
		elif chances == 4:
			RunText.show()
			await get_tree().create_timer(2.5).timeout
			RunText.hide()
		
		ScreachNode.play()
