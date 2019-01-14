#!/bin/bash
# SCRIPT CONSULTA O STATUS DO SERVICO DE NFE DIRETAMENTE DA RECEITA FEDERAL
# SCRIPT FEITO BASEADO NO AUTORIZADOR CONSULTA_AUTORIZADOR

# VARIAVEIS
AUT=${1}
CURL=$(which curl)
AWK=$(which awk)
CAT=$(which cat)
#EGREP=$(which egrep)

ARQUIVO_TEMPORARIO="/tmp/statusNFE.txt"

# CONSULTA AUTORIZADOR

AUTORIZADOR=${AUT}
#CONSULTANFE4=$($CAT $ARQUIVO_TEMPORARIO | egrep "	")

CONSULTA_AUTORIZADOR=$($CAT $ARQUIVO_TEMPORARIO | egrep "<td>$AUTORIZADOR</td>")
STATUS_AUTORIZACAO=$(echo $CONSULTA_AUTORIZADOR | $AWK '{print $17}' | $AWK -F 'src="' '{print $2}'| $AWK -F '"' '{print $1}')
STATUS_RETORNO_AUTORIZACAO=$(echo $CONSULTA_AUTORIZADOR | $AWK '{print $19}' | $AWK -F 'src="' '{print $2}' | $AWK -F '"' '{print $1}')
STATUS_INUTILIZACAO=$(echo $CONSULTA_AUTORIZADOR |$AWK '{print $21}' | $AWK -F 'src="' '{print $2}' | $AWK -F '"' '{print $1}')
STATUS_CONSULTA_PROTOCOLO=$(echo $CONSULTA_AUTORIZADOR |$AWK '{print $23}' | $AWK -F 'src="' '{print $2}' | $AWK -F '"' '{print $1}')
STATUS_SERVICO=$(echo $CONSULTA_AUTORIZADOR |$AWK '{print $25}' | $AWK -F 'src="' '{print $2}' | $AWK -F '"' '{print $1}')
STATUS_CONSULTA_CADASTRO=$(echo $CONSULTA_AUTORIZADOR |$AWK '{print $27}' | $AWK -F 'src="' '{print $2}' | $AWK -F '"' '{print $1}')
STATUS_RECEPCAO_EVENTO=$(echo $CONSULTA_AUTORIZADOR |$AWK '{print $29}' | $AWK -F 'src="' '{print $2}' | $AWK -F '"' '{print $1}')

function consultar_servico() {
	[[ $2 == "imagens/bola_verde_P.png" ]] && echo "$1 = 1" #DISPONIVEL
	[[ $2 == "imagens/bola_amarela_P.png" ]] && echo "$1 = 2" #INDISPONIVEL
	[[ $2 == "imagens/bola_vermelho_P.png" ]] && echo "$1 = 0" #OFFLINE
}

echo "CONSULTA AO AUTORIZADOR NFE: $AUTORIZADOR"
consultar_servico "AUTORIZACAO" $STATUS_AUTORIZACAO
consultar_servico "RETORNO AUT" $STATUS_RETORNO_AUTORIZACAO
consultar_servico "INUTILIZACAO" $STATUS_INUTILIZACAO
consultar_servico "CONSULTA PROTOCOLO" $STATUS_CONSULTA_PROTOCOLO
consultar_servico "SERVICO" $STATUS_SERVICO
consultar_servico "CONSULTA CADASTRO" $STATUS_CONSULTA_CADASTRO
consultar_servico "RECEPCAO EVENTO" $STATUS_RECEPCAO_EVENTO
