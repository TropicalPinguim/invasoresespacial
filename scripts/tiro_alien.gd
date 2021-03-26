extends Area2D

const vel = 120;
const dir = Vector2(0,1);

func _ready():
	add_to_group("tipo_inimigo");
	set_process(true);
func _process(delta):
	translate(dir * vel * delta);
	if get_global_position().y > 320:
		destruir(self);
func destruir(obj):
	queue_free();
# esta função convoca o metodo destroy
func _on_tiro_alien_area_entered(area):
	if area.has_method("destruir"):
		area.destruir(self)
		destruir(self)
