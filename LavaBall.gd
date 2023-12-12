extends Area2D

var SPEED = 0
var gravity_mps = gravity/100
var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2.UP
#	global_position += SPEED * direction * delta
	global_position += SPEED * direction * delta 
	if SPEED >= -117.6:
		$AnimatedSprite2D.flip_v = false
		SPEED -= gravity_mps
	elif SPEED < -117.6 and global_position.y < 700:
		$AnimatedSprite2D.flip_v = true
		global_position += SPEED * direction * delta 
		SPEED = -127.4
	elif global_position.y >= 700:
		$AnimatedSprite2D.flip_v = false
		SPEED = 1000
		
#	if global_position.y > 600:
#		SPEED = 100
	#print(SPEED)


func _on_body_entered(body):
	if body is Player:
		var player: Player = body as Player
		if player.hp > 1:
			player.take_damage(damage)
			player.update_health()
