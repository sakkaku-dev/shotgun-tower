extends Node

@export var shotgun_knockback := 400
@export var shotgun_knockback_in_air := 600
@export var fire_rate: FireRate
@export var resource: GunResource

func fire(player: Player):
	if not fire_rate.can_fire():
		return
	
	var aim = player.global_position.direction_to(player.get_global_mouse_position())
	player.velocity += -aim * (shotgun_knockback if player.koyori.can_jump() else shotgun_knockback_in_air)
	player.fire_shot(resource)
	fire_rate.fire()

func release(player: Player):
	pass
