--������� ���������� ���
CREATE FUNCTION ShortFIO
(
	@SurName VARCHAR(100),   --�������
	@FirstName VARCHAR(100), --���
	@Patronymic VARCHAR(100) --��������
)
RETURNS VARCHAR(300)
AS
BEGIN
/*
	***** ��������
		  ������� ��������� ������� ��� ��������, ��������, ������ ���� �������� => ������ �.�.
		  ������ ����� ��� ������ ������������ ��������.
		  ������� ��������� ��� ������ ���� ���� ��� ������.

	***** ������ �������
		  SELECT dbo.ShortFIO('������', '����', '��������') AS ShortFIO;
				  
	***** ���� - https://info-comp.ru
		  GitHub - 
		  
	*****��������� ��� �������� T-SQL
		 https://info-comp.ru/t-sql-book.html
		 https://info-comp.ru/microsoft-sql-server
*/
	DECLARE @FIO VARCHAR(300); 
	--��������� ��� ������ ���� ���� ��� ������
	IF @SurName IS NOT NULL AND @FirstName IS NOT NULL AND @Patronymic IS NOT NULL
		SET @FIO = UPPER(SUBSTRING(LTRIM(RTRIM(@SurName)), 1, 1)) + LOWER(SUBSTRING(LTRIM(RTRIM(@SurName)), 2, LEN(LTRIM(RTRIM(@SurName))))) +
				   ' ' + 
				   UPPER(SUBSTRING(LTRIM(RTRIM(@FirstName)), 1, 1)) + 
				   '. ' + 
				   UPPER(SUBSTRING(LTRIM(RTRIM(@Patronymic)), 1, 1)) + 
				   '.';
	RETURN @FIO;
END
