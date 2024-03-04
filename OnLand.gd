extends Node

signal landed()

@export var player: CharacterBody2D

var was_on_floor := false

func _physics_process(delta):
	if not was_on_floor and player.is_on_floor():
		landed.emit()
	
	was_on_floor = player.is_on_floor()
