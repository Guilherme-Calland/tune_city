extends KinematicBody2D

# vetor de direcao
var direcao = Vector2(0,0)

# velocidade do boneco, export para podermos modificar enquanto jogamos caso queiramos
export var velocidade = 75

# para sabermos qual sentido ele esta olhando quando esta parado
var sentido = "baixo"

# metodo que roda quando inicia essa cena
func _ready():
	mudarAnimacao("paradoBaixo")
	
func rodar():
	
	#fisica
	if apertouBotao("baixo"):
		sentido = "baixo"
		direcao.y = velocidade
	elif apertouBotao("cima"):
		sentido = "cima"
		direcao.y = -velocidade
	else:
		direcao.y = 0
		
	if apertouBotao("esquerda"):
		sentido = "esquerda"
		direcao.x = -velocidade
	elif apertouBotao("direita"):
		sentido = "direita"
		direcao.x = velocidade
	else:
		direcao.x = 0
		
	mover()
	
	#animacao
	if apertouBotao("baixo"):
		mudarAnimacao("andandoBaixo")
	elif apertouBotao("cima"):
		mudarAnimacao("andandoCima")
	
	if apertouBotao("esquerda"):
		mudarAnimacao("andandoHorizontal")
		inverterSentidoSprite(true)
	elif apertouBotao("direita"):
		mudarAnimacao("andandoHorizontal")
		inverterSentidoSprite(false)

	if estaParado():
		if sentido == "baixo":
			mudarAnimacao("paradoBaixo")
			
func mover():
	#metodo que precisa rodar para ele se mover a cada frame
	move_and_slide(direcao, Vector2(0,-1))
	
func estaParado():
	return direcao == Vector2(0,0)

func mudarAnimacao(animacao):
	$AnimationPlayer.play(animacao)

func apertouBotao(botao):
	if botao == "baixo":
		#impedir que o usuario aperte dois botoes que são exclusivos
		return Input.is_action_pressed("baixo") and not Input.is_action_pressed("cima")
	elif botao == "cima":
		return Input.is_action_pressed("cima") and not Input.is_action_pressed("baixo")
	elif botao == "esquerda":
		return Input.is_action_pressed("esquerda") and not Input.is_action_pressed("direita")
	elif botao == "direita":
		return Input.is_action_pressed("direita") and not Input.is_action_pressed("esquerda")

func inverterSentidoSprite(b):
	$Sprite.flip_h = b
