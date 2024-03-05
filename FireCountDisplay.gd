extends HBoxContainer

@export var shotgun: Shotgun
@export var tex: Texture2D
@export var tex_size := Vector2(20, 20)

func _ready():
	shotgun.update_fire_count.connect(func(c): update_count(c))
	update_count(shotgun.current_fire_count)

func update_count(c: int):
	var current_count = get_child_count()
	var diff = c - current_count
	
	if diff < 0:
		while diff < 0:
			remove_child(get_child(0))
			diff += 1
	else:
		for i in range(diff):
			var rect = TextureRect.new()
			rect.texture = tex
			rect.custom_minimum_size = tex_size
			rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
			rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			add_child(rect)
