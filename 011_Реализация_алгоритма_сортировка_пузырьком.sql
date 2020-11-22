--Хранимая процедура, в которой реализован алгоритм «Сортировка пузырьком»
CREATE PROCEDURE bubble_sort
AS 
BEGIN
	/*
		***** Описание
		      Пример реализации на T-SQL алгоритма «Сортировка пузырьком».
		
		***** Пример запуска
		      EXEC bubble_sort;
			  
		***** Сайт - https://info-comp.ru
		       GitHub - https://github.com/TruninV/T-SQL
			  
		***** Материалы для изучения T-SQL
		      https://self-learning.ru/databases
		      https://info-comp.ru/microsoft-sql-server
			
		***** Курсы по T-SQL
		      https://self-learning.ru/courses/t-sql
	*/
	
	--Табличная переменная для хранения массива данных с числами
	--Индекс массива начинается с 0
	DECLARE @data_array TABLE (array_index INT NOT NULL IDENTITY(0, 1) PRIMARY KEY,
							   value INT NOT NULL);
	--Добавление данных в табличную переменную
	INSERT INTO @data_array
		VALUES (5),(2),(1),(3),(9),(0),(4),(6),(8),(7);
		
	--Вывод данных до сортировки
	SELECT array_index, value
	FROM @data_array;

	DECLARE @current_element INT, --Текущий элемент в массиве
			@amount_elements INT, --Количество элементов в массиве
			@continue_sort BIT;   --Признак для продолжения сортировки
	
	--Переменные для хранения значений массива
	DECLARE @value1 INT, 
			@value2 INT;

	--Определяем количество элементов в массиве, учитывая, что он начинается с 0
	SELECT @amount_elements = COUNT(*) - 1
	FROM @data_array;
	
	SET @continue_sort = 1;
	
	/*
		@continue_sort = 1 - продолжать сортировку, массив не отсортирован
		@continue_sort = 0 - сортировка завершена, массив отсортирован
	*/
	
	--Запуск цикла для прохода по массиву
	WHILE @continue_sort = 1
	BEGIN
		--Сразу отмечаем, что сортировку нужно завершить, в случае если не будет обмена значениями
		SET @continue_sort = 0;
		
		--Проход по массиву начинаем с первого элемента
		SET @current_element = 0;
		
		--Запуск цикла для сравнения значений массива в текущем проходе
		WHILE @current_element < @amount_elements
		BEGIN

			SELECT @value1 = 0,
				   @value2 = 0;
			
			--Получаем первые значения в массиве
			SELECT @value1 = value 
			FROM @data_array 
			WHERE array_index = @current_element;

			SELECT @value2 = value 
			FROM @data_array 
			WHERE array_index = @current_element + 1;
			
			--Сравнение значений
			--Если первое значение больше второго, то необходимо поменять их местами
			IF @value1 > @value2 
			BEGIN
				UPDATE @data_array SET value = @value2
				WHERE array_index = @current_element;

				UPDATE @data_array SET value = @value1
				WHERE array_index = @current_element + 1;
				
				--Произошел обмен значениями, значит сортировку следует продолжать
				SET @continue_sort = 1;
			END
			
			--Двигаемся дальше по массиву
			SET @current_element = @current_element + 1;
		END
	/*
		После прохода по массиву в его конце оказываются отсортированные элементы
		Исключаем их, для уменьшения количества интераций (сравнений)
	*/
	SET @amount_elements = @amount_elements - 1;

	END
	
	--Вывод данных после сортировки
	SELECT array_index, value
	FROM @data_array;

END
