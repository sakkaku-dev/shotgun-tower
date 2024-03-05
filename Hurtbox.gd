class_name Hurtbox
extends Area2D

signal hit(dmg, knockback)

@export var health := -1

func damage(dmg: int, knockback: Vector2):
	hit.emit(dmg, knockback)
	
	if health > 0:
		health -= dmg
		return health <= 0
	
	return false
