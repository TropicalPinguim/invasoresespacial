extends Area2D

#---------------------------definindo variaveis--------------------------------#
var velocidade = 200;
var direcao = Vector2(0,-1);

func _ready():
	 add_to_group("tiro_navinha");
	 set_process(true);
	
func _process(delta):
	translate(direcao * velocidade * delta);
	
	if get_global_position().y <0:
		queue_free()

# Esta função verifica se ouve colisão, em seguida,
# verifica se o objeto a qual teve a colição,
# possue o metodo destroy, destruindo então o objeto.
func _on_tiro_navinha_area_entered(area):
	if area.has_method("destruir"):
		area.destruir(self)
		destruir(self)

func destruir(obj):
	queue_free();


