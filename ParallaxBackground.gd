extends ParallaxBackground

@export var Cloud_Speed = -15

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sky.motion_offset.x += Cloud_Speed * delta
	$Sky2.motion_offset.x += Cloud_Speed * delta
	$Sky3.motion_offset.x += Cloud_Speed * delta
	$Sky4.motion_offset.x += Cloud_Speed * delta
	$Sky5.motion_offset.x += Cloud_Speed * delta
	$Sky6.motion_offset.x += Cloud_Speed * delta
	$Sky7.motion_offset.x += Cloud_Speed * delta
	$Sky8.motion_offset.x += Cloud_Speed * delta
	$Sky9.motion_offset.x += Cloud_Speed * delta
	$Sky10.motion_offset.x += Cloud_Speed * delta

