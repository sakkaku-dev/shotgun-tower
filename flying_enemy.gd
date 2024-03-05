extends CharacterBody2D

signal died()

@export var distance := 10
@export var speed := 20

@onready var center := global_position
@onready var hurtbox = $Hurtbox

var dir := Vector2.UP

func _ready():
	hurtbox.hit.connect(func(dmg, knockback): 
		died.emit()
		queue_free()
	)

func _physics_process(delta):
	velocity = dir * speed
	move_and_slide()
	
	if dir.y > 0 and global_position.y > center.y + distance:
		dir.y = -1
	elif dir.y < 0 and global_position.y < center.y - distance:
		dir.y = 1
	
