extends Area2D

var SPEED = 100
var height = 72
var radius = 20


func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta
	$AnimatedSprite2D.play("strike",1)
	await get_tree().create_timer(0.5).timeout
	destroy()


func destroy():
	queue_free()


func _on_area_entered(_area):
	destroy()


func _on_body_entered(_body):
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




