extends Node

# velocidade do boneco, export para podermos modificar enquanto jogamos
export var velocidade = 75
export var forcaPulo = 375

# vetores de base
var vetorX = Vector2(1, 0.5)
var vetorY = Vector2(1, -0.5)
var vetorZ = Vector2(0, -1)

# vetores do plano XY formado pelo vetorX e vetorY
var vetorSul = (vetorX - vetorY)/2
var vetorLeste = (vetorX + vetorY)/2
var vetorNorte = (vetorY - vetorX)/2
var vetorOeste = -(vetorX + vetorY)/2

# vetores do plano Z formado pelo vetorZ
var vetorCima = vetorZ
var vetorBaixo = -vetorZ

# vetores de movimento do boneco no espaço formado pelos vetores X,Y e Z
var sentidoX = Vector2(0, 0)
var sentidoY = Vector2(0, 0)
var sentidoZ = Vector2(0, 0)

# vetor que é a soma dos vetores do plano XY
var sentidoXY = Vector2(0,0)

# vetor que é a soma dos vetores do espaço XYZ
var sentido = Vector2(0, 0)

# posicao na reta X
var posicaoX = Vector2(0, 0)
# posicao na reta y
var posicaoY = Vector2(0, 0)
# posicao na reta Z
var posicaoZ = Vector2(0, 0)

# posicao no plano XY
var posicaoXY = Vector2(0, 0)

# posicao no espaco XYZ
var posicao = Vector2(0, 0)

# posicao do chao na reta Z
var posicaoChaoZ = Vector2(0, 0)

# posicao do chao no espaco XYZ
var posicaoChao = Vector2(0, 0)

# variaveis do mundo
var atrito
var gravidade

func rodar(inAtrito, inGravidade):
	atrito = inAtrito
	gravidade = inGravidade
		
	calcularSentido()
	calcularPosicao()
	
func andar(inSentido):
	if inSentido == 'sul':
		# clamp(valor, limite inferior, limite superior)
		sentidoY = Vector2(0 , clamp(sentidoY.y + (vetorSul.y * atrito), vetorNorte.y * velocidade,  vetorSul.y * velocidade))
	elif inSentido == 'leste':
		sentidoX = Vector2(clamp(sentidoX.x + (vetorLeste.x * atrito), vetorOeste.x * velocidade, vetorLeste.x * velocidade), 0)
	elif inSentido == 'norte':
		sentidoY = Vector2(0, clamp(sentidoY.y + (vetorNorte.y * atrito),  vetorNorte.y * velocidade,  vetorSul.y * velocidade))
	elif inSentido == 'oeste':
		sentidoX = Vector2(clamp(sentidoX.x + (vetorOeste.x * atrito),  vetorOeste.x * velocidade, vetorLeste.x * velocidade), 0)
	
func sentido(valor):
	if valor == 'sul':
		return sentidoY.y > 0
	elif valor == 'leste':
		return sentidoX.x > 0
	elif valor == 'norte':
		return sentidoY.y < 0
	elif valor == 'oeste':
		return sentidoX.x < 0
	
func parar(valor):
	if valor == 'sul':
		sentidoY = sentidoY + vetorNorte * atrito
	elif valor == 'leste':
		sentidoX = sentidoX + vetorOeste * atrito
	elif valor == 'norte':
		sentidoY = sentidoY + vetorSul * atrito
	elif valor == 'oeste':
		sentidoX = sentidoX + vetorLeste * atrito

func calcularSentido():
	sentido = sentidoX + sentidoY + sentidoZ
	sentidoXY = sentidoX + sentidoY
	
func pular():
	sentidoZ = vetorCima * forcaPulo
	calcularPosicao()

func calcularPosicao():
	posicaoX += sentidoX/60
	posicaoY += sentidoY/60
	posicaoZ += sentidoZ/60
	posicaoXY = posicaoX + posicaoY
	posicao = posicaoX + posicaoY + posicaoZ
	posicaoChao = posicaoXY + posicaoChaoZ

func noChao():
	return posicaoZ.y >= posicaoChaoZ.y

func cair():
	sentidoZ.y += gravidade

func ficarNoChao():
	sentidoZ.y = 0
	posicaoZ = posicaoChaoZ

func respawnar(inPosicao):
	sentidoX = Vector2(0,0)
	sentidoY = Vector2(0,0)
	sentidoZ = Vector2(0,0)
	posicaoX = Vector2(inPosicao.x,0)
	posicaoY = Vector2(0,inPosicao.y)
	posicaoZ = Vector2(0,0)
	posicaoChaoZ = Vector2(0,0)
	posicaoChao = Vector2(0,0)
	calcularPosicao()