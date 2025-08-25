#!/usr/bin/env bash

archivos=("registro.txt" "config.conf" "usuarios.csv")
i=0

for archivo in "${archivos[@]}"; do
  if [[ -f "$archivo" ]]; then
    echo "$archivo existe"
    cat "$archivo"
    ((i++))
  else
    echo "$archivo no existe"
  fi
done

echo "Total encontrado $i"

