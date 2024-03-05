extends Node2D

@export var maps: Array[PackedScene]

@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D

var next_position := Vector2.ZERO

func _ready():
	visible_on_screen_notifier_2d.screen_entered.connect(add_random_map)

	while visible_on_screen_notifier_2d.is_on_screen():
		add_random_map()

func add_random_map():
	var map = maps.pick_random()
	var node = map.instantiate() as TileMap
	
	node.global_position = next_position
	add_child(node)
	
	next_position.y -= node.get_used_rect().size.y * node.tile_set.tile_size.y
	visible_on_screen_notifier_2d.global_position = next_position
