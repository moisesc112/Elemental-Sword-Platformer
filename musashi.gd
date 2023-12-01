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
var dash_direction = 1 
var vertical_collision
var dash_blocked = false
var diagonal_collision
var air_jump = false
var air_right
#var water_strike = false
@onready var water_dash = $WaterDash
const water_dash_speed = 500
const water_dash_length = 5

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
	
	if $RayCastVertical.is_colliding():
		vertical_collision = true
	else:
		vertical_collision = false
	
	if $RayCastDiagonal.is_colliding():
		diagonal_collision = true
	else:
		diagonal_collision = false
	
	#print(temp_direction)
	

func keyboard_inputs():
	if hp > 0 and !is_dashing:
		if !Input.is_action_pressed("move_left"):
			if Input.is_action_pressed("move_right") and is_on_floor(): #and !Input.is_action_pressed("move_up"):
				velocity.x += speed
				direction = 1
				temp_direction = direction
				dash_direction = 1
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
				dash_direction = -1
				fire_strike_direction = "left"
				$AnimatedSprite2D.position.x = -32
				$RayCastBody.rotation = PI
				$RayCastBody.position.x = -200
				$RayCastHead.rotation = PI
				$RayCastHead.position.x = -200
				$RayCastEyes.rotation = PI
				$RayCastEyes.position.x = -200
				#$CollisionShape2D.position.x = 12
		
		if Input.is_action_pressed("move_up"):
			dash_direction = 2
			$RayCastVertical.rotation = 3*PI/2
			$RayCastVertical.position.y = -136
		
		if Input.is_action_pressed("move_down"):
			dash_direction = -2
			$RayCastVertical.rotation = PI/2
			$RayCastVertical.position.y = 168

		if Input.is_action_pressed("move_up") and Input.is_action_pressed("move_right"):
			#print("check")
			dash_direction = 3
			$RayCastDiagonal.rotation = 7*PI/4
			$RayCastDiagonal.position.y = -136
			$RayCastDiagonal.position.x = 136
			
		elif Input.is_action_pressed("move_down") and Input.is_action_pressed("move_right"):
			#print("check")
			dash_direction = -3
			$RayCastDiagonal.rotation = PI/4
			$RayCastDiagonal.position.y = 136
			$RayCastDiagonal.position.x = 136

		elif Input.is_action_pressed("move_up") and Input.is_action_pressed("move_left"):
			#print("check")
			dash_direction = 4
			$RayCastDiagonal.rotation = 5*PI/4
			$RayCastDiagonal.position.y = -136
			$RayCastDiagonal.position.x = -136
		elif Input.is_action_pressed("move_down") and Input.is_action_pressed("move_left"):
			#print("check")
			dash_direction = -4
			$RayCastDiagonal.rotation = 3*PI/4
			$RayCastDiagonal.position.y = 136
			$RayCastDiagonal.position.x = -136

		if is_on_floor():
			air_jump = true
			air_right = false

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
			temp_direction = direction
			while !is_on_floor():
				direction = 0
			velocity.x = 0 
			velocity.y = jump_speed
			direction += temp_direction
#		elif Input.is_action_just_pressed("ui_accept") and !is_on_floor() and air_jump:
#			if Input.is_action_pressed("move_left"):
#				direction = -1
#				velocity.y = jump_speed * 0.8
#				air_jump = false
#			elif Input.is_action_pressed("move_right"):
#				direction = 1
#				velocity.y = jump_speed * 0.8
#				air_jump = false
#			else:
#				direction = 0
#				velocity.y = jump_speed * 0.8
#				air_jump = false
#
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
		#$AnimatedSprite2D.animation = "run"
		#$AnimatedSprite2D.flip_h = velocity.x < 0
		$PlayerSprite.animation = "run"
		$PlayerSprite.flip_h = velocity.x < 0
	elif air_jump == false and hp > 0:
		pass
		#$AnimatedSprite2D.animation = "air_strike"
		#$AnimatedSprite2D.flip_h =  temp_direction < 0 
	elif !is_on_floor() and hp > 0:
		#$AnimatedSprite2D.animation = "jump"
		$PlayerSprite.animation = "jump"
	elif hp > 0:
		#$AnimatedSprite2D.animation = "idle"
		$PlayerSprite.animation = "idle"
	else:
		$AnimatedSprite2D.animation = "death"
	$AnimatedSprite2D.play()
	$PlayerSprite.play()

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
		$PlayerSprite.animation = "hurt"
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

