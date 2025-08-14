use ecommerce;

-- idClient, Fname, Minit, Lname, CPF, Address
insert into Client (Fname, Minit, Lname, CPF, Address) values
					('Maria', 'M', 'Silva', 12346789, 'rua silva de prata 29, Carangola - Cidade das flores'),
					('Matheus', 'O', 'Pimentel', 987654321, 'rua alameda 289, Centro - Cidade das flores'),
					('Ricardo', 'F', 'Silva', 45678913, 'avenida alameda vinha 1009, Centro - Cidade das flores'),
					('Julia', 'S', 'França', 789123456, 'rua lareiras 861, Centro - Cidade das flores'),
					('Roberta', 'G', 'Assis', 98745631, 'avenidade koller 19, Centro - Cidade das flores'),
					('Isabela', 'M', 'Cruz', 654789123, 'rua alameda das flores 28, Centro - Cidade das flores');

-- idProduct, Pname, classification_kids boolean, category('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis'), avaliação, size
insert into product (Pname, classification_kids, category, avaliação, size) values
					('Fone de ouvido', false, 'Eletrônico', '4', null),
					('Barbie Elsa', true, 'Brinquedos', '3', null),
					('Body Carters', true, 'Vestimenta', '5', null),
					('Microfone Vedo - Youtuber', false, 'Eletrônico', '4', null),
					('Sofá retrátil', false, 'Móveis', '3', '3x57x80'),
					('Farinha de arroz', false, 'Alimentos', '2', null),
					('Fire Stick Amazon', false, 'Eletrônico', '3', null);

select * from client;
select * from product;

-- idOrder, idOrderClient, orderStatus, orderDescription, sendValue, paymentCash
delete from orders where idOrderClient in (1, 2, 3, 4);
insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
					(1, default, 'compra via aplicativo', null, 1),
					(2, default, 'compra via aplicativo', 50, 0),
					(3, 'Confirmado', null, null, 1),
					(4, default, 'compra via web site', 150, 0);

-- idPOproduct, idPOorder, poQuantity, poStatus
select * from orders;
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
						(1, 5, 2, null),
						(2, 5, 1, null),
						(3, 6, 1, null);
                        
SELECT * FROM product WHERE idProduct IN (1, 2, 3);
SELECT * FROM orders WHERE idOrder IN (5, 6);



-- storageLocation, quantity
insert into productStorage (storageLocation, quantity) values
							('Rio de Janeiro', 1000),
							('Rio de Janeiro', 500),
							('São Paulo', 10),
							('São Paulo', 100),
							('São Paulo', 10),
							('Brasília', 60);


-- idLproduct, idLstorage, location
insert into storageLocation (idLproduct, idLstorage, location) values
							(1, 2, 'RJ'),
							(2, 6, 'GO');

-- idSupplier, SocialName, CNPJ, contact
insert into supplier (SocialName, CNPJ, contact) values
					('Almeida e filhos', 123456789123456, '21985474'),
					('Eletrônicos Silva', 854519649143457, '21985484'),
					('Eletrônicos Valma', 934567893934695, '21975474');

-- idPsSupplier, idPsProduct, quantity
insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
							(1, 1, 500),
							(1, 2, 400),
							(2, 4, 633),
							(3, 3, 5),
							(2, 5, 10);

-- idSeller, SocialName, AbstName, CNPJ, CPF, location, contact
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values
					('Tech eletronics', null, 123456789456321, null, 'Rio de Janeiro', 219946287),
					('Botique Durgas', null, null, 123456783, 'Rio de Janeiro', 219567895),
					('Kids World', null, 456789123654485, null, 'São Paulo', 1198657484);

select * from seller;

-- idPseller, idPproduct, prodQuantity
INSERT INTO productSeller (idSeller, idProduct, prodQuantity) VALUES
    (1, 6, 80),
    (2, 7, 10);

-- insert para as novas modificações
-- Clientes: um PF e um PJ
INSERT INTO client (Fname, Minit, Lname, CPF, CNPJ, client_type, Address) VALUES
					('Ana','M','Silva','12345678901', NULL, 'PF', 'Rua A, 100'),
					('EmpresaX', NULL, 'LTDA', NULL, '11222333444455', 'PJ', 'Av. B, 200');

-- Métodos de pagamento (múltiplos por cliente)
INSERT INTO client_payment_method (idClient, method, card_last4, card_holder, limitAvailable) VALUES
					(1, 'Cartão', '1234', 'ANA M SILVA', 5000.00),
					(1, 'Pix', NULL, NULL, NULL),
					(2, 'Boleto', NULL, NULL, NULL);

-- Pedido do cliente PF usando um método salvo
INSERT INTO orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash, idPaymentMethod) VALUES 
					(1, 'Confirmado', 'Pedido de teste', 15.00, FALSE, 1);

-- Entrega vinculada ao pedido
INSERT INTO delivery (idOrder, status, tracking_code, carrier, shipped_at) VALUES 
					(LAST_INSERT_ID(), 'Enviado', 'BR123456789XY', 'Correios', NOW());

-- ----------------------------------------------------
select * from productSeller;

select count(*) from clients;
select * from client c, orders o where c.idClient = idOrderClient;

select fname, lname, idOrder, orderStatus from client c, orders o where c.idClient = idOrderClient;
select concat(fname, ' ', lname) as Client, idOrder as Request, orderStatus as Status from client c, orders o where c.idClient = idOrderClient;

insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
(2, default, 'compra via aplicativo', null, 1);

select count(*) from client c, orders o
    where c.idClient = idOrderClient;

select * from orders;

-- recuperação de pedido com produto associado
select * from client c
    inner join orders o ON c.idClient = o.idOrderClient
    inner join productOrder p on p.idPOorder = o.idOrder
group by idClient;

-- Recuperar quantos pedidos foram realizados pelos clientes?
select c.idClient, Fname, count(*) as Number_of_orders from client c
    inner join orders o ON c.idClient = o.idOrderClient
group by idClient;


