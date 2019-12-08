--�������� Email ������
CREATE FUNCTION CheckEmail
(
	@Email VARCHAR(100) --����� ����������� �����
)
RETURNS BIT
AS
BEGIN
/*
	***** ��������
		  �������� ������ ����������� ����� (Email) �� ������������.
		  ������� ����������:
		    1 � Email ���������
		    0 � Email �����������
		    NULL � ���� �������� Email ����� NULL

	***** ������ �������
		  SELECT dbo.CheckEmail('123email456@gmail.com') AS CheckEmail;
		  
	***** ���� - https://info-comp.ru
		  GitHub - 
		  
	*****��������� ��� �������� T-SQL
		 https://info-comp.ru/t-sql-book.html
		 https://info-comp.ru/microsoft-sql-server
*/
	DECLARE @Result BIT;
	
	--�������� �������� ������ ���� ���� ������
	IF @Email IS NOT NULL
	BEGIN	
		IF @Email LIKE '%[A-Z0-9][@][A-Z0-9]%[.][A-Z0-9]%' AND @Email NOT LIKE '%["<>'']%'
			SET @Result = 1;
		ELSE
			SET @Result = 0;
	END
	
	RETURN @Result;
END
