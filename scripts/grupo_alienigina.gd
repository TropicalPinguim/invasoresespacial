extends Node2D

#------------------------------- pré load -------------------------------------#
var pre_tiro_alien = preload("res://cenas/tiro_alien.tscn")
var pre_explosao_alien = preload("res://cenas/explosao_alien.tscn")
var pre_nave_mae = preload("res://cenas/nave_mae.tscn")

#------------------------- declarando constantes ------------------------------#
const velocidade = Vector2(6,0)

#------------------------- declarando variaveis -------------------------------#
var direcao = 1;
var notas = 0;

#--------------------------- declarando sinais --------------------------------#
signal inimigo_destruido(obj)
signal estou_pronto()
signal terra_dominada()
signal vencedor()

func _ready():
	$timer_tiro_alien.start();
	restart_nave_mae();
	for alien in $aliens.get_children():
		alien.hide()
		alien.connect("destroido",self,"_chame_sinal_destroido")
	for alien in $aliens.get_children():
		$timer_pausa.start()
		yield($timer_pausa, "timeout")
		alien.show()
	emit_signal("estou_pronto")
	volta_tudo()
	
func _tiro_alien():
	# executa o som do tiro alienigina.
	$som_tiro_alien.play()
	# a variavel n_alien, recebe a contagem de aliens ainda vivo.
	var numero_de_aliens = $aliens.get_child_count()

	if numero_de_aliens > 0:
		# a variavel alien recebe de forma aleatoria um alien ainda vivo.
		var alien = $aliens.get_child(randi() % numero_de_aliens)
		# a variavel tiro_alien recebe uma copia do tiro alienigina.
		var tiro_alien =  pre_tiro_alien.instance()
		# o tiro_alien é adicionado ao grupo_alienigina.
		get_parent().add_child(tiro_alien)
		# faz um alien ainda vivo, atirar.
		tiro_alien.set_global_position(alien.get_global_position())
		
func _on_timer_movimento_timeout():#ok
	
	#sons.append(notas)
	notas += 1
	if notas > 4:
		notas = 1;
		
	var borda = false
	
	for alien in $aliens.get_children():
		alien.proximo_frame()
		if alien.get_global_position().x>217 and direcao > 0:
			direcao = -1
			borda = true
		if alien.get_global_position().x<12 and direcao < 0:
			direcao = 1
			borda = true
		if alien.get_global_position().y > 230:
			emit_signal("terra_dominada")
			
	if borda:
		# Está verificação, se certifica que a cada decida, 
		# o tempo de chegada ate a borda diminua. 
		translate(Vector2(0,8))
		if $timer_movimento.get_wait_time() > .11:
			$timer_movimento.set_wait_time($timer_movimento.get_wait_time()-.06)
	else:
		# caso contrario mude de direção.
		translate(velocidade * direcao);

func _on_timer_tiro_alien_timeout():#ok
	# Está função, decide de forma aliatoria, o tempo entre os disparos.
	# Podendo ser entre 0,5 segundo ate 2 segundos.
	$timer_tiro_alien.set_wait_time(rand_range(.5 , 2));
	_tiro_alien();

func _chame_sinal_destroido(alien):#ok
	# executa o som da explosão.
	$som_explosao_alienigina.play()
	# emite um sinal, avisando que um alienigina foi destruido.
	emit_signal("inimigo_destruido", alien)
	# a variavel explosão alienigina recebe uma instancia da cena explosão.
	var explosao_alien = pre_explosao_alien.instance()
	# adiciona um cena explosão, ao grupo alienigina.
	get_parent().add_child(explosao_alien)
	# pega a posição alienigina atigido e subistue pela explosão.
	explosao_alien.set_global_position(alien.get_global_position())
	# esta verificação faz a contagem dos aliens, e quando acaba
	# emite um sinal avisando que o player venceu.
	if $aliens.get_child_count() == 1:
		para_tudo();
		emit_signal("vencedor");
		
# Está função, verifica se os aliens chegaram ate a borda,
# fazendo com que mude de direção. 
func _on_timer_nave_mae_timeout():
	var nave_mae = pre_nave_mae.instance();
	nave_mae.connect("destroido",self,"_chame_sinal_destroido")
	get_parent().add_child(nave_mae)
	restart_nave_mae()
	
func restart_nave_mae():#ok
	$timer_nave_mae.set_wait_time(rand_range(6,16))
	$timer_nave_mae.start()
		
func para_tudo():#ok
	$timer_nave_mae.stop()
	$timer_tiro_alien.stop()
	$timer_movimento.stop()
	
func volta_tudo():
	$timer_nave_mae.start()
	$timer_tiro_alien.start()
	$timer_movimento.start()
	
