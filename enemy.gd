extends CharacterBody2D

@export var dir := Vector2.RIGHT
@export var speed := 100
@export var accel := 600

@onready var sprite_2d = $Sprite2D
@onready var ray_cast_2d = $Sprite2D/RayCast2D
@onready var hurtbox = $Hurtbox

func _ready():
	hurtbox.hit.connect(func(dmg, knockback):
		velocity += knockback
	)

func _physics_process(delta):
	velocity.x = move_toward(velocity.x, dir.x * speed, delta * accel)
	velocity += Vector2.DOWN * 50
	move_and_slide()
	
	if is_on_wall() or is_on_floor() and not ray_cast_2d.is_colliding():
		dir = -dir
		sprite_2d.scale.x *= -1
