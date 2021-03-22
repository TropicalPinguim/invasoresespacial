extends Area2D


var vida = 0;

func destruir(obj):
	vida  += 1;
	if vida > 5:
		queue_free();
	get_node("sprite").set_frame(vida);
