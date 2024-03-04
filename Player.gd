class_name Player
extends CharacterBody2D

enum Gun {
	SHOTGUN,
	GRAPPLE,
}

@export var speed := 200
@export var accel := 1200
@export var jump_force := 600
@export var jump_force_air := 800

@export var swing_move_force := 5

@export var hit_scene: PackedScene

@onready var hand = $Hand
@onready var hurtbox = $Hurtbox
@onready var koyori = $KoyoriTimer
@onready var jump_buffer = $JumpBuffer
@onready var guns := {
	Gun.SHOTGUN: $Guns/Shotgun,
	Gun.GRAPPLE: $Guns/Grapple,
}

var primary = Gun.SHOTGUN
var secondary = Gun.GRAPPLE

var grappling_point
var reduce_swing_dist := 0.0
var swing_dist := 0.0

func _ready():
	jump_buffer.jump.connect(func(): _jump())
	hurtbox.hit.connect(func(dmg, knockback):
		velocity += knockback
	)

func _process(delta):
	var dir = global_position.direction_to(get_global_mouse_position())
	hand.global_rotation = Vector2.RIGHT.angle_to(dir)

func _physics_process(delta):
	var motion_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if grappling_point:
		var dir = global_position.direction_to(grappling_point)
		#velocity = velocity.move_toward(dir * speed, delta * accel)
		
		var current_dist = global_position.distance_to(grappling_point)
		
		# https://stackoverflow.com/questions/75195734/descending-pendulum-motion-in-physics-process
		var gravity_speed = 500
		var air_resistance = -200
		var swing_length = swing_dist - reduce_swing_dist
			
		velocity.y += gravity_speed * delta
		velocity += (velocity.normalized() * air_resistance * delta).limit_length(velocity.length())

		#pendulum motion
		var theta=Vector2.RIGHT.angle_to(grappling_point - global_position) * -1 # angle between local x_axis & pivot point vector 
		var sin_theta=sin(theta)
		var cos_theta=cos(theta)
		velocity.x = velocity.x + velocity.y*sin_theta*cos_theta - velocity.x*cos_theta*cos_theta
		velocity.y = velocity.y + velocity.x*sin_theta*cos_theta - velocity.y*sin_theta*sin_theta

		var tension = clamp(current_dist - swing_length, 0, 1) * gravity_speed
		velocity += dir * tension * delta
		
		velocity.x += motion_x * swing_move_force
	else:
		velocity.x = move_toward(velocity.x, motion_x * speed, delta * accel)
		velocity += Vector2.DOWN * 50

	move_and_slide()

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("jump"):
		if koyori.can_jump():
			_jump()
		else:
			jump_buffer.buffer_jump()
	elif event.is_action_pressed("fire"):
		guns[primary].fire(self)
	elif event.is_action_pressed("secondary_fire"):
		guns[secondary].fire(self)
	elif event.is_action_released("fire"):
		guns[primary].release(self)
	elif event.is_action_released("secondary_fire"):
		guns[secondary].release(self)

func _jump():
	if velocity.y > 0:
		velocity.y = -jump_force
	else:
		velocity.y -= jump_force #if is_on_floor() else jump_force_air

func fire_shot(gun_res: GunResource):
	var node = hit_scene.instantiate()
	node.resource = gun_res
	node.global_position = global_position
	node.global_rotation = Vector2.RIGHT.angle_to(global_position.direction_to(get_global_mouse_position()))
	get_tree().current_scene.add_child(node)
