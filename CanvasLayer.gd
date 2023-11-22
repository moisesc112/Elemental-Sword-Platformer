extends CanvasLayer

signal start_game


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
	
func show_game_over():
	show_message("Game Over")
	print("pre timer")
	await $MessageTimer.timeout
	#await get_tree().create_timer(2).timeout
	print("post timer")
	$Message.text = "Look How Infinite You Are"
	$Message.show()
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
