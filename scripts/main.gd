extends Node
const arquivo_pontuandos = "res://arquivo_pontuandos";

var pre_seletor_de_nomes = preload("res://cenas/seletor_de_nome.tscn");
var pre_jogo = preload("res://cenas/jogo.tscn");

var jogo;
var hiscore;
# modelo de pontuação padrao.
var pontuacaos = [ 
	{n = "AAA", p = 1200},
	{n = "AAA", p = 1000},
	{n = "BBB", p = 900},
	{n = "CCC", p = 800},
	{n = "CCC", p = 700},
	{n = "DDD", p = 600},
	{n = "EEE", p= 400},
	{n = "FFF", p = 300},
	{n = "GGG", p = 200},
	{n = "HHH", p = 100}
]

func _ready():
	#lendo_pontos()
	$top_10.mostrando_pontuandos(pontuacaos)
	
func novo_jogo():
	if jogo != null:              # Verifica se ja existe uma cena jogo 
		jogo.queue_free()         # se ja existir a cena antiga sera removida. 
	jogo = pre_jogo.instance()
	$novo_jogo.add_child(jogo)
	jogo.connect("fim_de_jogo",self, "sinal_de_fim_de_jogo")
	jogo.connect("vitoria",self, "sinal_da_vitoria")
	
func _on_bt_novo_jogo_pressed():
	$bt_novo_jogo.hide()
	$top_10.hide()
	$titulo.hide()
	novo_jogo()
	
func sinal_de_fim_de_jogo():
	hiscore = null
	for pontinhos in pontuacaos:
		if jogo.dados.pontuacao > pontinhos.p:
			hiscore = pontinhos;
			break
	if hiscore != null:
		var seletor_de_nomes = pre_seletor_de_nomes.instance()
		add_child(seletor_de_nomes)
		seletor_de_nomes.connect("terminou", self, "guarda_pontos")
		yield(seletor_de_nomes, "terminou")
		seletor_de_nomes.queue_free()
		#salva_pontos()
		
	$bt_novo_jogo.show();
	$top_10.show()
	$top_10.mostrando_pontuandos(pontuacaos)
	
func guarda_pontos(valor):
	var index = pontuacaos.find(hiscore)
	pontuacaos.insert(index, {n = valor, p = jogo.dados.pontuacao})
	pontuacaos.resize(10)

func sinal_da_vitoria():
	var dados = jogo.dados
	novo_jogo()
	jogo.dados = dados

#func salva_pontos():
#	var arquivo = File.new();
#	var resultado = arquivo.open(arquivo_pontuandos, arquivo.WRITE)
#	if resultado == OK:
#		var quardando_pontos = {
#		  pontos = pontuacaos
#		};
#		arquivo.store_line(to_json(quardando_pontos));
#		arquivo.close();
#		
#func lendo_pontos():
#	var arquivo = File.new();
#	var resultado = arquivo.open(arquivo_pontuandos, arquivo.READ)
#	if resultado == OK:
#		var text = arquivo.get_as_text();
#		var ler_pontos = parse_json(text)
#		pontuacaos = ler_pontos.pontos
#		arquivo.close();
