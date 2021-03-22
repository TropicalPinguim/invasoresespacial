extends HBoxContainer

var pos = "1st" setget set_pos;
var nome = "AAA" setget set_nome;
var pontos = "22222" setget set_pontos;
var color = Color(1,1,1,1) setget set_color;

func set_pos(valor):
	pos = valor
	$pos.set_text(str(valor))

func set_nome(valor):
	nome = valor
	$nome.set_text(str(valor))
	
func set_pontos(valor):
	pontos = valor
	$pontos.set_text(str(valor))

func set_color(valor):
	color = valor;
	$pos.set("custom_colors/font_color", color);
	$nome.set("custom_colors/font_color", color);
	$pontos.set("custom_colors/font_color", color);
