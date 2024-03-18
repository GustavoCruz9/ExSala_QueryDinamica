CREATE DATABASE ExSala_QueryDinamica
GO
USE ExSala_QueryDinamica
GO
CREATE TABLE Produto (
codigo	int				not null,
nome	varchar(50)		not null,
valor	decimal(5,2)	not null
Primary key(codigo)
)
GO
CREATE TABLE Entrada(
codigo_transacao	int				not null,
codigo_produto		int				not null,
quantidadade		int				not null,
valor_total			decimal(5,2)	not null
Primary key(codigo_transacao)
Foreign Key(codigo_produto) references Produto(codigo)
)
GO
CREATE TABLE Saida(
codigo_transacao	int				not null,
codigo_produto		int				not null,
quantidadade		int				not null,
valor_total			decimal(5,2)	not null
Primary key(codigo_transacao)
Foreign Key(codigo_produto) references Produto(codigo)
)
GO
INSERT INTO Produto (codigo, nome, valor) VALUES
(1, 'Camiseta', 29.99),
(2, 'Calça Jeans', 49.90),
(3, 'Tênis', 79.99),
(4, 'Moletom', 39.99)

GO

CREATE PROCEDURE sp_procedureTesteAula (@codigo_transacao INT, @codigo_produto INT, @quantidade INT, 
										@entrada_saida VARCHAR(1), @saida VARCHAR(80) OUTPUT)
AS
	DECLARE @tabela VARCHAR(10),
			@query	VARCHAR(200),
			@erro VARCHAR(100),
			@valor_total DECIMAL(5,2)

	IF (@entrada_saida <> 's' AND @entrada_saida <> 'e')
	BEGIN
	
		SET @erro = 'Codigo invalido'
		RAISERROR(@erro, 16, 1)
		RETURN
	END

	DECLARE @valor_unitario DECIMAL(5,2)
	DECLARE @valor_total1	DECIMAL(5,2)

	SELECT @valor_unitario = valor
	FROM Produto
	Where codigo = @codigo_produto

	IF (@@ROWCOUNT = 0)
	BEGIN
		SET @erro = 'Produto com o ID ' + CAST(@codigo_produto AS VARCHAR(10)) + ' inexistente'
		RAISERROR(@erro, 16,1)
	END

	SET @valor_total = @valor_unitario * @quantidade
	
	IF (@entrada_saida = 's')
	BEGIN
		SET @tabela = 'Saida'
	END
	ELSE
	BEGIN
		SET @tabela = 'Entrada'
	END

	SET @query = 'INSERT INTO ' + @tabela + ' VALUES (' + CAST(@codigo_transacao AS VARCHAR(50)) + ',' + CAST(@codigo_produto AS VARCHAR(50)) + ',' +
				CAST(@quantidade AS VARCHAR(50))+ ',' + CAST(@valor_total AS VARCHAR(50))+ ')'

	EXEC (@query)
	SET @saida = 'Produto inserido na tabela ' + @tabela + ' com sucesso'

DECLARE @out1 VARCHAR(80)
EXEC sp_procedureTesteAula 2, 1, 100, 'e', @out1 OUTPUT
PRINT @out1

SELECT * FROM Produto
SELECT * FROM Entrada
SELECT * FROM Saida
