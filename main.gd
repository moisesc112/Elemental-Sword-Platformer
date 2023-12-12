extends Node

@export var dummy_scene: PackedScene
@export var mushroom_scene: PackedScene
@export var lava_boss_scene: PackedScene

var dummy
var kill_score
var dummy_hp
var mushroom_1
var mushroom_1_hp
var mushroom_2
var mushroom_2_hp
#var lava_boss
var lava_boss_hp
@onready var lava_boss = $LavaBoss
@onready var lava_boss_healthbar = $ui/BossHealthBar
var music_counter 

# Called when the node ente	rs the scene tree for the first time.
func _ready():
	#new_game()
	$ui/DashObstructed.hide()
	$ui/Heart1.hide()
	$ui/Heart2.hide()
	$ui/Heart3.hide()
	$ui/Heart4.hide()
	$ui/Heart5.hide()
	$StartMusic/AudioStreamPlayer2D.play()
	$StartMusic.make_current()
	#lava_boss_healthbar.visible = false
	lava_boss_healthbar.hide()
	pass


func new_game():
	#await get_tree().create_timer(0.1).timeout
	$StartMusic/AudioStreamPlayer2D.stop()
	$Musashi.start($TestPosition.position)
	$Musashi.heal()
	lava_boss.heal()
	lava_boss.update_health()
	#lava_boss_healthbar.visible = false
	#lava_boss_healthbar.value = lava_boss.hp
	$ui/Skills.show()
	$TileMap.show()
	$ParallaxBackground.show()
	$LavaLevelMusic/AudioStreamPlayer2D.play()
	$LavaLevelMusic.is_current()
	#$DashObstructed.hide()
	$ui/Heart1.show()
	$ui/Heart2.show()
	$ui/Heart3.show()
	$ui/Heart4.show()
	$ui/Heart5.show()
	$ui/Heart5.frame = 0
	$ui/Heart4.frame = 0
	$ui/Heart3.frame = 0
	$ui/Heart2.frame = 0
	$ui/Heart1.frame = 0
	music_counter = 0
	$LavaBall.show()
	$LavaBall2.show()
	$LavaBall3.show()
	$LavaBall4.show()
	#$FireSkull.show()


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
	
#	lava_boss = lava_boss_scene.instantiate()
#	var lava_boss_spawn_location = $LavaBossLocation.position
#	lava_boss.position = lava_boss_spawn_location
#	lava_boss_hp = lava_boss.hp
#	add_child(lava_boss)
#	lava_boss.show()
	#lava_boss.instantiate()
	if not is_instance_valid(lava_boss):	
		self.add_child(lava_boss)

	#lava_boss.hp = 5
	
	dummy = dummy_scene.instantiate()
	var dummy_spawn_location = $Marker2D.position
	dummy.position = dummy_spawn_location
	dummy_hp = dummy.hp 
	add_child(dummy)
	$ui.show_message("Go Forth")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node("Musashi").hp < 5 and get_node("Musashi").hp >= 0:
		var heart = "ui/Heart" + str(get_node("Musashi").hp + 1)
		get_node(heart).frame = 2
#	if get_node("Musashi").hp == 4:
#		get_node("ui/Heart5").frame = 2
#	elif get_node("Musashi").hp == 3:
#		get_node("ui/Heart4").frame = 2
#	elif get_node("Musashi").hp == 2:
#		$ui/Heart3.frame = 2
#	elif get_node("Musashi").hp == 1:
#		$ui/Heart2.frame = 2 
func _on_child_exiting_tree(node):
	pass


func _on_musashi_death():
	$ui.show_game_over()
	$ui/Skills.hide()
	$LavaLevelMusic/AudioStreamPlayer2D.stop()
	if music_counter > 0:
		$BossMusic/AudioStreamPlayer2D.stop()
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
	if is_instance_valid(lava_boss):
		#lava_boss.queue_free()
		self.remove_child(lava_boss)
		lava_boss_healthbar.hide()
	else:
		pass
	#self.remove_child(lava_boss)
	#lava_boss_healthbar.hide()
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
			$ui/Heart5.frame = 2
			$ui/Heart4.frame = 2
			$ui/Heart3.frame = 2
			$ui/Heart2.frame = 2
			$ui/Heart1.frame = 2


func _on_musashi_dash_obstructed():
	$ui/DashObstructed.show()
	$DashObstructedTimer.start()


func _on_dash_obstructed_timer_timeout():
	$ui/DashObstructed.hide()


func _on_lava_boss_lava_boss_death():
	self.remove_child(lava_boss)


func _on_lava_boss_lava_boss_music():
	#lava_boss_healthbar.visible = true
	lava_boss_healthbar.show()
	if music_counter <= 2:
		music_counter += 1
		if music_counter == 1:
			$LavaLevelMusic/AudioStreamPlayer2D.stop()
			$BossMusic.make_current()
			$BossMusic/AudioStreamPlayer2D.play()
			#lava_boss_healthbar.visible = true
			lava_boss_healthbar.show()
			
func _on_lava_boss_lava_boss_healthbar():
	lava_boss_healthbar.value = lava_boss.hp
	
