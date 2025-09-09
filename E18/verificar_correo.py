#!/usr/bin/env python

import sys
import requests
import time
import getpass
import os
import logging
import csv

logging.basicConfig(
    filename="registro.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

if len(sys.argv) != 2:
    print("Uso: python verificar_correo.py correo@example.com")
    sys.exit(1)

correo = sys.argv[1]

if not os.path.exists("apikey.txt"):
    print("No se encontró el archivo apikey.txt")
    clave = getpass.getpass("Ingresa tu apikey: ")
    with open("apikey.txt", "w") as archivo:
        archivo.write(clave.strip())

try:
    with open("apikey.txt", "r") as archivo:
        api_key = archivo.read().strip()
except FileNotFoundError:
    print("Error: No se encontré el archivo apikey.txt")
    sys.exit(1)

url = f"https://haveibeenpwned.com/api/v3/breachedaccount/{correo}"
headers = {
    "hibp-api-key": api_key,
    "user-agent": "PythonScript"
}

response = requests.get(url, headers=headers)

if response.status_code == 200:
    brechas = response.json()
    logging.info(
            f"Consulta exitosa para {correo}: {len(brechas)} brechas"
            )
    print(f"\nLa cuenta {correo} fue comprometida en {len(brechas)} brechas")

    with open(
            "reporte.csv",
            "w",
            newline='',
            encoding="utf-8") as archivo_csv:

        try:
            writer = csv.writer(archivo_csv)
            writer.writerow(["Título",
                             "Dominio",
                             "Fecha de Brecha",
                             "Datos Comprometidos",
                             "Verificada",
                             "Sensible"])
        except (FileNotFoundError, PermissionError, OSError,
                csv.Error) as e:
            logging.error(f"Error al escribir reporte.csv: {e}")

    for i, brecha in enumerate(brechas[:3]):
        nombre = brecha['Name']
        detalle_url = f"https://haveibeenpwned.com/api/v3/breach/{nombre}"
        detalle_resp = requests.get(detalle_url, headers=headers)
        if detalle_resp.status_code == 200:
            detalle = detalle_resp.json()
            try:
                with open(
                        "reporte.csv",
                        "a",
                        newline='',
                        encoding="utf-8") as archivo_csv:

                    writer = csv.writer(archivo_csv)
                    writer.writerow([
                                detalle.get('Title'),
                                detalle.get('Domain'),
                                detalle.get('BreachDate'),
                                ','.join(detalle.get('DataClasses', [])),
                                detalle.get('IsVerified'),
                                detalle.get('IsSensitive')
                            ])
                print(f"Se ha guardado las brecha {i+1} en reporte.csv")
                print("-" * 60)
                if i < 2:
                    time.sleep(10)
            except (FileNotFoundError, PermissionError, OSError,
                    csv.Error) as e:
                logging.error(f"Error al escribir reporte.csv: {e}")

        else:
            print(f"No se pudo obtener detalles de la brecha: {nombre}")
            if i < 2:
                print("Esperando 10 segundos antes de consultar...\n")
                time.sleep(10)
            elif response.status_code == 404:
                print(f"La cuenta {correo} no aparece en ninguna brecha")
            elif response.status_code == 401:
                logging.error("Error 401: API key inválida")
                print("Error de autenticacion: revisa tu API key.")
            else:
                logging.error(f"Error inesperado: {response.status_code}")
                print(f"Error inesperado: {response.status_code}")

elif response.status_code == 404:
    logging.info(f"Consulta exitosa para {correo}. No se encontraron brechas")
    print(f"\nLa cuenta {correo} no se ha encontrado en ninguna brecha")
