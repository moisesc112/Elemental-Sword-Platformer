# TODO: Might be worth exploring some parent class that handles animations for player/enemies
extends CharacterBody2D

var screen_size # Size of the game window.

var attack_in_progress = false
#var velocity 
var fire_strike_direction 

@export var speed = 300 # How fast the player will move (pixels/sec).
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var jump_speed = -300

@export var fire_strike_attack: PackedScene # exporting the fire_strike.gd


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.x = 0 # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
		fire_strike_direction = "right"
		$AnimatedSprite2D.position.x = 0
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
		fire_strike_direction = "left"
		$AnimatedSprite2D.position.x = -25
	
	if !is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_speed 
	
	
	if !attack_in_progress:
		if velocity.length() > 0:
			velocity.x = velocity.normalized().x * speed

		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		if velocity.x != 0 and is_on_floor(): #or velocity.y != 0:
			$AnimatedSprite2D.animation = "run"
			$AnimatedSprite2D.flip_h = velocity.x < 0
		elif !is_on_floor():
			$AnimatedSprite2D.animation = "jump"
		else:
			$AnimatedSprite2D.animation = "idle"
			
		$AnimatedSprite2D.play()

	move_and_slide()


func _on_skills_skill_activated(skill_name):
	#set_process_input(false)
	if is_on_floor():	
		if skill_name == "skill_1":
			self.set_physics_process(false)
			attack_in_progress = true
			$AnimatedSprite2D.animation = "attack"
			await get_tree().create_timer(0.6).timeout
			use_fire_strike()


func _on_skills_skill_completed():
	self.set_physics_process(true)
	attack_in_progress = false


func use_fire_strike():
	if fire_strike_attack:
		var fire_strike = fire_strike_attack.instantiate()
		get_tree().get_root().add_child(fire_strike)
		fire_strike.get_node("/root/FireStrike/CollisionShape2D").shape.height = 72
		fire_strike.get_node("/root/FireStrike/CollisionShape2D").shape.radius = 20
		
		if fire_strike_direction == "right":
			fire_strike.global_position = $RightMarker.global_position
			fire_strike.rotation = 0
		if fire_strike_direction == "left":
			fire_strike.global_position = $LeftMarker.global_position
			fire_strike.rotation = PI
		else:
			fire_strike.global_position = $RightMarker.global_position
			fire_strike.rotation = 0
