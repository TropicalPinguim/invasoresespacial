extends Area2D

var pontuacao = 200;
signal destroido(obj);# sinal de destruição

func _ready():
	$som_nave_mae.play()
	$animation.play("default")
	yield($animation,"animation_finished")
	queue_free();

func destruir(obj):
	emit_signal("destroido" , self)
	queue_free()
