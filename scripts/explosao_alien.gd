extends Area2D

func _ready():
	$animation.play("explosao"); # executa a animação de forma assíncrona.
	yield($animation, "animation_finished");# espera um sinal de que a animação acabou. 
	queue_free()
