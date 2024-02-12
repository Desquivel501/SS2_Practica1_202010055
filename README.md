# SS2_Practica1_202010055

## Modelo

![modelo](/images/modelo.png)

El modelo usado para esta base de datos sigue un modelo de snowflake con una tabla de hechos (facts) y 7 tablas de dimensiones las cuales son:

- Time: Esta tabla contiene los datos relacionados al tiempo del hecho (año, mes, dia, hora, minuto y segundo)
- Tsunami: Esta tabla contiene los datos relacionados al evento natural del tsunami, como la magnitud del terremoto que lo provoco, la magnitud del tsunami, la altura maxima del agua, etc.
- Epicenter: Aqui se encuentran las coordenadas de donde ocurrio el sismo.
- Location: Esta tabla contiene el nombre del lugar que se vio afectado.
- Country: Contiene el nombre del pais que se vio afectado.
- Loss: En etsa tabla se encuentran los valores relacionados a perdidas humanas (muertes, desaariciones, lesiones)
- Damages: Contiene los daños materiales causados por el tsunami (daño total, casas destruidas)

En este modelo la tabla de hechos solo contiene la llave de cada una de las dimensiones sin ningun dato extra.

### Carga de datos

La carga de datos fue realizada desde un archivo CSV, este fue cargado a una tabla temporal en SQL Server por medio de la herramienta `BULK INSERT`

```SQL
BULK INSERT
	Temporal
from
	'/data.csv'
With(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
    FORMAT = 'CSV',
	FIRSTROW = 2
);
```

### Crear el modelo

Una vez se han cargado los datos a la tabla temporal se crearon las tablas de las dimensiones y se paso a cargar los datos a estas. Esta carga era diferente segun la dimension, por ejemplo, para la dimension Tsunami se utilizo la siguiente peticion:

```SQL
INSERT INTO Tsunami (event_validity, cause_code, earthquake_magnitude, deposits, max_water_height, runups, magnitude, intensity)
SELECT DISTINCT event_validity, cause_code, earthquake_magnitude, deposits, max_water_height, runups, tsunami_magnitude , intensity
	FROM Temporal
```

Sin embargo, la tabla de hechos era diferente, ya que esta debia de tener las llaves de las dimensiones, por lo cual se tuvo que realizar un JOIN a todas las tablas de dimensiones e ingresar sus llaves a la tabla de hechos:

```SQL
INSERT INTO Fact (time_key, epicenter_key, tsunami_key, loss_key, damage_key, location_key)
SELECT DISTINCT Ti.time_key, Ep.epicenter_key, Ts.tsunami_key, L.loss_key, D.damage_key, Lo.location_key
	FROM Temporal Te
	JOIN [Time] Ti ON Te.[year] = Ti.[year] AND Te.[month] = Ti.[month] AND Te.[day] = Ti.[day]
		AND Te.[hour] = Ti.[hour] AND Te.[minute] = Ti.[minute] AND Te.[second] = Ti.[second]
	JOIN Epicenter Ep ON Te.longitude = Ep.longitude AND Te.latitude = Ep.latitude
	JOIN Tsunami Ts ON Te.event_validity = Ts.event_validity AND Te.cause_code = Ts.cause_code
		AND Te.earthquake_magnitude = Ts.earthquake_magnitude AND Te.deposits = Ts.deposits
		AND Te.max_water_height = Ts.max_water_height AND Te.runups = Ts.runups
		AND Te.tsunami_magnitude = Ts.magnitude AND Te.intensity = Ts.intensity
	JOIN Loss L ON Te.total_deaths = L.total_deaths AND Te.total_missing = L.total_missing
		AND Te.total_missing_description = L.total_missing_description AND Te.total_injuries = L.total_injuries
	JOIN Damage D ON Te.total_damage = D.total_damage AND Te.total_damage_description = D.total_damage_description
		AND Te.total_houses_destroyed = D.total_houses_destroyed AND Te.total_houses_damaged = D.total_houses_damaged
	JOIN Country C ON Te.country = C.name
	JOIN Location Lo ON Te.location = Lo.name AND Te.country = C.name AND Lo.country_key = C.country_key
```

### Procedimientos

Para realizar las consultas se utilizaron stored procedures, cada uno otorgando diferentes datos:

1. SELECT COUNT(\*) de todas las tablas

