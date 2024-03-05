class_name GunHitbox
extends Area2D

signal shot(has_died)

@export var resource: GunResource

@onready var collision_shape_2d = $CollisionShape2D
@onready var gpu_particles_2d = $GPUParticles2D

var died := false

func _ready():
	collision_shape_2d.shape = resource.hit_shape
	collision_shape_2d.position = resource.offset
	gpu_particles_2d.position = resource.offset
	gpu_particles_2d.emitting = true
	
	area_entered.connect(func(area):
		if area is Hurtbox:
			var dir = global_position.direction_to(area.global_position)
			died = area.damage(resource.damage, dir * resource.knockback)
	)

	get_tree().create_timer(resource.lifetime).timeout.connect(func():
		shot.emit(died)
		queue_free()
	)
