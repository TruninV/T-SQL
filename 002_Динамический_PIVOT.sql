--�������� ��������� ��� ������������ ������������� ������� PIVOT
CREATE PROCEDURE Dynamic_PIVOT
 (
    @TableSRC NVARCHAR(100),   --������� �������� (�������������)
    @ColumnName NVARCHAR(100), --�������, ���������� ��������, ������� ������ ������� ��������
    @Field NVARCHAR(100),      --�������, ��� ������� ��������� ���������
    @FieldRows NVARCHAR(100),  --������� (�������) ��� ����������� �� ������� (Column1, Column2)
    @FunctionType NVARCHAR(20) = 'SUM',--���������� ������� (SUM, COUNT, MAX, MIN, AVG), �� ��������� SUM
    @Condition NVARCHAR(200) = '' --������� (WHERE � �.�.). �� ��������� ��� �������
 )
AS 
BEGIN
/*
	***** ��������
		  Dynamic_PIVOT - �������� ��������� ��� ������������ ������������� ������� PIVOT
		 
	***** ��������
		  �������� ��������� ����������� ��������� ������ PIVOT. 
		  ����� �������, ������� ��������� ������ �� �����, ���������� ������� ������� � �������� �������� � ���������� ��� ������ ���������.

	***** ������ �������
		  EXEC Dynamic_PIVOT @TableSRC = 'TestTable',
							 @ColumnName = 'YearSales',
							 @Field = 'Summa',
							 @FieldRows = 'CategoryName',
							 @FunctionType = 'SUM';
				  
	***** �����������
		  ������� ������
		  ���� - https://info-comp.ru
		  GitHub - 
		  
	*****��������� ��� �������� T-SQL
		 https://info-comp.ru/t-sql-book.html
		 https://info-comp.ru/microsoft-sql-server
	  
*/
    --��������� ����� ���������� �����
    SET NOCOUNT ON;
        
    --���������� ��� �������� ������ �������
    DECLARE @Query NVARCHAR(MAX);                     
    --���������� ��� �������� ���� ��������
    DECLARE @ColumnNames NVARCHAR(MAX);              
    --���������� ��� �������� ���������� ��������������� ������ ������
    DECLARE @ColumnNamesHeader NVARCHAR(MAX); 

    --���������� ������
    BEGIN TRY
        --������� ��� �������� ���������� ��������, 
        --������� ����� �������������� � �������� ��������      
        CREATE TABLE #ColumnNames(ColumnName NVARCHAR(100) NOT NULL PRIMARY KEY);
        
        --��������� ������ ������� ��� ��������� ���������� �������� ��� ���� ��������
        SET @Query = N'INSERT INTO #ColumnNames (ColumnName)
                            SELECT DISTINCT COALESCE(' + @ColumnName + ', ''�����'') 
                            FROM ' + @TableSRC + ' ' + @Condition + ';'
                
        --��������� ������ �������
        EXEC (@Query);

        --��������� ������ � ������� ��������
        SELECT @ColumnNames = ISNULL(@ColumnNames + ', ','') + QUOTENAME(ColumnName) 
        FROM #ColumnNames;
                
        --��������� ������ ��� ��������� ������������� ������������� ������� (PIVOT)
        SELECT @ColumnNamesHeader = ISNULL(@ColumnNamesHeader + ', ','') 
                                                              + 'COALESCE('
                                                              + QUOTENAME(ColumnName) 
                                                              + ', 0) AS '
                                                              + QUOTENAME(ColumnName)
        FROM #ColumnNames;
        
        --��������� ������ � �������� PIVOT
        SET @Query = N'SELECT ' + @FieldRows + ' , ' + @ColumnNamesHeader + ' 
                       FROM (SELECT ' + @FieldRows + ', ' + @ColumnName + ', ' + @Field 
                                      + ' FROM ' + @TableSRC  + ' ' + @Condition + ') AS SRC
                       PIVOT ( ' + @FunctionType + '(' + @Field + ')' +' FOR ' +  
                                   @ColumnName + ' IN (' + @ColumnNames + ')) AS PVT
                       ORDER BY ' + @FieldRows + ';'
                
        --������� ��������� �������
        DROP TABLE #ColumnNames;
				
        --��������� ������ ������� � PIVOT
        EXEC (@Query);
                
        --�������� ������� ����� ���������� �����
        SET NOCOUNT OFF;
                
    END TRY
    BEGIN CATCH
        --� ������ ������, ���������� ����� � �������� ���� ������
        SELECT ERROR_NUMBER() AS [����� ������], 
               ERROR_MESSAGE() AS [�������� ������]
    END CATCH
END
