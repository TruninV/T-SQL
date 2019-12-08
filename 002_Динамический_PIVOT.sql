--Хранимая процедура для формирования динамического запроса PIVOT
CREATE PROCEDURE Dynamic_PIVOT
 (
    @TableSRC NVARCHAR(100),   --Таблица источник (Представление)
    @ColumnName NVARCHAR(100), --Столбец, содержащий значения, которые станут именами столбцов
    @Field NVARCHAR(100),      --Столбец, над которым проводить агрегацию
    @FieldRows NVARCHAR(100),  --Столбец (столбцы) для группировки по строкам (Column1, Column2)
    @FunctionType NVARCHAR(20) = 'SUM',--Агрегатная функция (SUM, COUNT, MAX, MIN, AVG), по умолчанию SUM
    @Condition NVARCHAR(200) = '' --Условие (WHERE и т.д.). По умолчанию без условия
 )
AS 
BEGIN
/*
	***** Название
		  Dynamic_PIVOT - Хранимая процедура для формирования динамического запроса PIVOT
		 
	***** Описание
		  Хранимая процедура динамически формирует запрос PIVOT. 
		  Таким образом, вручную указывать ничего не нужно, достаточно указать таблицу и названия столбцов в параметрах при вызове процедуры.

	***** Пример запуска
		  EXEC Dynamic_PIVOT @TableSRC = 'TestTable',
							 @ColumnName = 'YearSales',
							 @Field = 'Summa',
							 @FieldRows = 'CategoryName',
							 @FunctionType = 'SUM';
				  
	***** Разработчик
		  Виталий Трунин
		  Сайт - https://info-comp.ru
		  GitHub - https://github.com/TruninV/T-SQL
		  
	*****Материалы для изучения T-SQL
		 https://info-comp.ru/t-sql-book.html
		 https://info-comp.ru/microsoft-sql-server
	  
*/
    --Отключаем вывод количества строк
    SET NOCOUNT ON;
        
    --Переменная для хранения строки запроса
    DECLARE @Query NVARCHAR(MAX);                     
    --Переменная для хранения имен столбцов
    DECLARE @ColumnNames NVARCHAR(MAX);              
    --Переменная для хранения заголовков результирующего набора данных
    DECLARE @ColumnNamesHeader NVARCHAR(MAX); 

    --Обработчик ошибок
    BEGIN TRY
        --Таблица для хранения уникальных значений, 
        --которые будут использоваться в качестве столбцов      
        CREATE TABLE #ColumnNames(ColumnName NVARCHAR(100) NOT NULL PRIMARY KEY);
        
        --Формируем строку запроса для получения уникальных значений для имен столбцов
        SET @Query = N'INSERT INTO #ColumnNames (ColumnName)
                            SELECT DISTINCT COALESCE(' + @ColumnName + ', ''Пусто'') 
                            FROM ' + @TableSRC + ' ' + @Condition + ';'
                
        --Выполняем строку запроса
        EXEC (@Query);

        --Формируем строку с именами столбцов
        SELECT @ColumnNames = ISNULL(@ColumnNames + ', ','') + QUOTENAME(ColumnName) 
        FROM #ColumnNames;
                
        --Формируем строку для заголовка динамического перекрестного запроса (PIVOT)
        SELECT @ColumnNamesHeader = ISNULL(@ColumnNamesHeader + ', ','') 
                                                              + 'COALESCE('
                                                              + QUOTENAME(ColumnName) 
                                                              + ', 0) AS '
                                                              + QUOTENAME(ColumnName)
        FROM #ColumnNames;
        
        --Формируем строку с запросом PIVOT
        SET @Query = N'SELECT ' + @FieldRows + ' , ' + @ColumnNamesHeader + ' 
                       FROM (SELECT ' + @FieldRows + ', ' + @ColumnName + ', ' + @Field 
                                      + ' FROM ' + @TableSRC  + ' ' + @Condition + ') AS SRC
                       PIVOT ( ' + @FunctionType + '(' + @Field + ')' +' FOR ' +  
                                   @ColumnName + ' IN (' + @ColumnNames + ')) AS PVT
                       ORDER BY ' + @FieldRows + ';'
                
        --Удаляем временную таблицу
        DROP TABLE #ColumnNames;
				
        --Выполняем строку запроса с PIVOT
        EXEC (@Query);
                
        --Включаем обратно вывод количества строк
        SET NOCOUNT OFF;
                
    END TRY
    BEGIN CATCH
        --В случае ошибки, возвращаем номер и описание этой ошибки
        SELECT ERROR_NUMBER() AS [Номер ошибки], 
               ERROR_MESSAGE() AS [Описание ошибки]
    END CATCH
END
