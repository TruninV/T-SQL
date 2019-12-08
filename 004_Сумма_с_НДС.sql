--����� � ���
CREATE FUNCTION SummaWithNDS
(
	@Summa FLOAT, --�����
	@Nds INT 	  --�������� ���
)
RETURNS FLOAT
AS
BEGIN	
/*
	***** ��������
		  ������� ���������� ����� � ������ ���

	***** ������ �������
		  SELECT dbo.SummaWithNDS(100, 20) AS SummaWithNDS;
				  
	***** ���� - https://info-comp.ru
		  GitHub - 
		  
	*****��������� ��� �������� T-SQL
		 https://info-comp.ru/t-sql-book.html
		 https://info-comp.ru/microsoft-sql-server
*/	
	DECLARE @SummaWithNDS FLOAT;
	--���� �������� ��� ������������, �� ������������ ������ �����
	IF @Nds > 0
		SET @SummaWithNDS = @Summa * (100 + @Nds) / 100;
	ELSE
		SET @SummaWithNDS = @Summa;
		
	RETURN ROUND(@SummaWithNDS, 8);
END
