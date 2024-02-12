USE Practica1
GO

DROP PROCEDURE IF EXISTS dbo.Consulta1;
GO 
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


DROP PROCEDURE IF EXISTS dbo.Consulta2;
GO
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


DROP PROCEDURE IF EXISTS dbo.Consulta2;
GO
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


DROP PROCEDURE IF EXISTS dbo.Consulta3;
GO
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


DROP PROCEDURE IF EXISTS dbo.Consulta4;
GO
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


DROP PROCEDURE IF EXISTS dbo.Consulta5;
GO
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


DROP PROCEDURE IF EXISTS dbo.Consulta6;
GO
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


DROP PROCEDURE IF EXISTS dbo.Consulta7;
GO
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


DROP PROCEDURE IF EXISTS dbo.Consulta8;
GO
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


DROP PROCEDURE IF EXISTS dbo.Consulta9;
GO
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


DROP PROCEDURE IF EXISTS dbo.Consulta10;
GO
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
