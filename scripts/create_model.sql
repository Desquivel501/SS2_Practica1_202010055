IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'Practica1')
BEGIN
	CREATE DATABASE Practica1
END
GO
       
USE Practica1
GO

DROP TABLE IF EXISTS    Temporal;
DROP TABLE IF EXISTS	Fact;
DROP TABLE IF EXISTS    Time;
DROP TABLE IF EXISTS    Epicenter;
DROP TABLE IF EXISTS    Tsunami;
DROP TABLE IF EXISTS    Loss;
DROP TABLE IF EXISTS    Damage;
DROP TABLE IF EXISTS    Location;
DROP TABLE IF EXISTS    Country;

CREATE TABLE Temporal(
    year 						int,
    month 						int,
    day 						int,
    hour 						int,
    minute						int,
    second						float,
    event_validity				int,
    cause_code 					int,
    earthquake_magnitude		decimal,
    deposits					int, 
    latitude					decimal,
    longitude					decimal,
    max_water_height			decimal,
    runups						int,
    tsunami_magnitude			decimal,
    intensity					decimal,
    total_deaths				int,
    total_missing 				int,
    total_missing_description	int, 
    total_injuries				int,
    total_damage				decimal,
    total_damage_description	int,
    total_houses_destroyed		int,
    total_houses_damaged		int,
    country						varchar(100),
    location					varchar(100)
);

CREATE TABLE Time(
	time_key	int IDENTITY(1,1) PRIMARY KEY,
	year		int,
    month		int,
    day			int,
    hour 		int,
    minute		int,
    second		float,
);

CREATE TABLE Epicenter(
	epicenter_key	int IDENTITY(1,1) PRIMARY KEY,
	longitude		decimal,
    latitude		decimal,
);

CREATE TABLE Tsunami(
	tsunami_key				int IDENTITY(1,1) PRIMARY KEY,
	event_validity			int,
    cause_code				decimal,
    earthquake_magnitude	decimal,
    deposits				int,
    max_water_height		decimal,
    runups					int,
    magnitude				decimal,
    intensity				decimal
);

CREATE TABLE Loss(
	loss_key					int IDENTITY(1,1) PRIMARY KEY,
	total_deaths				int,
    total_missing				int,
    total_missing_description	int,
    total_injuries				int
);

CREATE TABLE Damage(
	damage_key					int IDENTITY(1,1) PRIMARY KEY,
	total_damage				decimal,
    total_damage_description	int,
    total_houses_destroyed		int,
    total_houses_damaged		int
);

CREATE TABLE Country(
	country_key	int IDENTITY(1,1) PRIMARY KEY,
	name		varchar(100)
);

CREATE TABLE Location(
	location_key	int IDENTITY(1,1) PRIMARY KEY,
	name			varchar(100),
	country_key		int,
	FOREIGN KEY (country_key) REFERENCES Country(country_key)
);


CREATE TABLE Fact(
	fact_key		int IDENTITY(1,1) PRIMARY KEY,
	time_key		int,
	epicenter_key	int, 
	tsunami_key		int,
	loss_key		int,
	damage_key		int, 
	location_key	int,
	FOREIGN KEY (time_key) REFERENCES Time(time_key),
	FOREIGN KEY (epicenter_key) REFERENCES Epicenter(epicenter_key),
	FOREIGN KEY (tsunami_key) REFERENCES Tsunami(tsunami_key),
	FOREIGN KEY (loss_key) REFERENCES Loss(loss_key),
	FOREIGN KEY (damage_key) REFERENCES Damage(damage_key),
	FOREIGN KEY (location_key) REFERENCES Location(location_key)
);