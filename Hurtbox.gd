class_name Hurtbox
extends Area2D

signal hit(dmg, knockback)

func damage(dmg: int, knockback: Vector2):
	hit.emit(dmg, knockback)
