extends Node2D

@onready var timer = $WaterDashTimer

func start_water_dash(duration):
	timer.wait_time = duration
	timer.start()

func is_water_dashing():
	return !timer.is_stopped()
