class_name GunHitbox
extends Area2D

@export var resource: GunResource

@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	collision_shape_2d.shape = resource.hit_shape
	collision_shape_2d.position = resource.offset
	
	area_entered.connect(func(area):
		if area is Hurtbox:
			var dir = global_position.direction_to(area.global_position)
			area.damage(resource.damage, dir * resource.knockback)
	)

	get_tree().create_timer(resource.lifetime).timeout.connect(func(): queue_free())
