extends Node2D

export(Texture) var textura;
export var vidas = 3 setget set_vidas;

# desenha a  quantidade de vidas na tela
func _draw():
	for v in range(vidas):
		draw_texture_rect_region(textura , 
		Rect2(v * 18,0,15,8),Rect2(0,0,15,8),Color(1,1,1,1),false)

func set_vidas(valor):
	vidas = valor
	update()
