# TODO: These skills need to be brought in/managed somewhere else
extends ColorRect

signal skill_activated(skill_name)
signal skill_completed

var skill_in_progress = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !skill_in_progress:
		if Input.is_action_just_pressed("skill_1"):
			skill_activated.emit("skill_1")
			skill_in_progress = true
			$Skill1.activate_skill()
		if Input.is_action_just_pressed("skill_2"):
			skill_activated.emit("skill_2")
			skill_in_progress = true
			$Skill2.activate_skill()
		if Input.is_action_just_pressed("skill_3"):
			skill_activated.emit("skill_3")
			skill_in_progress = true
			$Skill3.activate_skill()
		if Input.is_action_just_pressed("skill_4"):
			skill_activated.emit("skill_4")
			skill_in_progress = true
			$Skill4.activate_skill()


# TODO: Can we group skills to emit signal?
func _on_skill_1_skill_done():
	skill_completed.emit()
	skill_in_progress = false

func _on_skill_2_skill_done():
	skill_completed.emit()
	skill_in_progress = false

func _on_skill_3_skill_done():
	skill_completed.emit()
	skill_in_progress = false

func _on_skill_4_skill_done():
	skill_completed.emit()
	skill_in_progress = false
