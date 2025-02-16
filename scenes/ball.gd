extends CharacterBody2D

var win_size : Vector2
var speed : int
var dir : Vector2
var last_played : int
var sounds : Array

const START_SPEED : int = 400
const ACCEL : int = 50
const MAX_Y_VECTOR : float = 0.6

func _ready():
	sounds = [$"../PongSound", $"../PingSound"]
	last_played = 0
	win_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(dir * speed * delta)
	var collider
	if collision:
		last_played += 1
		if last_played >= sounds.size():
			last_played = 0
		sounds[last_played].play()
		collider = collision.get_collider()
		# if ball hits paddel
		if collider == $"../Player" or collider == $"../CPU":
			speed += ACCEL
			dir = new_direction(collider)
		# if it hits one of the walls
		else:
			dir = dir.bounce(collision.get_normal())
	
func new_ball():
	# randomize start position and direction
	position.x = win_size.x / 2
	position.y = randi_range(200, win_size.y - 200)
	speed = START_SPEED
	dir = random_direction()
	
func random_direction():
	var new_dir := Vector2()
	new_dir.x = [1, -1].pick_random()
	new_dir.y = randf_range(-1, 1)
	return new_dir.normalized()

func new_direction(collider):
	var ball_y = position.y
	var pad_y = collider.position.y
	var dist = ball_y - pad_y
	var new_dir := Vector2()
	
	# flip the horizontal direction
	if dir.x > 0:
		new_dir.x = -1
	else:
		new_dir.x = 1
	new_dir.y = (dist / collider.p_height /2) * MAX_Y_VECTOR
	return new_dir.normalized()
