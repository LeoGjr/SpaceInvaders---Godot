tool
extends Node2D

export(Texture) var textura 
export var lifes = 3 setget set_lifes

func _draw():
	for l in range(lifes):
		draw_texture_rect_region(textura, Rect2(l * 16, 0, 15, 8), Rect2(0, 0, 15, 8), Color(1,1,1,1), false)
		
func set_lifes(val):
	lifes = val
	update()