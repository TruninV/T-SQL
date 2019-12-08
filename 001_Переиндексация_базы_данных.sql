--�������� ��������� ��� �������� �������������� ���� ������
CREATE PROCEDURE ReIndexDB 
(
	@DbId SMALLINT = NULL --������������� ���� ������
)
AS
BEGIN
/*
	***** ��������
		  ReIndexDB - �������� ��������� ��� �������� �������������� ���� ������
		 
	***** ��������
		  ��������� ������������� ��� ���������������� ������� � ���� ������ � ����������� �� ������� �� ������������:
			� ���� ������� ������������ ����� 5%, ������ ������������� ��� ���������������� �� �����;
			� ���� ������� ������������ �� 5 �� 30%, ����� ��������� ������������� �������;
			� ���� ������� ������������ ����� 30%, ����� ��������� ������������ �������.
		  � �������� ��������� ��������� ������������� ���� ������, ������� ���������� �����������������. 
		  ���� �� ������� ��������, �� ��������� ��������������� ������� ��.
		 
	***** ������ �������
		  EXEC ReIndexDB;
		  
	***** �����������
		  ������� ������
		  ���� - https://info-comp.ru
		  GitHub - 
		  
	****��������� ��� �������� T-SQL	  
		 https://info-comp.ru/t-sql-book.html
		 https://info-comp.ru/microsoft-sql-server
	  
*/
    --��������� ����� ���������� �����
    --����� ���������� ������ ������������ ��� ����������
    SET NOCOUNT ON; 

    --��������� ���������� ��� �������� �������� �������� (��������, ������) ��� ������������
    DECLARE @IndexTmpTable TABLE (Id INT IDENTITY(1,1) PRIMARY KEY,
                                   SchemaName SYSNAME, 
                                   TableName SYSNAME, 
                                   IndexName SYSNAME, 
                                   AvgFrag FLOAT);
	--��������������� ����������
    DECLARE @RowNumber INT = 1, @CntRows INT, @CntReorganize INT = 0, @CntRebuild INT = 0;
    DECLARE @SchemaName SYSNAME, @TableName SYSNAME, @IndexName SYSNAME, @AvgFrag FLOAT;
    DECLARE @Command VARCHAR(8000);

    --������������� �� (����� �������� �� �������� ���������, �� ��������� �������)
    SELECT @DbId = COALESCE(@DbId, DB_ID()); 

    --���������� ������� ������������ �������� �� ������ ��������� ��������� �������
    --sys.dm_db_index_physical_stats, � ����� �������� �������� � ��������������� ������
    INSERT INTO @IndexTmpTable
        SELECT Sch.name AS SchemaName,
                     Obj.name AS TableName,
                     Inx.name AS IndexName, 
                     AvgFrag.avg_fragmentation_in_percent AS Fragmentation 
            FROM sys.dm_db_index_physical_stats (@DbId, NULL, NULL, NULL, NULL) AS AvgFrag
            LEFT JOIN sys.indexes AS Inx ON AvgFrag.object_id = Inx.object_id AND AvgFrag.index_id = Inx.index_id
            LEFT JOIN sys.objects AS Obj ON AvgFrag.object_id = Obj.object_id 
              LEFT JOIN sys.schemas AS Sch ON Obj.schema_id = Sch.schema_id
              WHERE AvgFrag.index_id > 0 
                AND AvgFrag.avg_fragmentation_in_percent > 5; --5 - ��� ����������� ������� ������������ �������

    --���������� ����� ��� ���������
    SELECT @CntRows = COUNT(*)
    FROM @IndexTmpTable;

    --���� ��������� ������� �������
    WHILE @RowNumber <= @CntRows
        BEGIN
            --�������� �������� ��������, � ����� ������� ������������ �������� �������
            SELECT @SchemaName = SchemaName, 
                   @TableName = TableName, 
                   @IndexName = IndexName, 
                   @AvgFrag = AvgFrag
            FROM @IndexTmpTable
            WHERE Id = @RowNumber;
                        
            --���� ������� ������������ ����� 30%, ��������� ������������� �������
            IF @AvgFrag < 30
                BEGIN
					--��������� ������ ���������� � ��������� ��
                    SELECT @Command = 'ALTER INDEX [' + @IndexName + '] ON ' + '[' + @SchemaName + ']' 
                                          + '.[' + @TableName + '] REORGANIZE';
                    EXEC (@Command);
                    SET @CntReorganize = @CntReorganize + 1; --���������� ���������������� ��������
                END 
                        
            --���� ������� ������������ ����� 30%, ��������� ������������ �������
            IF @AvgFrag >= 30
                BEGIN
                    --��������� ������ ���������� � ��������� ��
                    SELECT @Command = 'ALTER INDEX [' + @IndexName + '] ON ' + '[' + @SchemaName + ']' 
                                            + '.[' + @TableName + '] REBUILD';
                    EXEC (@Command);
                    SET @CntRebuild = @CntRebuild + 1; --���������� ������������� ��������
                END
                        
            --������� ��������� ���������� � ������� ��������
            PRINT '��������� ���������� ' + @Command;
                        
            --��������� � ���������� �������
            SET @RowNumber = @RowNumber + 1;
		END
                
    --����
    PRINT '����� ���������� ��������: ' + CAST(@CntRows AS VARCHAR(10)) 
          + ', ��������������: ' + CAST(@CntReorganize AS VARCHAR(10)) 
          + ', �����������: ' + CAST(@CntRebuild AS VARCHAR(10));
		
	--�������� ������� ����� ���������� �����
    SET NOCOUNT OFF;
END