```SQL
CREATE PROCEDURE dbo.Consulta1
AS
BEGIN
	SELECT 'Temporal', COUNT(*)  FROM Temporal t
	UNION
	SELECT 'Fact', COUNT(*)  FROM Fact f
	UNION
	SELECT 'Tsunami', COUNT(*)  FROM Tsunami t2
	UNION
	SELECT 'Time', COUNT(*)  FROM [Time] ti
	UNION
	SELECT 'Epicenter', COUNT(*)  FROM Epicenter e
	UNION
	SELECT 'Location', COUNT(*)  FROM Location l
	UNION
	SELECT 'Country', COUNT(*)  FROM Country c
	UNION
	SELECT 'Loss', COUNT(*)  FROM Loss lo
	UNION
	SELECT 'Damage', COUNT(*)  FROM Damage d;

END;
GO
```

2. Cantidad de tsunamis por año.

```SQL
CREATE PROCEDURE dbo.Consulta2
AS
BEGIN
	SELECT t.[year], COUNT(*) as 'count'
	FROM Fact f
	JOIN [Time] t ON f.time_key = t.time_key
	GROUP BY t.[year]
	ORDER BY t.[year] ASC;

END;
GO
```

3. Tsunamis por país y que se muestran los años que han tenido tsunamis

```SQL
CREATE PROCEDURE dbo.Consulta3
AS
BEGIN
	SELECT
	    name,
	    MAX(CASE WHEN rn = 1 THEN year_ END) AS year1,
	    MAX(CASE WHEN rn = 2 THEN year_ END) AS year2,
	    MAX(CASE WHEN rn = 3 THEN year_ END) AS year3,
	    MAX(CASE WHEN rn = 4 THEN year_ END) AS year4,
	    MAX(CASE WHEN rn = 5 THEN year_ END) AS year5
	FROM (
	    SELECT
	        c.name as name,
	        t.[year] as year_,
	        ROW_NUMBER() OVER(PARTITION BY c.name ORDER BY t.[year]) AS rn
	    FROM Fact f
	    JOIN [Time] t ON t.time_key = f.time_key
		JOIN Location l ON l.location_key = f.location_key
		JOIN Country c ON l.country_key = c.country_key
		GROUP BY t.[year], c.name
	) AS subquery
	GROUP BY name
END;
GO
```

4. Promedio de Total Damage por país

```SQL
CREATE PROCEDURE dbo.Consulta4
AS
BEGIN
	SELECT c.name, AVG(d.total_damage) as 'avarage'
	FROM Fact f
	JOIN Location l ON l.location_key = f.location_key
	JOIN Country c ON l.country_key = c.country_key
	JOIN Damage d ON d.damage_key = f.damage_key
	WHERE d.total_damage != 0
	GROUP BY c.name
END;
GO
```

5. Top 5 de países con más muertes

```SQL
CREATE PROCEDURE dbo.Consulta5
AS
BEGIN
	SELECT TOP 5 c.name, SUM(L2.total_deaths) as 'total_deaths'
	FROM Fact f
	JOIN Location l ON l.location_key = f.location_key
	JOIN Country c ON l.country_key = c.country_key
	JOIN Loss l2 ON l2.loss_key = f.loss_key
	GROUP BY c.name
	ORDER BY SUM(L2.total_deaths) DESC
END;
GO
```

6. Top 5 de años con más muertes

```SQL
CREATE PROCEDURE dbo.Consulta6
AS
BEGIN
	SELECT TOP 5 t.[year], SUM(L2.total_deaths) as 'total_deaths'
	FROM Fact f
	JOIN [Time] t ON f.time_key = t.time_key
	JOIN Loss l2 ON l2.loss_key = f.loss_key
	GROUP BY t.[year]
	ORDER BY SUM(L2.total_deaths) DESC
END;
GO

```

7. Top 5 de años que más tsunamis han tenido

```SQL
CREATE PROCEDURE dbo.Consulta7
AS
BEGIN
	SELECT TOP 5 t.[year], COUNT(*) AS 'no_tsunamis'
	FROM Fact f
	JOIN [Time] t ON f.time_key = t.time_key
	GROUP BY t.[year]
	ORDER BY COUNT(*) DESC
END;
GO

```

8. Top 5 de países con mayor número de casas destruidas

