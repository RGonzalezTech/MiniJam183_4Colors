extends Camera2D

## The maximum distance the camera will shift from the center (player position).
## Adjust this value in the Inspector to control the intensity of the effect.
@export var max_offset_distance: float = 100.0

## How quickly the camera moves to its target offset. Higher values are faster.
## Using values around 5.0 gives a nice smooth feel.
## A value <= 0 means instant snapping (or potentiawdwdddl issues with exp smoothing).
@export var smoothing_factor: float = 5.0

# We store the target offset to smoothly interpolate towards it.
var target_offset: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	# Get the dimensions of the game window (viewport).
	var viewport_rect: Rect2 = get_viewport_rect()
	# Calculate the center of the viewport.
	var viewport_center: Vector2 = viewport_rect.size / 2.0

	# Get the current mouse position within the viewport.
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()

	# Calculate the vector pointing from the center of the screen to the mouse cursor.
	var direction_from_center: Vector2 = mouse_pos - viewport_center
	
	# Calculate the normalized offset relative to the viewport size.
	# This gives a vector where components range from -1 to 1 approx,
	# representing the mouse position relative to the center.
	# For example, top-left corner is roughly (-1, -1), bottom-right is (1, 1).
	var normalized_direction: Vector2 = Vector2(
		direction_from_center.x / viewport_center.x,
		direction_from_center.y / viewport_center.y
	)

	# Clamp the normalized direction vector length to 1 to handle cases
	# where the mouse might go outside the window bounds slightly or if
	# aspect ratio makes one dimension relatively smaller.
	# This ensures the offset doesn't exceed max_offset_distance magnitude.
	normalized_direction = normalized_direction.limit_length(1.0)

	# Calculate the target offset by scaling the normalized direction
	# by the maximum desired distance.
	target_offset = normalized_direction * max_offset_distance

	# Smoothly interpolate the camera's current offset towards the target offset.
	# Using exp(-smoothing_factor * delta) provides frame-rate independent smoothing.
	if smoothing_factor > 0:
		# Apply exponential smoothing
		offset = offset.lerp(target_offset, 1.0 - exp(-smoothing_factor * delta))
	else:
		# Snap instantly to the target offset if smoothing is disabled
		offset = target_offset
