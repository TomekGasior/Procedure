-- ================================================
-- Napisz procedure� sk�adowana� podsumowujaca prace
-- przewoznik�w w danym roku. Nalezy podliczyc, ile kazdy z
-- dostawc�w obs�uzy� zam�wien w roku, kt�rego wartosc jest
-- przekazywana jako parametr. W wyniku zaznacz, na kt�rym  
-- miejscu jest dany przewoznik w ilosci obs�uzonych zam�wien.
-- Jezeli w zadanym roku nie ma zadnych zam�wien nalezy zg�osic
-- b�ad przy pomocy RAISERROR. Kod procedury sk�adowanej
-- powinien r�wniez wykorzystywac blok TRY-CATCH, kt�ry obs�uzy
-- potencjalny b�ad wyswietlajac: nazwe procedury oraz numer linii w
-- kt�rej wystapi� b�ad, komunikat oraz kod b�edu.
-- Baza: Northwind.
-- Tabele: Orders, Shippers.
-- Kolumny: CompanyName, OrderDate, ShipVia, ShipperID.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tomasz G�sior
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
				raiserror('Dla podanej daty nie ma �adnych zam�wie�!',17,127)
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
		PRINT 'B��d w procedurze ' + ERROR_PROCEDURE() + '!';
		PRINT 'B��d wyst�puje w lini numer ' + CAST(ERROR_LINE() AS NVARCHAR(10)) + '.';
		PRINT 'Tre�� b��du: ' + ERROR_MESSAGE();
		PRINT 'Numer b��du ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
	END CATCH

END
GO

exec lab2zad5 1999