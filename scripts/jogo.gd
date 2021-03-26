extends Node2D


const pontos_vidas_extras = [100,200,300]

#-------------------------- declarando variaveis ------------------------------#
var dados = {
	index_vidas_extras = 0,
	pontuacao = 0,
	vidas = 3
}setget set_dados;

#--------------------------- declarando sinais --------------------------------#
signal fim_de_jogo;
signal vitoria;

func _ready():
	
	randomize()
	
	atualizando_pontos() 
	# se conecta com os scripts navinha.gd, grupo_alienigina.gd 
	# e usa dos sinais emitidos (inimigo_destruido, estou_pronto, 
	# terra_dominada, vencedor, destruido, renascer) para criar
	# funções dentro desse script.
	$grupo_alienigina.connect("inimigo_destruido", 
	self , "sinal_para_alien_group_de_inimigo_destruido")
	
	$grupo_alienigina.connect("estou_pronto", 
	self , "sinal_para_alien_group_de_estou_pronto")

	$grupo_alienigina.connect("terra_dominada", 
	self , "sinal_para_alien_dominou_a_terra")

	$grupo_alienigina.connect("vencedor", self , "sinal_de_vitoria")
	
	$navinha.connect("destroido", self, "sinal_de_nave_destroida")
	
	$navinha.connect("renascer", self, "sinal_de_nave_renascida")
	
	
#----------------------- SINAIS DE VITORIA/GAME OVER --------------------------#


func sinal_para_alien_group_de_estou_pronto():
	# Essa função acessa o script da navinha,
	# fazendo aparecer a nave controlada pelo 
	# jogador e dando início a movimentação.
	$navinha.comecar();
	
	
func sinal_para_alien_group_de_inimigo_destruido(alien):
	# A variável pontuação declarada nesse script, 
	# recebe o valor correspondente de cada tipo de inimigo
	# especificada no script aliens.gd.
	dados.pontuacao += alien.pontuacao
	# Essa verificação, consulta o array pontos_vidas_extras 
	# comparando as pontuações tabeladas com a pontuação atual.
	if (dados.index_vidas_extras < pontos_vidas_extras.size()  and 
	dados.pontuacao >= pontos_vidas_extras[dados.index_vidas_extras]):
		# caso a pontuação atual seja igual ou maior 
		# que alguma pontuação tabelada no array, 
		# e esse marca ainda não utilizada,
		# é dado ao jogador uma vida extra.
		dados.vidas += 1
		atualizando_vidas()
		# O ícone com o número de vidas é atualizada no HUD.
		dados.index_vidas_extras += 1
	# pontuação é atualizada no HUD.
	atualizando_pontos()
	
	
func sinal_de_vitoria():
	# Esta função, emite um sinal de vitória, 
	# avisando que é possível mudar de fase.
	emit_signal("vitoria")
	
	
func sinal_para_alien_dominou_a_terra():
	# Esta função, emite um sinal de que o jogo acabou.
	fim_de_jogo()
	
	
func fim_de_jogo():
	$grupo_alienigina.para_tudo()
	$navinha.desabitar()
	$navinha.queue_free()
	emit_signal("fim_de_jogo")
	
# esta função, manda um sinal de nave destruída,
# atualiza a variável vida, e atualiza o desenho da vida.
func sinal_de_nave_destroida():
	$grupo_alienigina.para_tudo();
	dados.vidas -= 1
	atualizando_vidas()
	get_tree().call_group("tipo_inimigo", "destruir")
	
	
func sinal_de_nave_renascida():
	if dados.vidas <= 0:
		fim_de_jogo()
	else:
		$grupo_alienigina.volta_tudo()
	
	
#----------------- ATUALIZANDO INFORMAÇÕES DE PONTOS/VIDA ---------------------#


func atualizando_pontos():
	# Muda o texto da label pontos, para a pontuação atual convertida em string. 
	$HUD/pontos.set_text(str(dados.pontuacao))
	
func atualizando_vidas():
	# Muda o número de ícones para o correspondente ao número de vidas atual.
	$HUD/vidas.set_vidas(dados.vidas)
	
func atualizando_HUD():
	# Junta as duas funções em uma só.
	atualizando_pontos()
	atualizando_vidas()

func set_dados(valor):
	dados = valor;
	atualizando_HUD()
