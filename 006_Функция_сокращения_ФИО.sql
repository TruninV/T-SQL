--Функция сокращения ФИО
CREATE FUNCTION ShortFIO
(
	@SurName VARCHAR(100),   --Фамилия
	@FirstName VARCHAR(100), --Имя
	@Patronymic VARCHAR(100) --Отчество
)
RETURNS VARCHAR(300)
AS
BEGIN
/*
	***** Описание
	      Функция сокращает Фамилию Имя Отчество, например, Иванов Иван Иванович => Иванов И.И.
	      Каждая часть ФИО должна передаваться отдельно.
              Функция сокращает ФИО только если есть все данные.

	***** Пример запуска
	      SELECT dbo.ShortFIO('Иванов', 'Иван', 'Иванович') AS ShortFIO;
				  
	***** Сайт - https://info-comp.ru
	      GitHub - https://github.com/TruninV/T-SQL
		  
	***** Материалы для изучения T-SQL
	      https://info-comp.ru/t-sql-book.html
	      https://info-comp.ru/microsoft-sql-server
*/
	DECLARE @FIO VARCHAR(300); 
	--Сокращаем ФИО только если есть все данные
	IF @SurName IS NOT NULL AND @FirstName IS NOT NULL AND @Patronymic IS NOT NULL
		SET @FIO = UPPER(SUBSTRING(LTRIM(RTRIM(@SurName)), 1, 1)) + LOWER(SUBSTRING(LTRIM(RTRIM(@SurName)), 2, LEN(LTRIM(RTRIM(@SurName))))) +
			   ' ' + 
			   UPPER(SUBSTRING(LTRIM(RTRIM(@FirstName)), 1, 1)) + 
			   '. ' + 
			   UPPER(SUBSTRING(LTRIM(RTRIM(@Patronymic)), 1, 1)) + 
				   '.';
	RETURN @FIO;
END
