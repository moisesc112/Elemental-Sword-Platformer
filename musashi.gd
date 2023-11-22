# TODO: Might be worth exploring some parent class that handles animations for player/enemies
extends CharacterBody2D

class_name Player


@export var fire_strike_attack: PackedScene # exporting the fire_strike.gd
@export var flash_attack: PackedScene # exporting the flash_attack.gd
var screen_size # Size of the game window.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var attack_in_progress = false
var fire_strike_direction 
var speed = 150 # How fast the player will move (pixels/sec).
var jump_speed = -300
var momentum = 1
var direction = 0
var hp = 1
var max_hp = 5
var body_collision
var temp_direction = 1
var is_dashing = false
var being_damaged = false
#var head_collision 


signal death
signal taking_damage
signal dash_obstructed


## Called when the node enters the scene tree for the first time.
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	

func _ready():
	hide()
	direction = 1
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D2.hide()
	$AnimatedSprite2D2/Area2D.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.x = 0 # The player's movement vector.
	keyboard_inputs()
	calculate_movement(delta)
	$RayCastBody.add_exception($AnimatedSprite2D2/Area2D)
	$RayCastHead.add_exception($AnimatedSprite2D2/Area2D)
	#$RayCast2D.add_exception(Mushroom)
	#$RayCast2D.add_exception($CollisionShape2D)
	#$RayCast2D.add_exception($AnimatedSprite2D2/Area2D/CollisionShape2D)
	#print($RayCastBody.get_collision_point())
	#print($RayCastBody.is_colliding)
	
	if $RayCastBody.is_colliding() or $RayCastHead.is_colliding() or $RayCastEyes.is_colliding():
		body_collision = true
	else:
		body_collision = false
	
	#print(direction)
	

func keyboard_inputs():
	if hp > 0 and !is_dashing:
		if !Input.is_action_pressed("move_left"):
			if Input.is_action_pressed("move_right") and is_on_floor():
				velocity.x += speed
				direction = 1
				temp_direction = direction
				fire_strike_direction = "right"
				$AnimatedSprite2D.position.x = 0
				$RayCastBody.rotation = 0
				$RayCastBody.position.x = 168
				
				$RayCastHead.rotation = 0
				$RayCastHead.position.x = 168
				
				$RayCastEyes.rotation = 0
				$RayCastEyes.position.x = 168
				#$CollisionShape2D.position.x = -12
		
		if !Input.is_action_pressed("move_right"):
			if Input.is_action_pressed("move_left") and is_on_floor():
				velocity.x -= speed
				direction = -1
				temp_direction = direction
				fire_strike_direction = "left"
				$AnimatedSprite2D.position.x = -32
				$RayCastBody.rotation = PI
				$RayCastBody.position.x = -200
				$RayCastHead.rotation = PI
				$RayCastHead.position.x = -200
				$RayCastEyes.rotation = PI
				$RayCastEyes.position.x = -200
				#$CollisionShape2D.position.x = 12
			
			
		if Input.is_action_just_pressed("ui_accept") and is_on_floor() and Input.is_action_pressed("move_right") and Input.is_action_pressed("move_left") : 
			velocity.y = jump_speed 
			direction = 0
		elif Input.is_action_just_pressed("ui_accept") and is_on_floor() and Input.is_action_pressed("move_right"):
			velocity.y = jump_speed 
			direction = 1
		elif Input.is_action_just_pressed("ui_accept") and is_on_floor() and Input.is_action_pressed("move_left"):
			velocity.y = jump_speed 
			direction = -1
		elif Input.is_action_just_pressed("ui_accept") and is_on_floor():
			var temp_direction = direction
			while !is_on_floor():
				direction = 0
			velocity.x = 0 
			velocity.y = jump_speed
			direction += temp_direction
		

	if !is_on_floor() and direction == 1:
		velocity.x = speed
	elif !is_on_floor() and direction == -1:
		velocity.x = -speed
	elif !is_on_floor() and direction == 0:
		if Input.is_action_pressed("move_left") and !is_on_floor():
			direction = 0

func calculate_movement(delta):
	if !attack_in_progress:
		if velocity.length() > 0 and direction != 0:
			velocity.x = velocity.normalized().x * speed
		else:
			velocity.x = 0
		position += velocity * delta
		velocity.y += gravity * delta
#		if !is_on_floor():
#			velocity.y += gravity * delta
		set_movement_animation()
	
#	if attack_in_progress:
#		speed = 0
	
	if is_on_wall():
		if !is_on_floor():
			speed = 0
	else:
		speed = 150
	
	
	
	move_and_slide()
	
	


