USE Practica1
GO

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