extends Area2D

var hits = 0

func destroy(obj):
	hits += 1
	if hits > 5:
		queue_free()
	get_node("sprite").set_frame(hits)