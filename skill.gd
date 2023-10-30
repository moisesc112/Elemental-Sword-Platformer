extends ColorRect

@export
var skill_image: CompressedTexture2D
@export
var skill_cooldown: int

signal skill_done

# Called when the node enters the scene tree for the first time.
func _ready():
	$SkillImage.texture = skill_image
	$SkillTimer.wait_time = skill_cooldown

func activate_skill():
	$SkillImage.modulate = Color(.39, .39, .39)
	$SkillTimer.start()


func _on_skill_timer_timeout():
	$SkillImage.modulate = Color(1, 1, 1)
	skill_done.emit()
