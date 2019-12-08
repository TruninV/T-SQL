--������� ��� �������������� ������
CREATE FUNCTION Translit
(
	@SrcText VARCHAR(4000) --�������� �����
)  
RETURNS VARCHAR(8000) AS  
BEGIN 
 /*
	***** ��������
		  ������� ��� �������������� �������������� ������.
		 
	***** ��������
		  ������� ��� �������������� �������������� ������ �� ���� 7.79-2000.
		  �������������� � ��� ����������� �������� ����� ��� ������, ����������� ��� ������ ����� ���������� �������, ���������� ������ ���������� �������.
		  ������ ������� ���������� ������������� ����� ����������� �������.

	***** ������ �������
		  SELECT dbo.Translit ('������� ��� �������������� �������������� ������') AS Translit;
				  
	***** ���� - https://info-comp.ru
		  GitHub - 
		  
	*****��������� ��� �������� T-SQL
		 https://info-comp.ru/t-sql-book.html
		 https://info-comp.ru/microsoft-sql-server
	  
*/
	--���������� ��������������� ����������
	DECLARE @ResultText VARCHAR(8000) = '',
			@Rus VARCHAR(100) = '��������������������������������', --������� �����
			@Lat1 VARCHAR(100) = 'abvgdejzzijklmnoprstufkccss"y''ejj', --��������������
			@Lat2 VARCHAR(100) = '      oh  j           h hhh   hua', --�������������� ������ ��� ��������������
			@Lat3 VARCHAR(100) = '                          h      '; --�������������� ������ ��� ��������������

	DECLARE @�ounter INT, --�������
			@Position INT, --�������
			@Char VARCHAR(2); --������
	
	SET @�ounter = 1;
	
	--��������� ���� ��� ��������� ������� �������
	WHILE @�ounter <= LEN(@SrcText)
	BEGIN
		SELECT @Char = SUBSTRING(@SrcText, @�ounter, 1), --������ ������
			   @Position = CHARINDEX(LOWER(@Char), @Rus); --������ �������
		
		--��������� �������������� ������
		IF @Position > 0
		BEGIN
			IF ASCII(UPPER(@Char)) = ASCII(@Char)
				SET @ResultText = @ResultText + UPPER(SUBSTRING(@Lat1, @Position, 1)) + RTRIM(SUBSTRING(@Lat2, @Position, 1)) + RTRIM(SUBSTRING(@Lat3, @Position, 1));
			ELSE
				SET @ResultText = @ResultText + SUBSTRING(@Lat1, @Position, 1) + RTRIM(SUBSTRING(@Lat2, @Position, 1)) + RTRIM(SUBSTRING(@Lat3, @Position, 1));
		END
		ELSE
			SET @ResultText = @ResultText + @Char;
		SET @�ounter = @�ounter + 1;
	END
	
	RETURN @ResultText;
END