func _on_skills_skill_activated(skill_name):
	if is_on_floor():	
		if skill_name == "skill_1":
			#print("hi")
			self.set_physics_process(false)
			attack_in_progress = true
			$AnimatedSprite2D.animation = "attack"
			$PlayerSprite.animation = "attack"
			await get_tree().create_timer(0.6).timeout
			if being_damaged == false:
				use_fire_strike()
			else:
				pass

		elif skill_name == "skill_2":
#			if body_collision == false:
			#if (body_collision == false or vertical_collision == false): #and (dash_direction == 1 or -1)) or (vertical_collision == false and (dash_direction == 2 or -2)):
			
#			self.set_physics_process(false)
#			attack_in_progress = true
#			$AnimatedSprite2D.animation = "flash1"
#			await get_tree().create_timer(0.4).timeout
#			$AnimatedSprite2D.animation = "flash3"

			use_flash_attack()
			
#			$AnimatedSprite2D2.show()
#			$AnimatedSprite2D2.play()
#			$AnimatedSprite2D2.animation = "flash2"
#			$AnimatedSprite2D2/Area2D.show()
#			await get_tree().create_timer(0.1).timeout
#			$AnimatedSprite2D2.hide()
#			$AnimatedSprite2D2/Area2D.hide()
#			await get_tree().create_timer(0.01).timeout
#			$AnimatedSprite2D.show()
#			$DashTimer.start()
#			is_dashing = true
					
			#else:
				#dash_obstructed.emit()
				#return
		elif skill_name == "skill_4":
			print("skill_4")
			#water_strike = false
			#speed += 500
			#direction = 1
			#velocity.x += velocity.normalized().x * speed * 2
			water_dash.start_water_dash(water_dash_length)
			if water_dash.is_water_dashing():
				$AnimatedSprite2D.animation = "water1"
				speed = water_dash_speed
			else:
				speed = 150
			

	elif !is_on_floor() and air_jump:
		if skill_name == "skill_3":
			if Input.is_action_pressed("move_left"):
				if temp_direction == 1:
					$AnimatedSprite2D.animation = "air_strike_reverse"
					$PlayerSprite.animation = "double_jump"
					#$AnimatedSprite2D.animation = "air_strike"
					#$AnimatedSprite2D.flip_h = true 
				elif temp_direction == -1:
					$AnimatedSprite2D.animation = "air_strike"
					$PlayerSprite.animation = "double_jump"
					#$AnimatedSprite2D.flip_h = true
				print("pasta")
				$AirStrike.position.x = -32
				direction = -1
				velocity.y = jump_speed * 0.8
				air_jump = false
				$AirStrike.set_collision_mask_value(1, true)
				$AirStrike.set_collision_mask_value(2, true)
			elif Input.is_action_pressed("move_right"):
				if temp_direction == 1:
					$AnimatedSprite2D.animation = "air_strike"
					$PlayerSprite.animation = "double_jump"
					#$AnimatedSprite2D.flip_h = false
				elif temp_direction == -1:
					$AnimatedSprite2D.animation = "air_strike_reverse"
					$PlayerSprite.animation = "double_jump"
					#$AnimatedSprite2D.animation = "air_strike"
					#$AnimatedSprite2D.flip_h = false
				$AirStrike.position.x = 0
				direction = 1
				velocity.y = jump_speed * 0.8
				air_jump = false
				$AirStrike.set_collision_mask_value(1, true)
				$AirStrike.set_collision_mask_value(2, true)
			else:
				if temp_direction < 0:
					$AirStrike.position.x = -32
					$AnimatedSprite2D.animation = "air_strike"
					$AnimatedSprite2D.flip_h = true 
					$PlayerSprite.animation = "double_jump"
				else: 
					$AirStrike.position.x = 0
					$AnimatedSprite2D.animation = "air_strike"
					$AnimatedSprite2D.flip_h = false
					$PlayerSprite.animation = "double_jump"
					#await get_tree().create_timer(0.01).timeout
					#$PlayerSprite.animation = "jump"
				direction = 0
				velocity.y = jump_speed * 0.8
				air_jump = false
				$AirStrike.set_collision_mask_value(1, true)
				$AirStrike.set_collision_mask_value(2, true)
		else:
			pass


