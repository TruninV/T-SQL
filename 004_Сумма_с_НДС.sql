--Сумма с НДС
CREATE FUNCTION SummaWithNDS
(
	@Summa FLOAT, --Сумма
	@Nds INT      --Значение НДС
)
RETURNS FLOAT
AS
BEGIN	
/*
	***** Описание
	      Функция возвращает сумму с учетом НДС

	***** Пример запуска
	      SELECT dbo.SummaWithNDS(100, 20) AS SummaWithNDS;
				  
	***** Сайт - https://info-comp.ru
	      GitHub - https://github.com/TruninV/T-SQL
		  
	***** Материалы для изучения T-SQL
	      https://info-comp.ru/t-sql-book.html
	      https://info-comp.ru/microsoft-sql-server
*/	
	DECLARE @SummaWithNDS FLOAT;
	--Если значение НДС отрицательно, то возвращается просто сумма
	IF @Nds > 0
		SET @SummaWithNDS = @Summa * (100 + @Nds) / 100;
	ELSE
		SET @SummaWithNDS = @Summa;
		
	RETURN ROUND(@SummaWithNDS, 8);
END
