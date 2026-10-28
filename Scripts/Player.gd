# Player controller
extends CharacterBody3D

# Vars 
# Nodes
@onready var CameraNode : Camera3D = get_node("%Camera3D")
@onready var PlayerInteractRay : RayCast3D = get_node("%PlayerInteractRay")
@onready var InteractTextNode : RichTextLabel = get_node("%InteractText")
# Exports
@export var Speed := 2.5
@export var Gravity := 30
@export var LookSensitivity := 35
@export var MinLookAngle := -90
@export var MaxLookAngle := 90
# Vectors
var TargetVelocity = Vector3.ZERO
var MouseDelta = Vector2()

func _ready() -> void:
	# Traps the mouse in the game window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Handle movement
func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y -= Gravity * delta
	
	# Get direction vector being pressed
	var DirectionVector = Input.get_vector("WalkLeft", "WalkRight", "WalkForward", "WalkBack")
	# Direction player moves is based on transform positioning and direction vector normalized
	var Direction = (transform.basis * Vector3(DirectionVector.x, 0, DirectionVector.y)).normalized()
	
	# Sets the velocity speed
	if Direction:
		velocity.x = Direction.x * Speed
		velocity.z = Direction.z * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		velocity.z = move_toward(velocity.z, 0 , Speed)
	
	# Moves the character
	move_and_slide()

func _process(delta: float) -> void:
	# Check if player interact ray is colliding
	# Display text telling player to interact
	if PlayerInteractRay.is_colliding() and InteractTextNode.visible == false:
		InteractTextNode.visible = true
		
		if Input.is_action_just_pressed("Interact"):
			var Interactable = PlayerInteractRay.get_collider()
			Interactable.Interact()
	elif InteractTextNode.visible == true:
		InteractTextNode.visible = false
	
	# Handles mouse movement
	# Set camera rotation sensitivity on x axis
	CameraNode.rotation_degrees.x -= MouseDelta.y * LookSensitivity * delta
	# Clamps the camera so player cant go beyond min / max look angle
	CameraNode.rotation_degrees.x = clamp(CameraNode.rotation_degrees.x, MinLookAngle, MaxLookAngle)
	# Set camera rotation sensitivity on Y axis
	rotation_degrees.y -= MouseDelta.x * LookSensitivity * delta
	
	# Actually move the camera
	MouseDelta = Vector2()

# Captures mouse movement event
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		MouseDelta = event.relative
