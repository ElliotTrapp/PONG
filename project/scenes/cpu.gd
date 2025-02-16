extends StaticBody2D

enum Skill {
	NOVICE = 1,
	INTERMEDIATE = 3,
	EXPERT = 10
}

var ball_pos : Vector2
var dist : int
var move_by : int
var win_height : int
var p_height : int
var skill : int = Skill.NOVICE

const DEFAULT_SKILL = Skill.INTERMEDIATE

# Adjust these factors to tune the effect of randomness on your paddle movement.
const RANDOM_SCALE: float = 20.0  # Scales the random offset magnitude

# A helper function that returns an average value of several uniform random values.
# Fewer iterations produce a more variable (error-prone) result.
func get_random_offset() -> float:
	var iterations = int(skill)
	var result: float = 0.0
	for i in range(iterations):
		result += randf()
	return result / float(iterations)

func get_move_by(ball_pos: Vector2, dist: int, delta: float) -> int:
	if not dist:
		return dist
	var move_by
	move_by = get_parent().PADDLE_SPEED * delta * (dist / abs(dist))
		
	# Get a random offset based on the current skill level.
	var random_offset: float = get_random_offset() - 0.5  # Center to roughly [-0.5, 0.5]
	# Apply scaling to the random offset for tuning.
	move_by += random_offset * RANDOM_SCALE
	
	# don't overshoot
	if abs(dist) < move_by:
		move_by = dist
		
	return move_by

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y
	skill = DEFAULT_SKILL
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# move paddle towards the ball
	ball_pos = $"../Ball".position
	dist = position.y - ball_pos.y
	position.y -= get_move_by(ball_pos, dist, delta)
	
	# limit paddle movement to window
	position.y = clamp(position.y, p_height / 2, win_height - p_height / 2)
