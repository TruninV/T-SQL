--Табличная функция для генерации пронумерованных записей
CREATE FUNCTION generating_rows 
(
	@quantity_rows BIGINT
)
RETURNS TABLE
AS 
RETURN(
		/*
		***** Описание
		      Формирование строк с последовательностью чисел.
		
		***** Функция возвращает таблицу, которая содержит @quantity_rows пронумерованных записей.
			  
		***** Пример запуска
		      SELECT * FROM generating_rows(100000);
			  
		***** Сайт - https://info-comp.ru
		      GitHub - https://github.com/TruninV/T-SQL
			  
		***** Материалы для изучения T-SQL
		      https://self-learning.ru/databases
		      https://info-comp.ru/microsoft-sql-server
			
		***** Курсы по T-SQL 
		      https://self-learning.ru/courses/t-sql
	*/
	WITH SrcRows AS ( 
		SELECT NumberRow
		FROM (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10)) AS SR (NumberRow)
	) 
	   SELECT RowNumber
		FROM (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS RowNumber 
			  FROM SrcRows AS Ten, 
				   SrcRows AS Hundred,
				   SrcRows AS Thousand, 
				   SrcRows AS TenThousand, 
				   SrcRows AS HundredThousand,
				   SrcRows AS Million,
				   SrcRows AS TenMillions
			  )  AS ResultingRows
			  WHERE RowNumber <= @quantity_rows
)
