extends Area2D

var air_strike_damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_collision_mask_value(1, false)
	self.set_collision_mask_value(2, false)
	self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area is Dummy:
		var dummy: Dummy = area as Dummy
		dummy.take_damage(air_strike_damage)
		dummy.update_health()
		self.set_collision_mask_value(1, false)
		self.set_collision_mask_value(2, false)

func _on_body_entered(body):
	if body is Player:
		pass
	elif body is Mushroom:
		var mushroom: Mushroom = body as Mushroom
		mushroom.take_damage(air_strike_damage)
		mushroom.update_health()
		self.set_collision_mask_value(1, false)
		self.set_collision_mask_value(2, false)
