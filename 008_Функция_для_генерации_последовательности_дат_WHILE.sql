--Табличная функция для генерации последовательности дат (способ 1 – WHILE)
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
			  Способ подразумевает использование цикла.
		
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
	
	--Запускаем цикл. Он будет завершен, когда дойдем до даты окончания.
	WHILE @DateStart <= @DateEnd
	BEGIN
		--Добавляем запись со значением даты в результирующую таблицу.
		INSERT INTO @ListDates
			VALUES(@DateStart)
		
		SET @DateStart = DATEADD(DAY, 1, @DateStart) -- Увеличиваем значение даты на 1 день
	END  
	
	RETURN
END