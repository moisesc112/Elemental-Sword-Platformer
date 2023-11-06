extends Node

@export var dummy_scene: PackedScene

var dummy
var kill_score


# Called when the node enters the scene tree for the first time.
func _ready():
	
	dummy = dummy_scene.instantiate()
	var dummy_spawn_location = $Marker2D.position
	dummy.position = dummy_spawn_location
	add_child(dummy)
	print(dummy.hp)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_child_exiting_tree(node):
	if !$Musashi:
		return
	else:
		$Musashi.victory()
	
