-- criação do banco de dados para o cenário de E-commerce
create database ecommerce;
use ecommerce;

-- criar tabela cliente
create table client(
    idClient int auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(30),
    constraint unique_cpf_client unique (CPF)
);

alter table client auto_increment=1;

-- criar tabela produto
-- size = dimensão do produto
create table product(
    idProduct int auto_increment primary key,
    Pname varchar(10) not null,
    classification_kids bool default false,
    category enum('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') not null,
    avaliação float default 0,
    size varchar(10)
);

-- para ser continuado no desafio: termine de implementar a tabela e crie a conexão com as tabelas necessárias
-- além disso, reflita essa modificação no diagrama de esquema relacional
-- criar constraints relacionadas ao pagamento

create table payments(
    idClient int,
    idPayment int,
    typePayment enum('Boleto','Cartão','Dois cartões'),
    limitAvailable float,
    primary key(idClient, id_payment)
);

-- criar tabela pedido
create table orders(
    idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash bool default false,
    constraint fk_orders_client foreign key (idOrderClient) references client(idClient)
);
desc orders;
-- criar tabela estoque
create table productStorage(
    idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

-- criar tabela fornecedor
create table supplier(
    idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

-- criar tabela vendedor
create table seller(
    idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

-- criar tabela vendedor
create table productSeller(
    idSeller int,
    idProduct int,
    prodQuantity int default 1,
    primary key (idSeller, idProduct),
    constraint fk_product_seller foreign key (idSeller) references seller(idSeller),
    constraint fk_product_product foreign key (idProduct) references product(idProduct)
);
desc productseller;

create table productOrder(
    idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
);

create table storageLocation(
    idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

create table productSupplier(
    idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
);

desc productSupplier;

show tables;

-- CPF precisa poder ser NULL para clientes PJ
alter table client 
	modify CPF CHAR(11) NULL;

-- Adiciona CNPJ e o tipo do cliente
alter table client
  Add column CNPJ CHAR(14) NULL AFTER CPF,
  Add column client_type ENUM('PF','PJ') NOT NULL AFTER CNPJ;

-- Unicidade de CNPJ (como já tinha para CPF)
ALTER TABLE client
  Add CONSTRAINT unique_cnpj_client UNIQUE (CNPJ);

-- Regra PF x PJ (somente um dos documentos, conforme o tipo)
alter table client
  Add CONSTRAINT chk_client_pf_pj
	  check (
		(client_type = 'PF' AND CPF  IS NOT NULL AND CNPJ IS NULL) OR
		(client_type = 'PJ' AND CNPJ IS NOT NULL AND CPF  IS NULL)
	  );

DROP TABLE IF EXISTS payments;
CREATE TABLE client_payment_method (
	  idPaymentMethod INT AUTO_INCREMENT PRIMARY KEY,
	  idClient INT NOT NULL,
	  method ENUM('Boleto','Cartão','Pix') NOT NULL,
	  card_last4 CHAR(4) NULL,
	  card_holder VARCHAR(60) NULL,
	  limitAvailable DECIMAL(10,2) NULL,
	  CONSTRAINT fk_paymentmethod_client
		FOREIGN KEY (idClient) REFERENCES client(idClient)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

ALTER TABLE orders
	  ADD COLUMN idPaymentMethod INT NULL AFTER paymentCash,
	  ADD CONSTRAINT fk_orders_payment_method
		FOREIGN KEY (idPaymentMethod)
		REFERENCES client_payment_method(idPaymentMethod)
		ON DELETE SET NULL
		ON UPDATE CASCADE;

CREATE TABLE order_payment (
	  idOrder INT NOT NULL,
	  idPaymentMethod INT NOT NULL,
	  amount DECIMAL(10,2) NOT NULL,
	  PRIMARY KEY (idOrder, idPaymentMethod),
	  CONSTRAINT fk_orderpayment_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder) ON DELETE CASCADE,
	  CONSTRAINT fk_orderpayment_method FOREIGN KEY (idPaymentMethod) REFERENCES client_payment_method(idPaymentMethod) ON DELETE RESTRICT
);

CREATE TABLE delivery (
	  idDelivery INT AUTO_INCREMENT PRIMARY KEY,
	  idOrder INT NOT NULL,
	  status ENUM('Em preparação','Enviado','Em trânsito','Entregue','Devolvido','Cancelado')
			 NOT NULL DEFAULT 'Em preparação',
	  tracking_code VARCHAR(50) NOT NULL,
	  carrier VARCHAR(60) NULL,
	  shipped_at DATETIME NULL,
	  delivered_at DATETIME NULL,
	  CONSTRAINT uk_delivery_order UNIQUE (idOrder),
	  CONSTRAINT fk_delivery_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);