--Сумма НДС
CREATE FUNCTION SummaNDS 
(
	@Summa FLOAT, --Сумма
	@Nds INT	  --Значение НДС
) 
RETURNS FLOAT
AS
BEGIN
/*
	***** Описание
		  Функция возвращает сумму НДС от @Summa

	***** Пример запуска
		  SELECT dbo.SummaNDS(100, 20) AS SummaNDS;
				  
	***** Сайт - https://info-comp.ru
		  GitHub - 
		  
	*****Материалы для изучения T-SQL
		 https://info-comp.ru/t-sql-book.html
		 https://info-comp.ru/microsoft-sql-server
*/
	DECLARE @SummaNDS FLOAT;
	--Если значение НДС отрицательно, то возвращается 0
	IF @Nds > 0
		SET @SummaNDS = @Nds * (@Summa / (100 + @Nds));
	ELSE
		SET @SummaNDS = 0;
		
	RETURN ROUND(@SummaNDS, 8);
END
