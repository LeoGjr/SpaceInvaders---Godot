extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_node("anim").play("explosion")
	yield(get_node("anim"), "finished")
	queue_free()
