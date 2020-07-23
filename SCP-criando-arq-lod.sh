#!/bin/bash

Z_IP_LOJA_1_CAIXA=0
# "listaipcompleto" é o nome do arquivo onde estão os ips para realizar copia
for IP in $(cat listaipcompleta);
do
# Condição para verificar se esta pingando ao destino
	ping -c3 $IP > /dev/null
	#Condicao de ping no caixa, se trouxer resultado
	if [ $? = 0 ]; then
    # Valido a sub rede para não haver redundancia de arquivos o primeiro maquina destino 
		CX_FOR="$(echo $IP | awk -F "." '{print $3}')"
		if [ $CX_FOR == $Z_IP_LOJA_1_CAIXA ]
		then
			echo "Mesma loja"
		else
			echo "Copia para o primeiro caixa"
			Caminho=$IP:/mnt
      # Opcoes para não confirmar e senha para transferencia 
			sshpass -p XXX scp -oStrictHostKeyChecking=no -r pdv_* listaip* $Caminho;
			Z_IP_LOJA_1_CAIXA="$(echo $IP | awk -F "." '{print $3}')"
		fi
	else
    # Caso não comunique grava no arquivo com a data
		echo "nao pingou $IP" >> arquivo_`date +%d`
	fi
done
