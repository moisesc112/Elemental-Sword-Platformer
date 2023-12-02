extends ParallaxBackground

@export var Cloud_Speed = -10
@export var Sky_Speed = -5
@export var Sea_Speed = -15
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sea.motion_offset.x += Sea_Speed * delta
	$Sky.motion_offset.x += Sky_Speed * delta
	$Clouds.motion_offset.x += Cloud_Speed * delta
	$Clouds2.motion_offset.x += Cloud_Speed * delta
	#$Ground.motion_offset.x += Cloud_Speed * delta
