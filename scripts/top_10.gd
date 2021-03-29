extends VBoxContainer

const pre_item = preload("res://cenas/pontuandos.tscn");
const positions =  ["1ST","2ND","3RD","4TH","5TH","6TH","7TH","8TH","9TH","10TH"];
const colors =  ["FF0000","19A6FF","00B333","00FF48","B31212","F0801D", 
"D62AFA", "804FF0", "E32B68", "61F01D"];

func mostrando_pontuandos(pontuacaos):
	
	var item  = pre_item.instance();
	item.pos = "RANK";
	item.nome = "NOME";
	item.pontos = "PONTOS";
	add_child(item);
	var a = 0;
	for pontinhos in pontuacaos:
		item  = pre_item.instance();
		item.pos = positions[a];
		item.nome = pontinhos.n;
		item.pontos = pontinhos.p;
		item.color = Color(colors[a])
		add_child(item)
		#faz o texto aparecer lentamente na tela 
		$timer.start()
		yield($timer,"timeout")
		a += 1

