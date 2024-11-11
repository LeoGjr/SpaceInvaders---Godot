extends Area2D

const VEL = 100

var prev_shot = preload("res://Scenes/ship_shot.tscn")

var left
var right
var laser
var dir = 0
var prev_laser = false
var alive = true
signal destroyed
signal respawn
func _ready():
	hide()
	#set_process(true)

func _process(delta):
	dir = 0
	right = Input.is_action_pressed("ui_right")
	left = Input.is_action_pressed("ui_left")
	laser = Input.is_action_pressed("disparo")
	
	if right:
		dir += 1
		
	if left:
		dir -= 1
		
	translate(Vector2(1,0) * VEL * dir * delta)
	set_global_pos(Vector2(clamp(get_global_pos().x, 7, Globals.get("display/width") -7), get_global_pos().y))
#	if get_global_pos().x < 7:
#		set_global_pos(Vector2(7, get_global_pos().y))
#		
#	if get_global_pos().x > 173:
#		set_global_pos(Vector2(173, get_global_pos().y))
		
	if laser and not prev_laser and get_tree().get_nodes_in_group("ship_shot").size() == 0:
		get_node("sample").play("ship_shoot")
		var shot = prev_shot.instance()
		get_parent().add_child(shot)
		shot.set_global_pos(get_global_pos())
		
	prev_laser = laser
	
	
	
func start():
	show()
	set_process(true)
	
func disable():
	hide()
	set_process(false)
	alive = false


func destroy(obj):
	if alive:
		get_node("sample").play("ship_explosion")
		alive = false
		set_process(false)
		emit_signal("destroyed")
		get_node("anim").play("explode")
		yield(get_node("anim"), "finished")
		emit_signal("respawn")
		set_process(true)
		alive = true
		get_node("sprite").set_frame(0)