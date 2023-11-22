extends CharacterBody2D

class_name Mushroom
signal mushroom_death
signal mushroom_collision


var SPEED = 75
const JUMP_VELOCITY = -400.0
var hp = 5
var touch_damage = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = 1
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if is_on_wall():
		SPEED = -SPEED
		
	if SPEED > 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
		
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "run"
	
	$AnimatedSprite2D.play()
	
func _on_ready():
	hide()
	#self.set_physics_process(false)
	

func update_health():
	var healthbar = $healthbar
	healthbar.value = hp
	if hp >= 5:
		healthbar.visible = false
	else:
		healthbar.visible = true


func take_damage(damage):
	set_hp(hp - damage) 
	
func set_hp(new_hp):
	hp = new_hp
	if hp <= 0:
		die()
		#player.$AnimatedSprite2D.animation = "victory"

func die():
	mushroom_death.emit()
	queue_free()
	print("bye mushroom")
	#Player.victory()


func _on_area_2d_body_entered(body):
	if body is Player:
		var player: Player = body as Player
		player.take_damage(touch_damage)
		player.update_health()
		self.add_collision_exception_with(player)
