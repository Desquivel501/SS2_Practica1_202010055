USE Practica1
GO

INSERT INTO Country (name)
SELECT DISTINCT country
    FROM Temporal
    WHERE country IS NOT NULL
    
    
INSERT INTO Location (name, country_key)
SELECT DISTINCT location, c.country_key
    FROM Temporal t
    INNER JOIN Country c ON c.name = t.country    
    WHERE location IS NOT NULL
    

INSERT INTO [Time] ([year], [month], [day], [hour], [minute], [second])
SELECT DISTINCT [year], [month], [day], [hour], [minute], [second]
	FROM Temporal
	
	
INSERT INTO Epicenter (longitude, latitude)
SELECT DISTINCT longitude, latitude 
	FROM Temporal 
	
INSERT INTO Loss (total_deaths, total_missing, total_missing_description, total_injuries)
SELECT DISTINCT total_deaths, total_missing, total_missing_description, total_injuries 
	FROM Temporal 
	
INSERT INTO Damage (total_damage, total_damage_description, total_houses_destroyed, total_houses_damaged)
SELECT DISTINCT total_damage, total_damage_description, total_houses_destroyed, total_houses_damaged 
	FROM Temporal 
	

INSERT INTO Tsunami (event_validity, cause_code, earthquake_magnitude, deposits, max_water_height, runups, magnitude, intensity)
SELECT DISTINCT event_validity, cause_code, earthquake_magnitude, deposits, max_water_height, runups, tsunami_magnitude , intensity 
	FROM Temporal 
	
	
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