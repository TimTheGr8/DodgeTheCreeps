extends Area2D
# Signal the player will emit when it collides with an enemy
signal hit

@export var speed = 400 # How fast the player will move - pixels per sec
var screen_size #size of the Game Window
# When the player is loaded into the tree
func _ready():
	screen_size = get_viewport_rect().size
	hide()
# Called each update frame
func _process(delta):
	# Set velocity to 0 and calculate input
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	# Normalize velocity to make moving in all directoins the same speed
	# Play the animation when velocity is greater than 0 and stop when it is not
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play() # $ is shorthand for get_node()
	else:
		$AnimatedSprite2D.stop() # get_node("AnimatedSprite2D").stop()
	# Set the position of the player, but constrain it to the screen size
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	# Check direction and flip the sprite accordingly
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "Walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "Up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
# Collision detection
func _on_body_entered(body):
	hide()
	hit.emit()
	# Disable the colllider so the signal will not emit again
	# set_deferred waits until it is safe to turn collision off
	$CollisionShape2D.set_deferred("disabled", true)
# Reset the player when starting a new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
