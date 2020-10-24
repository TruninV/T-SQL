--Табличная функция для генерации последовательности дат (способ 2 – WITH)
CREATE FUNCTION GeneratingDates (
	@DateStart DATE, -- Дата начала
	@DateEnd DATE	 -- Дата окончания
)
RETURNS @ListDates TABLE (dt DATE) 
AS
BEGIN
	/*
		***** Описание
		      Генерация последовательности дат в заданном диапазоне.
		      Способ подразумевает использование рекурсивного обобщенного табличного выражения.
		
		***** Функция возвращает таблицу с датами в диапазоне, который задан в параметрах.
		      Даты формируются начиная @DateStart и заканчивая @DateEnd.
			  
		***** Пример запуска
		      SELECT * FROM GeneratingDates('01.01.2020','31.12.2020');
			  
		***** Сайт - https://info-comp.ru
		      GitHub - https://github.com/TruninV/T-SQL
			  
		***** Материалы для изучения T-SQL
		      https://self-learning.ru/databases
		      https://info-comp.ru/microsoft-sql-server
			
		***** Курсы по T-SQL 
		      https://self-learning.ru/courses/t-sql
	*/
	--Рекурсивное обобщенное табличное выражение.
	WITH Dates AS
	(
		SELECT @DateStart AS DateStart -- Задаем якорь рекурсии
	
		UNION ALL

		SELECT DATEADD(DAY, 1, DateStart) AS DateStart -- Увеличиваем значение даты на 1 день
		FROM Dates
		WHERE DateStart < @DateEnd -- Прекращаем выполнение, когда дойдем до даты окончания
	)
	INSERT INTO @ListDates
		SELECT DateStart 
		FROM Dates
		OPTION (MAXRECURSION 0); 
		/*
			Значением 0 снимаем серверное ограничение на количество уровней рекурсии (которое по умолчанию равно 100), 
			чтобы иметь возможность формировать даты в большом диапазоне.
		*/
  RETURN
END
