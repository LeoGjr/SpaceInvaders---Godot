extends Node

const letters = "ABCDEFGHIJKLMNOPQRSTUVXWYZ0123456789_#$* "
var index = 0
var letter = 0
signal finished(name)
func _ready():
	set_process_input(true)
	pass

func _input(event):
	var alterou = false
	if event.is_action_pressed("ui_right") and not event.is_echo():
		index += 1
		alterou = true
		
	if event.is_action_pressed("ui_left") and not event.is_echo():
		index -= 1
		alterou = true

	if alterou:
		if index < 0:
			index = letters.length() - 1
		elif index >= letters.length():
			index = 0
		get_node("container").get_child(letter).set_text(letters[index])
		
	if event.is_action_pressed("disparo") and not event.is_echo():
		get_node("container").get_child(letter).set_opacity(1)
		index = 0
		letter += 1
		if letter > 2:
			get_node("timer").stop()
			set_process_input(false)
			var name = get_node("container").get_child(0).get_text() + get_node("container").get_child(1).get_text() + get_node("container").get_child(2).get_text()
			emit_signal("finished", name)

func _on_timer_timeout():
	if get_node("container").get_child(letter).get_opacity() > 0:
		get_node("container").get_child(letter).set_opacity(0)
	else:
		get_node("container").get_child(letter).set_opacity(1)
