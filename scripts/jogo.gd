extends Node2D


const pontos_vidas_extras = [100,200,300]

var dados = {
	index_vidas_extras = 0,
	pontuacao = 0,
	vidas = 3
}setget set_dados;

signal fim_de_jogo;
signal vitoria;

func _ready():
	
	randomize()
	
	atualizando_pontos() 
	
	$grupo_alienigina.connect("inimigo_destruido", 
	self , "sinal_para_alien_group_de_inimigo_destruido")
	
	$grupo_alienigina.connect("estou_pronto", 
	self , "sinal_para_alien_group_de_estou_pronto")
	
	$grupo_alienigina.connect("terra_dominada", 
	self , "sinal_para_alien_dominou_a_terra")
	
	$grupo_alienigina.connect("vencedor", self , "sinal_de_vitoria")
	
	$navinha.connect("destroido", self, "sinal_de_nave_destroida")
	
	$navinha.connect("renascer", self, "sinal_de_nave_renascida")

func sinal_para_alien_group_de_estou_pronto():
	$navinha.comecar();
	
# Esta funçao, recebe o sinal de quando um inimigo
# é destruido e seu valor, mostrando a pontuaçao na tela.
func sinal_para_alien_group_de_inimigo_destruido(alien):
	dados.pontuacao += alien.pontuacao
	if (dados.index_vidas_extras < pontos_vidas_extras.size()  and 
	dados.pontuacao >= pontos_vidas_extras[dados.index_vidas_extras]):
		dados.vidas += 1;
		atualizando_vidas();
		dados.index_vidas_extras += 1;
	atualizando_pontos()

func sinal_de_vitoria():
	emit_signal("vitoria");
	
func sinal_para_alien_dominou_a_terra():
	fim_de_jogo();

func atualizando_pontos():
	$HUD/pontos.set_text(str(dados.pontuacao));
	
func atualizando_vidas():
	$HUD/vidas.set_vidas(dados.vidas);
	
func atualizando_HUD():
	atualizando_pontos()
	atualizando_vidas()
	
# esta função, manda um sinal de nave destruida,
# atualiza a variavel vida, e atualiza o desenho da vida.
func sinal_de_nave_destroida():
	$grupo_alienigina.para_tudo();
	dados.vidas -= 1;
	atualizando_vidas();
	get_tree().call_group("tipo_inimigo", "destruir");
	
func sinal_de_nave_renascida():
	if dados.vidas <= 0:
		fim_de_jogo();
	else:
		$grupo_alienigina.volta_tudo()
		
func fim_de_jogo():
	$grupo_alienigina.para_tudo();
	$navinha.desabitar();
	$navinha.queue_free();
	emit_signal("fim_de_jogo");
	
func set_dados(valor):
	dados = valor;
	atualizando_HUD()