func _on_skills_skill_completed():
	self.set_physics_process(true)
	attack_in_progress = false
	$AnimatedSprite2D2/Area2D.set_collision_mask_value(2, false)
	$AirStrike.set_collision_mask_value(1, false)
	$AirStrike.set_collision_mask_value(2, false)
	direction = 0
	dash_direction = temp_direction
	#water_strike = true
	#air_jump = true
	#dash_blocked = false
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


	#$AnimatedSprite2D2/Area2D.set_collision_mask_value(2, true)

	#$AnimatedSprite2D.hide()
	
	
	if (!Input.is_action_pressed("move_up") and !Input.is_action_pressed("move_down")) and (Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")) or dash_direction == 1 or dash_direction == -1:
		print("hey")
		if body_collision == false: #and (dash_direction == 1 or -1):
			if dash_direction == 1:
				
				self.set_physics_process(false)
				attack_in_progress = true
				$AnimatedSprite2D.animation = "flash1"
				$PlayerSprite.animation = "flash1"
				await get_tree().create_timer(0.4).timeout
				$AnimatedSprite2D.animation = "flash3"
				$PlayerSprite.animation = "flash3"
				
				$AnimatedSprite2D2/Area2D.set_collision_mask_value(2, true)
				$AnimatedSprite2D.hide()
				$PlayerSprite.hide()
				position.x += 200
				$AnimatedSprite2D2.rotation = 0
				$AnimatedSprite2D2.position.x = -112
				$AnimatedSprite2D2.position.y = 16
				
				flash_attack_end()
				
			elif dash_direction == -1:
				
				self.set_physics_process(false)
				attack_in_progress = true
				$AnimatedSprite2D.animation = "flash1"
				$PlayerSprite.animation = "flash1"
				await get_tree().create_timer(0.4).timeout
				$AnimatedSprite2D.animation = "flash3"
				$PlayerSprite.animation = "flash3"
				
				$AnimatedSprite2D2/Area2D.set_collision_mask_value(2, true)
				$AnimatedSprite2D.hide()
				$PlayerSprite.hide()
				position.x -= 200
				$AnimatedSprite2D2.rotation = PI
				$AnimatedSprite2D2.position.x = 80
				$AnimatedSprite2D2.position.y = 16
				
				flash_attack_end()
		else:
			dash_obstructed.emit()
			dash_blocked = true
			print("here")

	elif (!Input.is_action_pressed("move_right") and !Input.is_action_pressed("move_left")) and (Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down")):
		print("hey2")
		if vertical_collision == false: #and (dash_direction == 2 or -2):
			if dash_direction == 2:
				self.set_physics_process(false)
				attack_in_progress = true
				$AnimatedSprite2D.animation = "flash1"
				$PlayerSprite.animation = "flash1"
				await get_tree().create_timer(0.4).timeout
				$AnimatedSprite2D.animation = "flash3"
				$PlayerSprite.animation = "flash3"
				
				
				$AnimatedSprite2D2/Area2D.set_collision_mask_value(2, true)
				$AnimatedSprite2D.hide()
				position.y -= 200
				$AnimatedSprite2D2.rotation = -PI/2
				$AnimatedSprite2D2.position.x = -16
				$AnimatedSprite2D2.position.y = 116
				
				flash_attack_end()
				
			elif dash_direction == -2:
				self.set_physics_process(false)
				attack_in_progress = true
				$AnimatedSprite2D.animation = "flash1"
				$PlayerSprite.animation = "flash1"
				await get_tree().create_timer(0.4).timeout
				$AnimatedSprite2D.animation = "flash3"
				$PlayerSprite.animation = "flash3"
				
				$AnimatedSprite2D2/Area2D.set_collision_mask_value(2, true)
				$AnimatedSprite2D.hide()
				position.y += 200
				$AnimatedSprite2D2.rotation = PI/2
				$AnimatedSprite2D2.position.x = -16
				$AnimatedSprite2D2.position.y = -84

				flash_attack_end()
		else:
			dash_obstructed.emit()
			dash_blocked = true
			
	#elif Input.is_action_pressed("move_up") or Input.is_action_pressed("move_right"):
	elif diagonal_collision == false and (dash_direction == 3 or dash_direction == -3 or dash_direction == 4 or dash_direction == -4):
		print("hey3")
		if dash_direction == 3:
			self.set_physics_process(false)
			attack_in_progress = true
			$AnimatedSprite2D.animation = "flash1"
			$PlayerSprite.animation = "flash1"
			await get_tree().create_timer(0.4).timeout
			$AnimatedSprite2D.animation = "flash3"
			$PlayerSprite.animation = "flash3"
			
			
			$AnimatedSprite2D2/Area2D.set_collision_mask_value(2, true)
			$AnimatedSprite2D.hide()
			position.y -= 200
			position.x += 200
			$AnimatedSprite2D2.rotation = 7*PI/4
			$AnimatedSprite2D2.position.x = -88
			$AnimatedSprite2D2.position.y = 100
			
			flash_attack_end()
		
		elif dash_direction == -3:
			self.set_physics_process(false)
			attack_in_progress = true
			$AnimatedSprite2D.animation = "flash1"
			$PlayerSprite.animation = "flash1"
			await get_tree().create_timer(0.4).timeout
			$AnimatedSprite2D.animation = "flash3"
			$PlayerSprite.animation = "flash3"
			
			
			$AnimatedSprite2D2/Area2D.set_collision_mask_value(2, true)
			$AnimatedSprite2D.hide()
			position.y += 200
			position.x += 200
			$AnimatedSprite2D2.rotation = PI/4
			$AnimatedSprite2D2.position.x = -88
			$AnimatedSprite2D2.position.y = -70
			
			flash_attack_end()
			
		elif dash_direction == 4:
			self.set_physics_process(false)
			attack_in_progress = true
			$AnimatedSprite2D.animation = "flash1"
			$PlayerSprite.animation = "flash1"
			await get_tree().create_timer(0.4).timeout
			$AnimatedSprite2D.animation = "flash3"
			$PlayerSprite.animation = "flash3"
			
			
			$AnimatedSprite2D2/Area2D.set_collision_mask_value(2, true)
			$AnimatedSprite2D.hide()
			position.y -= 200
			position.x -= 200
			$AnimatedSprite2D2.rotation = 5*PI/4
			$AnimatedSprite2D2.position.x = 60
			$AnimatedSprite2D2.position.y = 100
			
			flash_attack_end()
			
		elif dash_direction == -4:
			self.set_physics_process(false)
			attack_in_progress = true
			$AnimatedSprite2D.animation = "flash1"
			$PlayerSprite.animation = "flash1"
			await get_tree().create_timer(0.4).timeout
			$AnimatedSprite2D.animation = "flash3"
			$PlayerSprite.animation = "flash3"
			
			
			$AnimatedSprite2D2/Area2D.set_collision_mask_value(2, true)
			$AnimatedSprite2D.hide()
			position.y += 200
			position.x -= 200
			$AnimatedSprite2D2.rotation = 3*PI/4
			$AnimatedSprite2D2.position.x = 50
			$AnimatedSprite2D2.position.y = -70
			
			flash_attack_end()
	else:
		print("hey4")
		dash_obstructed.emit()
		dash_blocked = true
		
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

func flash_attack_start():
	self.set_physics_process(false)
	attack_in_progress = true
	$AnimatedSprite2D.animation = "flash1"
	await get_tree().create_timer(0.4).timeout
	$AnimatedSprite2D.animation = "flash3"

func flash_attack_end():
	$AnimatedSprite2D2.show()
	$AnimatedSprite2D2.play()
	$AnimatedSprite2D2.animation = "flash2"
	$AnimatedSprite2D2/Area2D.show()
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D2.hide()
	$AnimatedSprite2D2/Area2D.hide()
	await get_tree().create_timer(0.01).timeout
	#$AnimatedSprite2D.show()
	$PlayerSprite.show()
	$DashTimer.start()
	is_dashing = true
