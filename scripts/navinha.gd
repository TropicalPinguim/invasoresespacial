extends Area2D
#------------------------------- pré load -------------------------------------#
var preload_tiro = preload("res://cenas/tiro_navinha.tscn")

#------------------------- declarando constantes ------------------------------#
#velocidade que o player "navinha",se movimenta para os lados.
const velocidade = 100
 
#------------------------- declarando variaveis -------------------------------#
var direita
var direcao
var esquerda
var lazer
var pre_lazer
var esta_vivo = true;

#--------------------------- declarando sinais --------------------------------#
# sinal de que a navinha foi destruida.
signal destroido(obj)
# sinal de que a navinha renaceu.
signal renascer()


#--------------------------- declarando sinais --------------------------------#
func _ready():
	pass
	
func _process(delta):
	direcao = 0
	# estipula as ações que cada botao vai executar.
	direita = Input.is_action_pressed("ui_right")
	esquerda = Input.is_action_pressed("ui_left")
	lazer = Input.is_action_pressed("ui_select")
	#caso seja apertado o botao para direita percorra um pixel a direta.
	if direita:
		direcao += 1
	#caso seja apertado o botao para esquerdo percorra um pixel a esquerda.
	if esquerda:
		direcao -= 1
		
	translate(Vector2(1,0) * velocidade * direcao * delta);
	limitar_paredes()
	disparar()

func limitar_paredes():
	# o parametro clamp demarca os limites entre minino e maxino.
	# clamp(posição atual da nave, minimo , maximo).
	# a possiçao minima é equivalente ao minimo + metade do tamanho da nave.
	# a possiçao maxima é equivalente ao maximo - metade do tamanho da nave.
	set_global_position(
	(Vector2(clamp(get_global_position().x, 8, 172),get_global_position().y))
	)


func disparar():
	# essa verificação se certifica do limete de tiros da navinha.
	if lazer and not pre_lazer and get_tree().get_nodes_in_group("tiro_navinha").size() < 1:
		# executa o som de tiro da navinha.
		$sons_navinha/navinha_tiro.play()
		# a variavel tiro recebe uma instacia do tiro da navinha.
		var tiro = preload_tiro.instance()
		# adiciona uma copia do tiro da navinha ao jogo.
		get_parent().add_child(tiro)
		#procura a posiçao atual da navinha para atirar.
		tiro.set_global_position(get_global_position())
	pre_lazer = lazer 


func comecar():
	show()
	set_process(true)


func desabitar():
	hide()
	set_process(false)
	esta_vivo = false


func destruir(obj):
	if esta_vivo:
		esta_vivo = false
		set_process(false)
		# executa o som de distruiçao da navinha.
		$sons_navinha/navinha_destruida.play()
		emit_signal("destroido")
		# executa a animação da explosão.
		$animation.play("explosion")
		# yield se sertifica que a animaçao 
		# sera executada ate o final sem parar o jogo.
		yield($animation , "animation_finished")
		# emite um sinal que pode recomeçar um novo jogo.
		emit_signal("renascer")
		set_process(true)
		esta_vivo = true
		# volta o sprite para o frama principal
		$sprite.set_frame(0)
