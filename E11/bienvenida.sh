#!/usr/bin/env bash
#Script de bienvendia con argumentos
echo "Bienvendio, $1"
echo "Tu rol asignado es: $2"
echo "Número de argumentos recibidos: $#"

echo "Lista de argumentos:"
for arg in "$@"; do
  echo "--> $arg"
done
