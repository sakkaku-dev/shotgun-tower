extends Node

@export var cast: RayCast2D

func _process(delta):
	var dir = cast.global_position.direction_to(cast.get_global_mouse_position())
	cast.global_rotation = Vector2.DOWN.angle_to(dir)

func fire(player: Player):
	if not cast.is_colliding(): return
	
	player.grappling_point = cast.get_collision_point()
	#player.swing_dist = player.global_position.distance_to(player.grappling_point)

func release(player: Player):
	player.grappling_point = null
