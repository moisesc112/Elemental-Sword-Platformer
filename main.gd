extends Node

@export var dummy_scene: PackedScene
@export var mushroom_scene: PackedScene

var dummy
var kill_score
var dummy_hp
var mushroom_1
var mushroom_1_hp
var mushroom_2
var mushroom_2_hp

# Called when the node ente	rs the scene tree for the first time.
func _ready():
	#new_game()
	$ui/DashObstructed.hide()
	$StartMusic/AudioStreamPlayer2D.play()
	$StartMusic.make_current()
	pass


func new_game():
	#await get_tree().create_timer(0.1).timeout
	$StartMusic/AudioStreamPlayer2D.stop()
	$Musashi.start($StartPosition.position)
	$Musashi.heal()
	$ui/Skills.show()
	$TileMap.show()
	$ParallaxBackground.show()
	$LavaLevelMusic/AudioStreamPlayer2D.play()
	$LavaLevelMusic.is_current()
	#$DashObstructed.hide()

	await get_tree().create_timer(0.1).timeout


	mushroom_1 = mushroom_scene.instantiate()
	var mushroom_1_spawn_location = $Mushroom1Location.position
	mushroom_1.position = mushroom_1_spawn_location
	mushroom_1_hp = mushroom_1.hp
	add_child(mushroom_1)
	mushroom_1.show()

	mushroom_2 = mushroom_scene.instantiate()
	var mushroom_2_spawn_location = $Mushroom2Location.position
	mushroom_2.position = mushroom_2_spawn_location
	mushroom_2_hp = mushroom_2.hp
	add_child(mushroom_2)
	mushroom_2.show()

	dummy = dummy_scene.instantiate()
	var dummy_spawn_location = $Marker2D.position
	dummy.position = dummy_spawn_location
	dummy_hp = dummy.hp 
	add_child(dummy)
	$ui.show_message("Flow Like Water")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	var viewportWidth = get_viewport().size.x
#	var viewportHeight = get_viewport().size.y
##
#	var scale = viewportWidth / $ParallaxBackground/BackGround.texture.get_size().x
##
##	# Optional: Center the sprite, required only if the sprite's Offset>Centered checkbox is set
#	$ParallaxBackground/BackGround.set_position(Vector2(viewportWidth/2, viewportHeight/2))
##
##	# Set same scale value horizontally/vertically to maintain aspect ratio
##	# If however you don't want to maintain aspect ratio, simply set different
##	# scale along x and y
#	$ParallaxBackground/BackGround.set_scale(Vector2(scale, scale))

	pass
	
func _on_child_exiting_tree(node):
	pass


func _on_musashi_death():
	$ui.show_game_over()
	$ui/Skills.hide()
	$LavaLevelMusic/AudioStreamPlayer2D.stop()
	$GameOverMusic.make_current()
	$GameOverMusic/AudioStreamPlayer2D.play()
	await get_tree().create_timer(2).timeout
	$StartMusic.make_current()
	$StartMusic/AudioStreamPlayer2D.play()
	
	if is_instance_valid(dummy): 
		dummy.queue_free()
	else:
		pass
	if is_instance_valid(mushroom_1):
		mushroom_1.queue_free()
	else:
		pass
	if is_instance_valid(mushroom_2):
		mushroom_2.queue_free()
	else:
		pass

func _on_area_2d_child_entered_tree(node):
	$TileMap.hide()
	$ParallaxBackground.hide()


func _on_fall_zone_body_entered(body):
	if get_node("Musashi").hp > 0:
		if body is Player:
			var player: Player = body as Player
			var fall_damage = 5
			player.take_damage(fall_damage)
			player.update_health()


func _on_musashi_dash_obstructed():
	$ui/DashObstructed.show()
	$DashObstructedTimer.start()


func _on_dash_obstructed_timer_timeout():
	$ui/DashObstructed.hide()
