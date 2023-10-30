# TODO: Might be worth exploring some parent class that handles animations for player/enemies
extends Area2D


@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

var attack_in_progress = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1


	
	if !attack_in_progress:
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed

		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		if velocity.x != 0 or velocity.y != 0:
			$AnimatedSprite2D.animation = "run"
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.play()


func _on_skills_skill_activated(skill_name):
	if skill_name == "skill_1":
		attack_in_progress = true
		$AnimatedSprite2D.animation = "attack"
		


func _on_skills_skill_completed():
	attack_in_progress = false

