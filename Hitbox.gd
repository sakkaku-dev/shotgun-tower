class_name Hitbox
extends Area2D

@export var damage := 0
@export var knockback_force := 100

func _ready():
	area_entered.connect(func(area):
		if area is Hurtbox:
			var dir = global_position.direction_to(area.global_position)
			area.damage(damage, dir * knockback_force)
	)
