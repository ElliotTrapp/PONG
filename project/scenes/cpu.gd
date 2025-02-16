extends StaticBody2D

const Skill = Settings.Skill
const DEFAULT_SKILL = Skill.MEDIUM
const RANDOM_SCALE: float = 40.0  # Adjust this to control random effect magnitude

var ball_pos: Vector2
var win_height: int
var p_height: int
var skill: Skill = Skill.MEDIUM


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y
	skill = Settings.selected_skill
	print_debug('CPU set to %s skill' % Skill.keys()[skill])
	randomize()

# A helper function that returns an average value of several uniform random values.
# More iterations (controlled by skill) results in a smoother (less variable) randomness.
func get_random_offset() -> float:
	var iterations : int
	match skill:
		Skill.EASY:
			iterations = 1
		Skill.MEDIUM:
			iterations = 3
		Skill.HARD:
			iterations = 8
	var result: float = 0.0
	for i in range(iterations):
		result += randf()
	return result / float(iterations)  # returns a value roughly between 0 and 1

func _process(delta: float) -> void:
	# Get ball's position
	ball_pos = $"../Ball".position
	
	# Calculate a base target position for the paddle to follow (aim for ball's Y coordinate)
	var target_y = ball_pos.y
	
	# Add a randomness offset to simulate human error.
	# By centering the offset around 0, we subtract 0.5, then scale by RANDOM_SCALE.
	var offset = (get_random_offset() - 0.5) * RANDOM_SCALE
	
	# Combine the ball target with the randomness
	target_y += offset
	
	# Compute a smoothing factor (a higher smoothing moves faster).
	# You can adjust these multipliers to tweak the “feel” for each skill level.
	var smoothing: float
	match skill:
		Skill.EASY:
			smoothing = 0.02  # slow reaction + more error
		Skill.MEDIUM:
			smoothing = 0.05
		Skill.HARD:
			smoothing = 0.1   # quick, more precise
		_:
			smoothing = 0.05

	# Interpolate smoothly from current position toward the target
	position.y = lerp(position.y, target_y, smoothing * delta * 60.0)
	
	# Ensure the paddle stays within window bounds
	position.y = clamp(position.y, p_height / 2, win_height - p_height / 2)
