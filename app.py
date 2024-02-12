import os
from dotenv import load_dotenv
import subprocess

load_dotenv()

SERVERNAME = os.getenv('SERVERNAME')
USER_NAME = os.getenv('USER_NAME')
PASSWORD = os.getenv('PASSWORD')

# cmd = 'date'

# # Using os.system() method
# os.system(cmd)


def load_csv(path):
    os.system(f'docker cp "{path}" sql-server:/data.csv')


def load_scripts():
    # os.system('docker cp "/home/desquivel/Documents/Seminario2/Practica 1/historial_tsumamis.csv" sql-server:/data.csv')
    os.system('docker cp "/home/desquivel/Documents/SS2_Practica1_202010055/scripts/create_model.sql" sql-server:/create_model.sql > /dev/null')
    os.system('docker cp "/home/desquivel/Documents/SS2_Practica1_202010055/scripts/delete_model.sql" sql-server:/delete_model.sql > /dev/null')
    os.system('docker cp "/home/desquivel/Documents/SS2_Practica1_202010055/scripts/import_data.sql" sql-server:/import_data.sql > /dev/null')
    os.system('docker cp "/home/desquivel/Documents/SS2_Practica1_202010055/scripts/load_data.sql" sql-server:/load_data.sql > /dev/null')
    os.system('docker cp "/home/desquivel/Documents/SS2_Practica1_202010055/scripts/load_procs.sql" sql-server:/load_procs.sql > /dev/null')


def create_model():
    command = f"docker exec sql-server sh -c \"/opt/mssql-tools/bin/sqlcmd -S {SERVERNAME} -U {USER_NAME} -P {PASSWORD} -i /create_model.sql\" "
    os.system(command)

    command = f"docker exec sql-server sh -c \"/opt/mssql-tools/bin/sqlcmd -S {SERVERNAME} -U {USER_NAME} -P {PASSWORD} -i /load_procs.sql\" "
    os.system(command)


def delete_model():
    command = f"docker exec sql-server sh -c \"/opt/mssql-tools/bin/sqlcmd -S {SERVERNAME} -U {USER_NAME} -P {PASSWORD} -i /delete_model.sql\" "
    os.system(command)


def load_data():
    command = f"docker exec sql-server sh -c \"/opt/mssql-tools/bin/sqlcmd -S {SERVERNAME} -U {USER_NAME} -P {PASSWORD} -i /import_data.sql\" "
    os.system(command)
    print()

    command = f"docker exec sql-server sh -c \"/opt/mssql-tools/bin/sqlcmd -S {SERVERNAME} -U {USER_NAME} -P {PASSWORD} -i /load_data.sql\" "
    os.system(command)


def consulta1():
    f = open("consultas/consulta1.txt", "w")
    command = ["docker", "exec", "-it", "sql-server", "/opt/mssql-tools/bin/sqlcmd", "-S",
               SERVERNAME, "-d", "Practica1", "-U", USER_NAME, "-P", PASSWORD, "-Q", "EXEC dbo.Consulta1"]
    subprocess.call(command, stdout=f)


def consulta2():
    f = open("consultas/consulta2.txt", "w")
    command = ["docker", "exec", "-it", "sql-server", "/opt/mssql-tools/bin/sqlcmd", "-S",
               SERVERNAME, "-d", "Practica1", "-U", USER_NAME, "-P", PASSWORD, "-Q", "EXEC dbo.Consulta2"]
    subprocess.call(command, stdout=f)


def consulta3():
    f = open("consultas/consulta3.txt", "w")
    command = ["docker", "exec", "-it", "sql-server", "/opt/mssql-tools/bin/sqlcmd", "-S",
               SERVERNAME, "-d", "Practica1", "-U", USER_NAME, "-P", PASSWORD, "-Q", "EXEC dbo.Consulta3"]
    subprocess.call(command, stdout=f)


def consulta4():
    f = open("consultas/consulta4.txt", "w")
    command = ["docker", "exec", "-it", "sql-server", "/opt/mssql-tools/bin/sqlcmd", "-S",
               SERVERNAME, "-d", "Practica1", "-U", USER_NAME, "-P", PASSWORD, "-Q", "EXEC dbo.Consulta4"]
    subprocess.call(command, stdout=f)


def consulta5():
    f = open("consultas/consulta5.txt", "w")
    command = ["docker", "exec", "-it", "sql-server", "/opt/mssql-tools/bin/sqlcmd", "-S",
               SERVERNAME, "-d", "Practica1", "-U", USER_NAME, "-P", PASSWORD, "-Q", "EXEC dbo.Consulta5"]
    subprocess.call(command, stdout=f)


