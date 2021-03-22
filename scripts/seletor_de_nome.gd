extends Node2D

const letras = "ABCDEFGHIJKLMNOPQRSTUVXYZ0123456789_* "

var index = 0;
var letra = 0;

signal terminou(nome)
func _ready():
	set_process_input(true)
	
func _input(event):
	var alterou = false;
	if event.is_action_pressed("ui_right") and not event.is_echo():
		index += 1;
		alterou = true;
		
	if event.is_action_pressed("ui_left") and not event.is_echo():
		index -= 1;
		alterou = true;
		
	if alterou:
		if index < 0:
			index = letras.length() - 1;
		elif index >= letras.length():
			index = 0;
			
		$container.get_child(letra).set_text(letras[index]);
		
	if  event.is_action_pressed("ui_select") and not event.is_echo():
		$container.get_child(letra).set_percent_visible(1)
		index = 0;
		letra += 1 ;
		if letra >2:
			$timer.stop();
			set_process_input(false)
			var nome = ($container.get_child(0).get_text()+
			$container.get_child(1).get_text()+
			$container.get_child(2).get_text())
			emit_signal("terminou", nome);

# Esta função, faz a letra piscar mudando a opacidade da latra:
func _on_timer_timeout():
	if $container.get_child(letra).get_percent_visible()>0:
		$container.get_child(letra).set_percent_visible(0)
	else:
		$container.get_child(letra).set_percent_visible(1)