```SQL
CREATE PROCEDURE dbo.Consulta8
AS
BEGIN
	SELECT TOP 5 c.name, SUM(D.total_houses_destroyed) as 'houses_destroyed'
	FROM Fact f
	JOIN Location l ON l.location_key = f.location_key
	JOIN Country c ON l.country_key = c.country_key
	JOIN Damage d ON d.damage_key = f.damage_key
	GROUP BY c.name
	ORDER BY SUM(D.total_houses_destroyed) DESC
END;
GO
```

9. Top 5 de países con mayor número de casas dañadas

```SQL
CREATE PROCEDURE dbo.Consulta9
AS
BEGIN
	SELECT TOP 5 c.name, SUM(d.total_houses_damaged) as 'houses_damaged'
	FROM Fact f
	JOIN Location l ON l.location_key = f.location_key
	JOIN Country c ON l.country_key = c.country_key
	JOIN Damage d ON d.damage_key = f.damage_key
	GROUP BY c.name
	ORDER BY SUM(D.total_houses_damaged) DESC
END;
GO
```

10. Promedio de altura máxima del agua por cada país.

```SQL
CREATE PROCEDURE dbo.Consulta10
AS
BEGIN
	SELECT c.name, AVG(t.max_water_height) as 'water_height'
	FROM Fact f
	JOIN Location l ON l.location_key = f.location_key
	JOIN Country c ON l.country_key = c.country_key
	JOIN Tsunami t ON t.tsunami_key = f.tsunami_key
	WHERE t.max_water_height != 0
	GROUP BY c.name
	ORDER BY c.name ASC
END;
GO
```

## Aplicación de Python

Para poder acceder a la información de la base de datos se creo una aplicacion de consola.

Al inicir, la aplicación carga todos los scripts necesarios para la creacion del modelo, la carga de datos y los procedimientos.

```Python
def load_scripts():
    # os.system('docker cp "/home/desquivel/Documents/Seminario2/Practica 1/historial_tsumamis.csv" sql-server:/data.csv')
    os.system('docker cp "/home/desquivel/Documents/SS2_Practica1_202010055/scripts/create_model.sql" sql-server:/create_model.sql > /dev/null')
    os.system('docker cp "/home/desquivel/Documents/SS2_Practica1_202010055/scripts/delete_model.sql" sql-server:/delete_model.sql > /dev/null')
    os.system('docker cp "/home/desquivel/Documents/SS2_Practica1_202010055/scripts/import_data.sql" sql-server:/import_data.sql > /dev/null')
    os.system('docker cp "/home/desquivel/Documents/SS2_Practica1_202010055/scripts/load_data.sql" sql-server:/load_data.sql > /dev/null')
    os.system('docker cp "/home/desquivel/Documents/SS2_Practica1_202010055/scripts/load_procs.sql" sql-server:/load_procs.sql > /dev/null')

```

Luego se muestra un menu donde el usuario debera ingresar la opcion que desea:

```Python
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
```

Cuando el usuario selecciona "Cargar CSV" el programa le pedira la ruta del CSV, luego de validar si esta es una ruta valida enviará el arvchivo CSV a la base de datos.

```Python
if option == 1:
    print("")
    path = input("Ingrese la ruta del archivo CSV: ")

    if not os.path.exists(path):
        print("El archivo no existe\n")
        continue

    os.system(f'docker cp "{path}" sql-server:/data.csv')
    print()
```

Si el usuario decide "Crear Modelo", "Eliminar Modelo" o "Extraer Datos" se utilizarán los scripts que se cargaron anteriormente, esto se ejecutan con el siguiente comando:

```Python
command = f"docker exec sql-server sh -c \"/opt/mssql-tools/bin/sqlcmd -S {SERVERNAME} -U {USER_NAME} -P {PASSWORD} -i /import_data.sql\" "

os.system(command)
```

Para hacer consultas el programa pedirá al usuario que ingrese la consulta que desea hacer:

```Python
cprint()
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
```

Una vez seleccionada la consulta el programa llama al stored procedure que ya esta cargado en la base de datos.

```Python
def consulta9():
    f = open("consultas/consulta9.txt", "w")

    command = ["docker", "exec", "-it", "sql-server", "/opt/mssql-tools/bin/sqlcmd", "-S",
               SERVERNAME, "-d", "Practica1", "-U", USER_NAME, "-P", PASSWORD, "-Q", "EXEC dbo.Consulta9"]

    subprocess.call(command, stdout=f)
```

Al hacer esto, el output de la consulta es guardado en un archivo de texto.
