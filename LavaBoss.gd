extends CharacterBody2D

class_name LavaBoss
signal lava_boss_death
signal lava_boss_collision
signal lava_boss_music
signal lava_boss_healthbar


var SPEED = 75
const JUMP_VELOCITY = -400.0
var hp = 20
var touch_damage = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var motion = Vector2.ZERO
var direction
var normalized_direction
var max_hp = 20

var player = null
var player_breath = null
var is_breathing = false
var cooldown = false

@onready var breath_hitbox = $BreathHitBox/CollisionShape2D 
@onready var breath_detection = $BreathArea/CollisionShape2D
@onready var player_detection = $DetectionArea/CollisionShape2D


func _physics_process(delta):
	#print(player)
	#print($LavaBossSprite.frame)
	if !is_on_floor():
		velocity.y += gravity * delta
#	var direction = 1
	#var direction = self.position - player.position
	if player and !is_breathing:
		#print("moving")
		direction = player.position - self.position 
		normalized_direction = direction.normalized().x
		velocity.x = normalized_direction * SPEED
		#velocity.x = velocity.normalized().x * SPEED
		#velocity.x = direction * SPEED
		#print("pineapple")
		
		if normalized_direction >= 0:
			#$AnimatedSprite2D.flip_h = false
			$LavaBossSprite.flip_h = true
			$CollisionShape2D.position.x = 60
			$Area2D/CollisionShape2D.position.x = 60
			breath_detection.position.x = 65
			breath_hitbox.position.x = 200
		else:
			#$AnimatedSprite2D.flip_h = true
			$LavaBossSprite.flip_h = false
			$CollisionShape2D.position.x = 0
			$Area2D/CollisionShape2D.position.x = 0
			breath_detection.position.x = 0
			breath_hitbox.position.x = -127
			
		if velocity.x != 0:
#			#$AnimatedSprite2D.animation = "run"
			$LavaBossSprite.animation = "idle"
			$LavaBossSprite.position.x = 34
			$LavaBossSprite.position.y = 2
	#else:
#		velocity.x = 0
#		if direction.x > -65 and direction.x < 0:
#			is_breathing = true
#			$BreathTimer.start()
#		elif direction.x < 90 and direction.x > 0:
#			is_breathing = true
#			$BreathTimer.start()
#
#		if is_breathing:
#			velocity.x = 0
#			$LavaBossSprite.animation = "attack_breath"
#			$LavaBossSprite.position.x = -33
#			$LavaBossSprite.position.y = -38
#		else:
#			pass

	if is_breathing and !cooldown:
		velocity.x = 0
		$LavaBossSprite.animation = "attack_breath"
		if $LavaBossSprite.frame >= 7:
			breath_hitbox.set_deferred("disabled", false)
		#$LavaBossSprite.animation = "breath_charge"
		if normalized_direction >= 0:
			$LavaBossSprite.position.x = 100
			$LavaBossSprite.position.y = -38
			#breath_hitbox.position.x = 200
		else:
			$LavaBossSprite.position.x = -33
			$LavaBossSprite.position.y = -38
			#breath_hitbox.position.x = -127
			
			
			
		#await get_tree().create_timer(0.1).timeout
		#$LavaBossSprite.stop()
		#$LavaBossSprite.animation = "breath"
	else:
		$LavaBossSprite.animation = "idle"
		$LavaBossSprite.position.x = 34
		$LavaBossSprite.position.y = 2
		breath_hitbox.set_deferred("disabled", true)
		#$BreathHitbox/CollisionShape2D.disabled = true
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#	motion = Vector2.ZERO
#	if player:
#		motion = position.direction_to(player.position) * SPEED


#	if is_on_wall():
#		velocity.x = normalized_direction * SPEED
	move_and_slide()



	#if is_on_wall():
#		velocity.y += gravity * delta
#		velocity.x = 0
#		await get_tree().create_timer(0.5).timeout
		#velocity.x = -normalized_direction * SPEED
#		SPEED = -SPEED
#
#	if normalized_direction < 0:
#		#$AnimatedSprite2D.flip_h = false
#		$LavaBossSprite.flip_h = true
#	else:
#		#$AnimatedSprite2D.flip_h = true
#		$LavaBossSprite.flip_h = false
#	if velocity.x != 0:
#		#$AnimatedSprite2D.animation = "run"
#		$LavaBossSprite.animation = "idle"
	
	#$AnimatedSprite2D.play()
	$LavaBossSprite.play()
	
func _on_ready():
	hide()
	#self.set_physics_process(false)
	

func update_health():
#	var healthbar = $healthbar
#	healthbar.value = hp
#	if hp >= 5:
#		healthbar.visible = false
#	else:
#		healthbar.visible = true
	lava_boss_healthbar.emit()

func take_damage(damage):
	set_hp(hp - damage) 
	
func set_hp(new_hp):
	hp = new_hp
	if hp <= 0:
		die()
		#player.$AnimatedSprite2D.animation = "victory"

func heal():
	hp = max_hp

func die():
	lava_boss_death.emit()
	#queue_free()
	#print("bye mushroom")
	#Player.victory()


func _on_area_2d_body_entered(body):
	if body is Player:
		var player: Player = body as Player
		player.take_damage(touch_damage)
		player.update_health()
		self.add_collision_exception_with(player)


func _on_detection_area_body_entered(body):
	if body is Player:
		player = body
		lava_boss_music.emit()

func _on_detection_area_body_exited(body):
	player = null


func _on_breath_timer_timeout():
	is_breathing = false
	#$BreathHitbox/CollisionShape2D.set_deferred("disabled", true)
	velocity.x = normalized_direction * SPEED
	cooldown = true
	$CooldownTimer.start()

func _on_breath_area_body_entered(body):
	if body is Player:
		player_breath = body
		is_breathing = true
		#velocity.x = 0
		$BreathTimer.start()
		#$BreathArea/CollisionShape2D.shape.extents = Vector2(0,0)
		#$DetectionArea/CollisionShape2D.shape.extents = Vector2(0,0)
		breath_detection.set_deferred("disabled", true)
		player_detection.set_deferred("disabled", true)

func _on_breath_area_body_exited(body):
	player_breath = null
	#$DetectionArea/CollisionShape2D.shape.extents = Vector2(409,287)
	player_detection.set_deferred("disabled", false)

func _on_cooldown_timer_timeout():
	cooldown = false
	#$BreathArea/CollisionShape2D.shape.extents = Vector2(400,215)
	breath_detection.set_deferred("disabled", false)
