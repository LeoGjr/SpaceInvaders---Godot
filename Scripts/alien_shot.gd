extends Area2D

const vel = 120
const dir = Vector2(0,1)

func _ready():
	add_to_group("alien_shot")
	set_process(true)
	
	
func _process(delta):
	translate(dir * vel * delta)
	if get_global_pos().y > 270:
		destroy(self)
	
func destroy(obj):
	queue_free()


func _on_alien_shot_area_enter( area ):
	if area.has_method("destroy"):
		area.destroy(self)
		destroy(self)