func set_movement_animation():
	if velocity.x != 0 and is_on_floor() and hp > 0: 
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif !is_on_floor() and hp > 0:
		$AnimatedSprite2D.animation = "jump"
	elif hp > 0:
		$AnimatedSprite2D.animation = "idle"
	else:
		$AnimatedSprite2D.animation = "death"
	$AnimatedSprite2D.play()


func victory():
	if hp != 0:
		$AnimatedSprite2D.animation = "victory"
		self.set_physics_process(false)


func update_health():
	var healthbar = $healthbar
	healthbar.value = hp
	if hp >= 5:
		healthbar.visible = false
	else:
		healthbar.visible = true


func take_damage(damage):
	if hp != 0:
		set_hp(hp - damage) 
		taking_damage.emit()
		being_damaged = true
		$StrikeTimer.start()
		$AnimatedSprite2D.animation = "damage"
		$iframeTimer.start()
		#$inputTimer.start()
		self.set_physics_process(false)
		self.set_collision_layer_value(2, false)
		self.set_collision_layer_value(1, false)
		await get_tree().create_timer(0.2).timeout
		self.set_physics_process(true)
	else: 
		pass

func set_hp(new_hp):
	hp = new_hp
	if hp <= 0:
		die()

func heal():
	hp = max_hp


func die():
	await get_tree().create_timer(1).timeout
	death.emit()
	$healthbar.visible = false
	print("musashi died")

func _on_skills_skill_activated(skill_name):
	if is_on_floor():	
		if skill_name == "skill_1":
			#print("hi")
			self.set_physics_process(false)
			attack_in_progress = true
			$AnimatedSprite2D.animation = "attack"
			await get_tree().create_timer(0.6).timeout
			if being_damaged == false:
				use_fire_strike()
			else:
				pass
		elif skill_name == "skill_2":
			if body_collision == false:
				#$DashTimer.start()
				self.set_physics_process(false)
				attack_in_progress = true
				$AnimatedSprite2D.animation = "flash1"
				await get_tree().create_timer(0.4).timeout
				$AnimatedSprite2D.animation = "flash3"

				use_flash_attack()
				$AnimatedSprite2D2.show()
				$AnimatedSprite2D2.play()
				$AnimatedSprite2D2.animation = "flash2"
				$AnimatedSprite2D2/Area2D.show()
				await get_tree().create_timer(0.1).timeout
				$AnimatedSprite2D2.hide()
				$AnimatedSprite2D2/Area2D.hide()

				#$AnimatedSprite2D2/Area2D.collision_layer = 3
				#$AnimatedSprite2D2/Area2D.collision_mask = 3
				await get_tree().create_timer(0.01).timeout
				$AnimatedSprite2D.show()
				$DashTimer.start()
				is_dashing = true
			else:
				dash_obstructed.emit()
				return

func _on_skills_skill_completed():
	self.set_physics_process(true)
	attack_in_progress = false
	$AnimatedSprite2D2/Area2D.set_collision_mask_value(2, false)
	direction = 0
	#is_fire_striking = false
	
	
func use_fire_strike():
	#is_fire_striking = true
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

func use_flash_attack():
#	var flash = flash_attack.instantiate()
#	get_tree().get_root().add_child(flash)
#	flash.global_position = $LeftMarker.global_position
#
#	flash._on_node_2d_child_entered_tree()
#	$AnimatedSprite2D2/Area2D.collision_layer = 2
#	$AnimatedSprite2D2/Area2D.collision_mask = 2
	$AnimatedSprite2D2/Area2D.set_collision_mask_value(2, true)
	#$AnimatedSprite2D2/Area2D.set_collision_layer_value(2, true)
	#$AnimatedSprite2D2/Area2D.set_collision_layer_value(1, true)
	$AnimatedSprite2D.hide()
	
	if temp_direction > 0:
		#velocity.x += 0
		position.x += 200
		#velocity.y += 980
		$AnimatedSprite2D2.rotation = 0
		$AnimatedSprite2D2/Area2D/CollisionShape2D.rotation = 0
		$AnimatedSprite2D2.position.x = -112
		
	elif temp_direction < 0:
		#velocity.x -= 0
		position.x -= 200
		#velocity.y += 980
		$AnimatedSprite2D2.rotation = PI
		$AnimatedSprite2D2/Area2D/CollisionShape2D.rotation = PI
		$AnimatedSprite2D2.position.x = 80
	

func _on_iframe_timer_timeout():
	self.set_collision_layer_value(2, true)
	self.set_collision_layer_value(1, true)

func _on_input_timer_timeout():
	#self.set_physics_process(true)
	pass

func _on_taking_damage():
	_on_skills_skill_completed()

func _on_dash_timer_timeout():
	is_dashing = false

func _on_strike_timer_timeout():
	being_damaged = false
