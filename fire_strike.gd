extends Area2D

class_name fire_strike

var SPEED = 100
#var height = 72
#var radius = 20
var damage = 2
var impact_happened = false



func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta
	#$AnimatedSprite2D.play("fire_missle",1)
	$AnimatedSprite2D.play("fire_missle")
	#$FireTravelSound.play()
	await get_tree().create_timer(0.7).timeout
	$AnimatedSprite2D.hide()
	self.set_collision_mask_value(1, false)
	self.set_collision_mask_value(2, false)
	if !impact_happened:
		destroy()
	else:
		pass

func destroy():
	queue_free()


func _on_area_entered(area):
	if area is Dummy:
		impact_happened = true
		var dummy: Dummy = area as Dummy
		dummy.take_damage(damage)
		dummy.update_health()
		$FireImpactSound.play()
		$FireTravelSound.stop()
		$AnimatedSprite2D.hide()
		#$CollisionShape2D.disabled = true
		self.set_collision_mask_value(1, false)
		self.set_collision_mask_value(2, false)
		SPEED = 0
		$ImpactSprite.show()
		$ImpactSprite.play()
		await get_tree().create_timer(0.3).timeout
		destroy()
#	elif area is Player:
#		pass
#	else:
#		destroy()

func _on_body_entered(body):
	if body is Player:
		pass
	elif body is Mushroom:
		impact_happened = true
		var mushroom: Mushroom = body as Mushroom
		mushroom.take_damage(damage)
		mushroom.update_health()
		$FireImpactSound.play()
		$FireTravelSound.stop()
		$AnimatedSprite2D.hide()
		#$CollisionShape2D.disabled = true
		self.set_collision_mask_value(1, false)
		self.set_collision_mask_value(2, false)
		SPEED = 0
		$ImpactSprite.show()
		$ImpactSprite.play()
		await get_tree().create_timer(0.3).timeout
		destroy()
	elif body is LavaBoss:
		impact_happened = true
		var lava_boss: LavaBoss = body as LavaBoss
		lava_boss.take_damage(damage)
		lava_boss.update_health()
		$FireImpactSound.play()
		$FireTravelSound.stop()
		$AnimatedSprite2D.hide()
		#$CollisionShape2D.disabled = true
		self.set_collision_mask_value(1, false)
		self.set_collision_mask_value(2, false)
		SPEED = 0
		$ImpactSprite.show()
		$ImpactSprite.play()
		await get_tree().create_timer(0.3).timeout
		destroy()
	elif body is Skull:
		impact_happened = true
		var fire_skull: Skull = body as Skull
		fire_skull.take_damage(damage)
		fire_skull.update_health()
		$FireImpactSound.play()
		$FireTravelSound.stop()
		$AnimatedSprite2D.hide()
		#$CollisionShape2D.disabled = true
		self.set_collision_mask_value(1, false)
		self.set_collision_mask_value(2, false)
		SPEED = 0
		$ImpactSprite.show()
		$ImpactSprite.play()
		await get_tree().create_timer(0.3).timeout
		destroy()
	else:
		$FireImpactSound.play()
		$FireTravelSound.stop()
		impact_happened = true
		$AnimatedSprite2D.hide()
		#$CollisionShape2D.disabled = true
		self.set_collision_mask_value(1, false)
		self.set_collision_mask_value(2, false)
		SPEED = 0
		$ImpactSprite.show()
		$ImpactSprite.play()
		await get_tree().create_timer(0.3).timeout
		destroy()


func _on_animated_sprite_2d_frame_changed():
#	height = 72
#	radius = 20
#
#	if $AnimatedSprite2D.frame == 1:
#		$CollisionShape2D.shape.height = 58
#		$CollisionShape2D.shape.radius = 19
#	if $AnimatedSprite2D.frame == 2:
#		$CollisionShape2D.shape.height = 40
#		$CollisionShape2D.shape.radius = 18
	pass
