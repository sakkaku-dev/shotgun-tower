class_name FireRate
extends Timer

func can_fire():
	return is_stopped()

func fire():
	start()
