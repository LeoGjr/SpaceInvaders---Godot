extends Area2D

var score = 200
signal destroyed(obj)

func _ready():
	get_node("sample").play("mother_ship")
	get_node("anim").play("default")
	yield(get_node("anim"), "finished")
	queue_free()
func destroy(obj):
	emit_signal("destroyed", self)
	queue_free()