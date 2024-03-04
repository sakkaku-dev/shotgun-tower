extends StaticBody2D

@onready var shard_emitter = $Sprite2D/ShardEmitter
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	shard_emitter.shattering.connect(func(): collision_shape_2d.set_deferred("disabled", true))

func _on_hurtbox_hit(dmg, knockback):
	shard_emitter.shatter()
