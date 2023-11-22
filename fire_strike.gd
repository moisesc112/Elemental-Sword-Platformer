extends Area2D

class_name fire_strike

var SPEED = 100
var height = 72
var radius = 20
var damage = 2



func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta
	$AnimatedSprite2D.play("strike",1)
	await get_tree().create_timer(0.5).timeout
	destroy()


func destroy():
	queue_free()


func _on_area_entered(area):
	if area is Dummy:
		var dummy: Dummy = area as Dummy
		dummy.take_damage(damage)
		dummy.update_health()
		destroy()
#	elif area is Player:
#		pass
#	else:
#		destroy()

func _on_body_entered(body):
	if body is Player:
		pass
	elif body is Mushroom:
		var mushroom: Mushroom = body as Mushroom
		mushroom.take_damage(damage)
		mushroom.update_health()
		destroy()
	else:
		destroy()


func _on_animated_sprite_2d_frame_changed():
	height = 72
	radius = 20
	
	if $AnimatedSprite2D.frame == 1:
		$CollisionShape2D.shape.height = 58
		$CollisionShape2D.shape.radius = 19
	if $AnimatedSprite2D.frame == 2:
		$CollisionShape2D.shape.height = 40
		$CollisionShape2D.shape.radius = 18




