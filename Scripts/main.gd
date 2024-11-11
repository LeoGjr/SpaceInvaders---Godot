extends Node
const highscore_file = "user://highscore_file"
const config_file = "user://config_file"
var pre_name_selector = preload("res://Scenes/name_selector.tscn")
var pre_game = preload("res://Scenes/game.tscn")
var game
var password = [52, 36, 78, 101, 75, 98, 120, 87, 61, 111, 37, 85]
var config = ConfigFile.new()
var highscore
var play_config_sound = true
var highscores = [
	{name = "AAA", score = 1000},
	{name = "BBB", score = 900},
	{name = "CCC", score = 800},
	{name = "DDD", score = 700},
	{name = "EEE", score = 600},
	{name = "FFF", score = 500},
	{name = "GGG", score = 400},
	{name = "HHH", score = 300},
	{name = "III", score = 200},
	{name = "JJJ", score = 100}
	
]

func _ready():
	load_config()
	get_node("stream").play()
	load_score()
	get_node("highscore").show_highscore(highscores)
	pass
func new_game():
	if game != null:
		game.queue_free()
	game = pre_game.instance()
	get_node("game_node").add_child(game)
	game.connect("game_over", self, "on_game_over")
	game.connect("victory", self, "on_victory")

func _on_Button_pressed():
	get_node("btn_button").hide()
	get_node("highscore").hide()
	get_node("ColorFrame").hide()
	get_node("title").hide()
	get_node("btn_options").hide()
	new_game()

func on_game_over():
	highscore = null
	for hs in highscores:
		if game.data.score > hs.score :
			highscore = hs
			break
			
	if highscore != null:
		var name_selector = pre_name_selector.instance()
		add_child(name_selector)
		name_selector.connect("finished", self, "on_name_selector_finished")
		yield(name_selector, "finished")
		name_selector.queue_free()
		save_highscore()
		
	
	get_node("btn_button").show()
	get_node("highscore").show()
	get_node("ColorFrame").show()
	get_node("btn_options").show()
	get_node("highscore").show_highscore(highscores)
	
	
func on_victory():
	var data = game.data
	new_game()
	game.data = data
	
func on_name_selector_finished(val):
	var index = highscores.find(highscore)
	highscores.insert(index, {name = val, score = game.data.score})
	highscores.resize(10)
	
func save_highscore():
	var file = File.new()
	var result = file.open_encrypted_with_pass(highscore_file, file.WRITE, RawArray(password).get_string_from_utf8())
	if result == OK:
		var store_highscore = {
			highscores = highscores
		}
		file.store_string(store_highscore.to_json())
		file.close()
		
func load_score():
	var file = File.new()
	var result = file.open_encrypted_with_pass(highscore_file, file.READ, RawArray(password).get_string_from_utf8())
	if result == OK:
		var text = file.get_as_text()
		var store_highscore = {}
		store_highscore.parse_json(text)
		highscores = store_highscore.highscores
		file.close()

func _on_btn_options_pressed():
	get_node("Tween_camera").interpolate_property(get_node("camera"), "transform/pos", Vector2(), Vector2(-180, 0), 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	get_node("Tween_camera").start()


func _on_btn_ok_pressed():
	get_node("Tween_camera").interpolate_property(get_node("camera"), "transform/pos", Vector2(-180, 0), Vector2(0, 0), 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	get_node("Tween_camera").start()


func _on_volume_control_value_changed( value ):
	AudioServer.set_fx_global_volume_scale(value)
	if play_config_sound:
		get_node("options/SamplePlayer").play("alien_shot")
		get_node("config_timer").start()


func _on_volume_control1_value_changed( value ):
	AudioServer.set_stream_global_volume_scale(value)
	if play_config_sound:
		get_node("config_timer").start()
	
	
func save_config():
	config.set_value("audio", "fx", AudioServer.get_fx_global_volume_scale())
	config.set_value("audio", "music", AudioServer.get_stream_global_volume_scale())
	config.save(config_file)

func load_config():
	if config.load(config_file) == OK:
		play_config_sound = false
		get_node("options/volume_control").set_value(config.get_value("audio", "fx"))
		get_node("options/volume_control1").set_value(config.get_value("audio", "music"))
		play_config_sound = true

func _on_config_timer_timeout():
	save_config()
