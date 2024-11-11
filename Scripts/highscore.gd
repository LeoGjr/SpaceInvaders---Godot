extends VBoxContainer

const pre_iten = preload("res://Scenes/score_iten.tscn")
const positions = ["1ST", "2ND", "3RD", "4TH", "5TH", "6TH", "7TH", "8TH", "9TH", "10"]
const colors = ["ff0000","ff7700","ffb900","fdff00","c7ff00","49ff00","00ff5d","00fff3","008dff","0700ff"]
func _ready():
	pass
	#teste()

func teste():
	for a in range(10):
		var item = pre_iten.instance()
		item.pos = positions[a]
		item.name = str(a) + "AA"
		add_child(item)
		get_node("timer").start()
		yield(get_node("timer"), "timeout")
		
func show_highscore(highscore):
	for c in get_children():
		if c extends HBoxContainer:
			c.queue_free()
	var item = pre_iten.instance()
	item.pos = "RANK"
	item.name = "NAME"
	item.score = "SCORE"
	add_child(item)
	var a = 0
	for hs in highscore:
		item = pre_iten.instance()
		item.pos = positions[a]
		item.name = hs.name
		item.score = hs.score
		item.color = Color(colors[a])
		add_child(item)
		get_node("timer").start()
		yield(get_node("timer"), "timeout")
		a += 1