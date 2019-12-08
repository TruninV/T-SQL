--Функция для транслитерации текста
CREATE FUNCTION Translit
(
	@SrcText VARCHAR(4000) --Исходный текст
)  
RETURNS VARCHAR(8000) AS  
BEGIN 
 /*
	***** Название
		  Функция для транслитерации русскоязычного текста.
		 
	***** Описание
		  Функция для транслитерации русскоязычного текста по ГОСТ 7.79-2000.
		  Транслитерация – это побуквенная передача слова или текста, написанного при помощи одной алфавитной системы, средствами другой алфавитной системы.
		  Данная функция отображает русскоязычный текст английскими буквами.

	***** Пример запуска
		  SELECT dbo.Translit ('Функция для транслитерации русскоязычного текста') AS Translit;
				  
	***** Сайт - https://info-comp.ru
		  GitHub - 
		  
	*****Материалы для изучения T-SQL
		 https://info-comp.ru/t-sql-book.html
		 https://info-comp.ru/microsoft-sql-server
	  
*/
	--Объявление вспомогательных переменных
	DECLARE @ResultText VARCHAR(8000) = '',
			@Rus VARCHAR(100) = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя', --Русские буквы
			@Lat1 VARCHAR(100) = 'abvgdejzzijklmnoprstufkccss"y''ejj', --Транслитерация
			@Lat2 VARCHAR(100) = '      oh  j           h hhh   hua', --Дополнительный символ для транслитерации
			@Lat3 VARCHAR(100) = '                          h      '; --Дополнительный символ для транслитерации

	DECLARE @Сounter INT, --Счетчик
			@Position INT, --Позиция
			@Char VARCHAR(2); --Символ
	
	SET @Сounter = 1;
	
	--Запускаем цикл для обработки каждого символа
	WHILE @Сounter <= LEN(@SrcText)
	BEGIN
		SELECT @Char = SUBSTRING(@SrcText, @Сounter, 1), --Узнаем символ
			   @Position = CHARINDEX(LOWER(@Char), @Rus); --Узнаем позицию
		
		--Формируем результирующую строку
		IF @Position > 0
		BEGIN
			IF ASCII(UPPER(@Char)) = ASCII(@Char)
				SET @ResultText = @ResultText + UPPER(SUBSTRING(@Lat1, @Position, 1)) + RTRIM(SUBSTRING(@Lat2, @Position, 1)) + RTRIM(SUBSTRING(@Lat3, @Position, 1));
			ELSE
				SET @ResultText = @ResultText + SUBSTRING(@Lat1, @Position, 1) + RTRIM(SUBSTRING(@Lat2, @Position, 1)) + RTRIM(SUBSTRING(@Lat3, @Position, 1));
		END
		ELSE
			SET @ResultText = @ResultText + @Char;
		SET @Сounter = @Сounter + 1;
	END
	
	RETURN @ResultText;
END