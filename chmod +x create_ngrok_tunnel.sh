#!/bin/bash

# Configuración
MC_SERVER_PORT=25565
NGROK_AUTH_TOKEN="2iG7bBSRVleh8oQxshckxoh9MaU_7wLfY55W4NBpvxmqz5Rxa"

# Datos del túnel (basado en tu configuración JSON)
TUNNEL_NAME="Minecraft Java"
LOCAL_IP="127.0.0.1"
LOCAL_PORT=25565
NGROK_REGION="global"

# Verifica si ngrok está instalado
if ! command -v ngrok &> /dev/null
then
    echo "ngrok no está instalado. Por favor, instala ngrok y ejecuta nuevamente el script."
    exit 1
fi

# Autenticarse con ngrok
ngrok authtoken $NGROK_AUTH_TOKEN

# Crear configuración YAML para ngrok
cat <<EOL > ngrok-config.yaml
version: "2"
authtoken: $NGROK_AUTH_TOKEN
tunnels:
  minecraft:
    addr: $LOCAL_IP:$LOCAL_PORT
    proto: tcp
    region: $NGROK_REGION
EOL

# Iniciar ngrok con la configuración YAML
ngrok start -config ngrok-config.yaml --all &

# Guardar el PID de ngrok para detenerlo más tarde
NGROK_PID=$!

# Función para detener ngrok cuando el script finalice
cleanup() {
    echo "Deteniendo ngrok..."
    kill $NGROK_PID
    rm -f ngrok-config.yaml
    exit
}

# Capturar la señal de interrupción (Ctrl+C) para llamar a la función de limpieza
trap cleanup INT

# Mantener el script en ejecución para que ngrok siga funcionando
wait $NGROK_PID
