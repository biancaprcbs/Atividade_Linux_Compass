#!/bin/bash

DATA=$(TZ=America/Sao_Paulo date)
SERVICE_REQ="httpd"
STATUS=$(systemctl is-active $SERVICE_REQ)

if [ $STATUS == "active" ]
then
    MENSAGEM="Validação do serviço $SERVICE_REQ concluída! Estado: ONLINE."
    echo "$DATA - $SERVICE_REQ - active - $MENSAGEM" >> /mnt/nfs/bianca/online.txt
else
    MENSAGEM="Validação do serviço $SERVICE_REQ concluída! Estado: OFFLINE."
    echo "$DATA - $SERVICE_REQ - inactive - $MENSAGEM" >> /mnt/nfs/bianca/offline.txt
fi
