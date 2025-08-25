#!/usr/bin/env bash
set -ex

# Script: Verificador.sh
# Desctipción: Valida si un usario existe, verifica si un servicio está activo y
# muestra resultados
# Autor: sar-05
# Fecha 22-08-2025
#
validar_usuario(){
  local usuario="$1"
  
  if id "$usuario" &>/dev/null; then
    echo "El usuario $usuario existe"
  else
    echo "El usuario $usuario no existe"
  fi
}

verificar_servicio(){
  local servicio="$1"
  if systemctl is-active --quiet "$servicio"; then
    echo "El servicio $servicio está activo"
  else
    echo "El servicio no $servicio está activo"
  fi
}

mostrar_resumen(){
  echo "Resumen de verificación completado"
}

#Validar usuario
validar_usuario "$1"

#Verificar servicio
verificar_servicio "$2"

#Mostrar resumen
mostrar_resumen 