def consulta6():
    f = open("consultas/consulta6.txt", "w")
    command = ["docker", "exec", "-it", "sql-server", "/opt/mssql-tools/bin/sqlcmd", "-S",
               SERVERNAME, "-d", "Practica1", "-U", USER_NAME, "-P", PASSWORD, "-Q", "EXEC dbo.Consulta6"]
    subprocess.call(command, stdout=f)


def consulta7():
    f = open("consultas/consulta7.txt", "w")
    command = ["docker", "exec", "-it", "sql-server", "/opt/mssql-tools/bin/sqlcmd", "-S",
               SERVERNAME, "-d", "Practica1", "-U", USER_NAME, "-P", PASSWORD, "-Q", "EXEC dbo.Consulta7"]
    subprocess.call(command, stdout=f)


def consulta8():
    f = open("consultas/consulta8.txt", "w")
    command = ["docker", "exec", "-it", "sql-server", "/opt/mssql-tools/bin/sqlcmd", "-S",
               SERVERNAME, "-d", "Practica1", "-U", USER_NAME, "-P", PASSWORD, "-Q", "EXEC dbo.Consulta8"]
    subprocess.call(command, stdout=f)


def consulta9():
    f = open("consultas/consulta9.txt", "w")
    command = ["docker", "exec", "-it", "sql-server", "/opt/mssql-tools/bin/sqlcmd", "-S",
               SERVERNAME, "-d", "Practica1", "-U", USER_NAME, "-P", PASSWORD, "-Q", "EXEC dbo.Consulta9"]
    subprocess.call(command, stdout=f)


def consulta10():
    f = open("consultas/consulta10.txt", "w")
    command = ["docker", "exec", "-it", "sql-server", "/opt/mssql-tools/bin/sqlcmd", "-S",
               SERVERNAME, "-d", "Practica1", "-U", USER_NAME, "-P", PASSWORD, "-Q", "EXEC dbo.Consulta10"]
    subprocess.call(command, stdout=f)


load_scripts()

while (1):
    print("------------------------------------")
    print("||    Practica 1 - Seminario 2    ||")
    print("------------------------------------")
    print("||  Opciones:                     ||")
    print("||  1) Cargar CSV                 ||")
    print("||  2) Crear Modelo               ||")
    print("||  3) Eliminar Modelo            ||")
    print("||  4) Extraer Datos              ||")
    print("||  5) Consultas                  ||")
    print("||  6) Salir                      ||")
    print("------------------------------------")
    option = int(input())

    if option == 1:
        print("")
        path = input("Ingrese la ruta del archivo CSV: ")

        if not os.path.exists(path):
            print("El archivo no existe\n")
            continue

        load_csv(path)
        print()

    elif option == 2:
        create_model()
        print()

    elif option == 3:
        delete_model()
        print()

    elif option == 4:
        load_data()
        print()

    elif option == 5:
        while (1):
            print()
            print("------------------------------------------------------------")
            print("||  Consultas:                                            ||")
            print("||  1) Select todas las tablas                            ||")
            print("||  2) Tsunamis por año                                   ||")
            print("||  3) Tsunamis por país                                  ||")
            print("||  4) Promedio de Total Damage                           ||")
            print("||  5) Países con más muertes                             ||")
            print("||  6) Años con más muertes                               ||")
            print("||  7) Años con más tsunamis                              ||")
            print("||  8) Países con mayor número de casas destruidas        ||")
            print("||  9) Países con mayor número de casas dañadas           ||")
            print("||  10) Promedio de altura máxima del agua por cada país  ||")
            print("||  11) Salir                                             ||")
            print("------------------------------------------------------------")
            option = int(input())

            if option == 1:
                consulta1()
                print()
            elif option == 2:
                consulta2()
                print()
            elif option == 3:
                consulta3()
                print()
            elif option == 4:
                consulta4()
                print()
            elif option == 5:
                consulta5()
                print()
            elif option == 6:
                consulta6()
                print()
            elif option == 7:
                consulta7()
                print()
            elif option == 9:
                consulta8()
                print()
            elif option == 9:
                consulta9()
                print()
            elif option == 10:
                consulta10()
                print()
            elif option == 11:
                print()
                break
            else:
                print("Opcion no valida\n")

    elif option == 6:
        exit()

    else:
        print("Opcion no valida\n")
