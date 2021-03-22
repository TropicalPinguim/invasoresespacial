tool
extends Area2D
# Cria uma opçao na engine para escolher o tipo de inimigo.
export(int, "A","B","C") var tipo = 0 setget setTipo;
var pontuacao = 0;
var frame = 0;

signal destroido(obj);# sinal de destruição


var atributos= [# vetor que carrega o sprite alienigina e seu valor na potuação.
	{
		texture = preload("res://sprites/InvaderA_sheet.png"),
		pontuacao = 10
	},
	{
		texture = preload("res://sprites/InvaderB_sheet.png"),
		pontuacao = 20
	},
	{
		texture = preload("res://sprites/InvaderC_sheet.png"),
		pontuacao = 30
	}
]


func _ready():
	pass
	
	
func _draw():
	var atributo =  atributos[tipo]
	$sprite.set_texture(atributo.texture);
	pontuacao = atributo.pontuacao;
	
	
func setTipo(val):
	tipo = val;
	# essa metodo permite visualizar na tela a mudança de inimigo no modo editor.
	if is_inside_tree() and get_tree().is_editor_hint():
		update();
		
		
func destruir(obj):
# Esta função, serve para destruir o objeto e emitir um sinal que foi destruido.
	emit_signal("destroido", self);
	queue_free();
	
	
func proximo_frame():
	# Esta função, faz com que mude o frame, cada vez que o alien se move.
	if frame == 0:
		frame = 1;
	else:
		frame = 0;
	$sprite.set_frame(frame);
	
	
func _on_aliens_area_entered(area):
	if area.has_method("destroy"):
		area.destroy(self)

