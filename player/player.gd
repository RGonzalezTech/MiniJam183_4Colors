extends CharacterBody2D

## Tweak the player's speed
@export var speed: float = 300.0

func _physics_process(delta: float) -> void:
	# --- Movement Handling ---

	# Get input direction vector based on pre-defined actions.
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Calculate the desired velocity.
	velocity = input_direction * speed

	# --- Apply Movement ---
	# This is the core function for CharacterBody2D movement.
	# It moves the body based on its 'velocity', handles collisions,
	# and slides along obstacles.
	move_and_slide()

	# --- Rotation Handling (Look at Mouse) ---

	# Get the direction vector from the player's current position to the global mouse position.
	var direction_to_mouse: Vector2 = get_global_mouse_position() - global_position

	# Set the character's rotation angle (in radians) to face the mouse cursor.
	# ADD '+ PI / 2.0' TO CORRECT THE OFFSET.
	# PI / 2.0 is equivalent to 90 degrees in radians.
	rotation = direction_to_mouse.angle() + PI / 2.0
