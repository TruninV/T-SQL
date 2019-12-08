--����� ���
CREATE FUNCTION SummaNDS 
(
	@Summa FLOAT, --�����
	@Nds INT	  --�������� ���
) 
RETURNS FLOAT
AS
BEGIN
/*
	***** ��������
		  ������� ���������� ����� ��� �� @Summa

	***** ������ �������
		  SELECT dbo.SummaNDS(100, 20) AS SummaNDS;
				  
	***** ���� - https://info-comp.ru
		  GitHub - 
		  
	*****��������� ��� �������� T-SQL
		 https://info-comp.ru/t-sql-book.html
		 https://info-comp.ru/microsoft-sql-server
*/
	DECLARE @SummaNDS FLOAT;
	--���� �������� ��� ������������, �� ������������ 0
	IF @Nds > 0
		SET @SummaNDS = @Nds * (@Summa / (100 + @Nds));
	ELSE
		SET @SummaNDS = 0;
		
	RETURN ROUND(@SummaNDS, 8);
END
