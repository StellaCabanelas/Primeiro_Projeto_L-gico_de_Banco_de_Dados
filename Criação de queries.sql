-- Entrega do desafio

-- Recuperações simples com SELECT
-- Pergunta: Quais são os nomes e CPFs de todos os clientes cadastrados?
SELECT Fname, Lname, CPF
	FROM client;

-- Filtros com WHERE
-- Pergunta: Quais clientes têm CPF que começa com '123'?
SELECT idClient, Fname, Lname, CPF
	FROM client
	WHERE CPF LIKE '123%';

-- Expressões para atributos derivados
SELECT o.idOrder,
    SUM(po.poQuantity * p.avaliação) + o.sendValue AS totalPedido
		FROM orders o
		LEFT JOIN productOrder po ON o.idOrder = po.idPOorder
		LEFT JOIN product p ON po.idPOproduct = p.idProduct
		GROUP BY o.idOrder;

-- Ordenações com ORDER BY
-- Pergunta: Liste todos os produtos ordenados pela avaliação (maior para menor).
SELECT Pname, avaliação
	FROM product
	ORDER BY avaliação DESC;

-- Filtros em grupos com HAVING
-- Pergunta: Quais clientes fizeram mais de 1 pedidos?
SELECT c.idClient, c.Fname, c.Lname, COUNT(o.idOrder) AS totalPedidos
		FROM client c
		JOIN orders o ON c.idClient = o.idOrderClient
		GROUP BY c.idClient, c.Fname, c.Lname
		HAVING COUNT(o.idOrder) > 1;

-- Junções (JOIN) para consultas mais complexas
-- Pergunta: Relação de nomes dos fornecedores e nomes dos produtos que eles fornecem.
SELECT s.SocialName AS Fornecedor, p.Pname AS Produto
		FROM productSupplier ps
		JOIN supplier s ON ps.idPsSupplier = s.idSupplier
		JOIN product p ON ps.idPsProduct = p.idProduct;


-- Pergunta: Relação de produtos, fornecedores e quantidade em estoque.
SELECT p.idProduct, p.Pname, s.SocialName AS Fornecedor, psu.quantity AS QtdeFornecida, st.quantity AS QtdeEstoque, sl.location AS Localizacao FROM product p
	JOIN productSupplier psu ON psu.idPsProduct = p.idProduct
	JOIN supplier s ON s.idSupplier = psu.idPsSupplier
	LEFT JOIN storageLocation sl ON sl.idLproduct = p.idProduct
	LEFT JOIN productStorage st ON st.idProdStorage = sl.idLstorage
	ORDER BY p.Pname, Fornecedor;


-- Pergunta: Algum vendedor também é fornecedor?
SELECT se.SocialName AS VendedorFornecedor FROM seller se
	JOIN supplier su
	  ON se.CNPJ IS NOT NULL 
      AND su.CNPJ = se.CNPJ;

-- Pergunta: Quantos pedidos foram feitos por cada cliente?
SELECT c.idClient, c.Fname, c.Lname, c.client_type, COUNT(o.idOrder) AS total_pedidos FROM client c
		LEFT JOIN orders o ON o.idOrderClient = c.idClient
		GROUP BY c.idClient, c.Fname, c.Lname, c.client_type
		HAVING COUNT(o.idOrder) >= 0   -- troque o filtro (>= 2, por ex.) conforme a análise
		ORDER BY total_pedidos DESC, c.idClient;
