extends Area2D

class_name Dummy
signal dummy_death

var hp = 5
var touch_damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
	dummy_death.emit()
	queue_free()
	print("bye dummy")
	#Player.victory()

func _on_area_entered(area):
	pass

func _on_body_entered(body):
	if body is Player:
		var player: Player = body as Player
		player.take_damage(touch_damage)
		player.update_health()
		
	
