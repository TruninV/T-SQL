--Проверка Email адреса
CREATE FUNCTION CheckEmail
(
	@Email VARCHAR(100) --Адрес электронной почты
)
RETURNS BIT
AS
BEGIN
/*
	***** Описание
		  Проверка адреса электронной почты (Email) на корректность.
		  Функция возвращает:
		    1 – Email корректен
		    0 – Email некорректен
		    NULL – если значение Email равно NULL

	***** Пример запуска
		  SELECT dbo.CheckEmail('123email456@gmail.com') AS CheckEmail;
		  
	***** Сайт - https://info-comp.ru
		  GitHub - 
		  
	*****Материалы для изучения T-SQL
		 https://info-comp.ru/t-sql-book.html
		 https://info-comp.ru/microsoft-sql-server
*/
	DECLARE @Result BIT;
	
	--Начинаем проверку только если есть данные
	IF @Email IS NOT NULL
	BEGIN	
		IF @Email LIKE '%[A-Z0-9][@][A-Z0-9]%[.][A-Z0-9]%' AND @Email NOT LIKE '%["<>'']%'
			SET @Result = 1;
		ELSE
			SET @Result = 0;
	END
	
	RETURN @Result;
END
