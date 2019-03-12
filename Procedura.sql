-- ================================================
-- Napisz procedure² sk³adowana² podsumowujaca prace
-- przewozników w danym roku. Nalezy podliczyc, ile kazdy z
-- dostawców obs³uzy³ zamówien w roku, którego wartosc jest
-- przekazywana jako parametr. W wyniku zaznacz, na którym  
-- miejscu jest dany przewoznik w ilosci obs³uzonych zamówien.
-- Jezeli w zadanym roku nie ma zadnych zamówien nalezy zg³osic
-- b³ad przy pomocy RAISERROR. Kod procedury sk³adowanej
-- powinien równiez wykorzystywac blok TRY-CATCH, który obs³uzy
-- potencjalny b³ad wyswietlajac: nazwe procedury oraz numer linii w
-- której wystapi³ b³ad, komunikat oraz kod b³edu.
-- Baza: Northwind.
-- Tabele: Orders, Shippers.
-- Kolumny: CompanyName, OrderDate, ShipVia, ShipperID.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tomasz G¹sior
-- Create date: 28.02.2018
-- Description:	-
-- =============================================
alter PROCEDURE [dbo].[lab2zad5] 
	@rok int
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF ((SELECT count(orderdate)
			FROM orders
			WHERE year(OrderDate)=@rok) = 0)
			BEGIN
				raiserror('Dla podanej daty nie ma ¿adnych zamówieñ!',17,127)
			END
		ELSE
			BEGIN
				SELECT (s.CompanyName),
				cast(@rok AS VARCHAR(4)) AS 'Year',
				count(o.OrderDate) as 'Quantity of orders' ,
				RANK() OVER( ORDER BY count(o.OrderDate) DESC) AS 'Shippers rank'
				FROM Orders o join Shippers s on o.ShipVia=s.ShipperID
				WHERE year(o.OrderDate)=@rok
				GROUP BY s.CompanyName
			END
	END TRY

	BEGIN CATCH
		PRINT 'B³¹d w procedurze ' + ERROR_PROCEDURE() + '!';
		PRINT 'B³¹d wystêpuje w lini numer ' + CAST(ERROR_LINE() AS NVARCHAR(10)) + '.';
		PRINT 'Treœæ b³êdu: ' + ERROR_MESSAGE();
		PRINT 'Numer b³êdu ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
	END CATCH

END
GO

exec lab2zad5 1999