class_name Shotgun
extends Node

signal update_fire_count(count)

@export var shotgun_knockback := 800
@export var shotgun_knockback_in_air := 800
@export var hit_multiplier := 2.0
@export var resource: GunResource

@export var player: CharacterBody2D
@export var fire_count := 1

@onready var current_fire_count := fire_count:
	set(v):
		current_fire_count = v
		update_fire_count.emit(v)

func fire(_p: Player):
	if current_fire_count <= 0:
		return
	
	self.current_fire_count -= 1
	
	var aim = player.global_position.direction_to(player.get_global_mouse_position())
	var recoil = -aim * (shotgun_knockback if player.koyori.can_jump() else shotgun_knockback_in_air)
	
	#if player.velocity.y > 0:
		#player.velocity.y = 0
	player.velocity = recoil
	
	var has_died = await player.fire_shot(resource)
	if has_died:
		var actual_recoil = recoil * hit_multiplier
		var diff = actual_recoil - recoil
		player.velocity += diff
		self.current_fire_count += 1
	

func release(player: Player):
	pass

func _physics_process(delta):
	if player.is_on_floor() and current_fire_count != fire_count:
		self.current_fire_count = fire_count
