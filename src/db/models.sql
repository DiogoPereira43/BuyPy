#1 - criar base de dados
drop database if exists buypy;
create database if not exists BuyPy;
use BuyPy;

#2 - criar tabelas 
 CREATE TABLE Clients(
	client_id int primary key auto_increment,
	fullname varchar(250) not null, 
	email varchar(50) not null unique, #validado por triggers
    password_client varchar(50) not null, #validado por triggers
	address varchar(100) not null,
    zip_code smallint not null, #smallint para armazenar numeros de tamanhos pequenos
    city varchar(30) not null,
    country varchar(30) default 'Portugal', 
    phone_number varchar (15),
    last_login datetime not null default now(),
    birthdate date not null,
    is_active bool not null
    );
    
CREATE TABLE Orders(
	order_id int primary key auto_increment,
    date_time datetime not null default now(),
    delivery_method ENUM('regular', 'urgent') NOT NULL DEFAULT 'regular', # ENUM restringe os valores para apenas "regular e urgent" como se fosse uma lista
    order_status varchar(10) default 'open',
    payment_card_number bigint not null, #BIGINT usado para armazenar números inteiros de grande magnitude.
    payment_card_name varchar(20) not null,
    payment_card_expiration date not null,
    client_id int not null,
    foreign key (client_id) references Client(client_id)
    );

CREATE TABLE Product(
    product_id varchar(10) primary key unique not null,
	quantity int not null check (quantity >= 0),
    price decimal(19, 4) not null check (price >= 0), # têm de ser numero positivo
    vat real not null check (vat >= 0 AND vat <= 100), # têm de ser numero positivo, usamos o check entre numeros, #validacao do 1 a 100 
    score smallint ,
    product_image varchar(30), #rever que este será para inserir link
    is_active bool not null,
    reason varchar(500)
    );
    
CREATE TABLE Ordered_Item(
    ordered_item_id int primary key auto_increment,
    order_id int not null,
    product_id varchar(10) not null,
    quantity int not null check (quantity >= 0), # têm de ser numero positivo
	price decimal(19, 4) not null check (price >= 0), # têm de ser numero positivo
    vat_amount decimal(19, 4) not null check (vat_amount >= 0 AND vat_amount <= 100), # têm de ser numero positivo, usamos o check entre numeros
    foreign key (order_id) references Orders(order_id),
    foreign key (product_id) references Product(product_id)
    );
    
CREATE TABLE Recommendation(
    recommendation_id int primary key auto_increment,
    reason varchar(500),
    start_date date,
    client_id int not null,
    product_id varchar(10),
    foreign key (client_id) references Clients(client_id),
    foreign key (product_id) references Product(product_id)
    );
    
 CREATE TABLE Operator(
	id_operator int primary key auto_increment,
	firstname varchar(125) not null,
	surname varchar(125) not null,
    email varchar(50) not null unique, #validado por triggers
    password_operator varchar(50) not null #validado por triggers
    );
    
CREATE TABLE Electronic(
    product_id varchar(10),
	serial_num bigint not null unique,
    brand varchar (20) not null,
    model varchar (20) not null,
    spec_tec longtext not null, #Para armazenar texto longo
    electronic_type varchar (10) not null,
    foreign key (product_id) references Product(product_id)
    );

CREATE TABLE Book(
    product_id varchar(10),
	isbn13 varchar(20) not null unique,
    title varchar(50) not null,
    genre varchar(50) not null,
    publisher varchar(100) not null,
    publication_date date not null,
    foreign key (product_id) references Product(product_id)
    );

CREATE TABLE Author(
    author_id int primary key auto_increment,
    author_name varchar(100) not null, #"Author's literary/pseudo name, for which he is known
    fullname varchar(100) not null, #Author's real full name,
     birthdate date not null
    );

CREATE TABLE BookAuthor(
    bookauthor_id int primary key auto_increment,
    product_id varchar(10),
    author_id int,
    foreign key (author_id) references Author(author_id)
    );


# Trigger para verificar cliente email antes de um insert e update
DROP TRIGGER IF EXISTS validar_cliente_email;
DROP TRIGGER IF EXISTS validar_client_email_update;
DELIMITER //
CREATE TRIGGER validar_client_email
BEFORE INSERT ON Clients
FOR EACH ROW					#Por cada linha vamos verificar se o email respeita as especificações
BEGIN
    IF NEW.email NOT REGEXP '^[a-z0-9!#$%&''*+/=?^_`{|}~-]+(\\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?$'
    THEN SIGNAL SQLSTATE '45000'											# 45 é uma classe reservado para erros defenidos pelo usuário, li que é uma boa prática
	SET MESSAGE_TEXT = 'Erro: Email do cliente inválido. Não sejas tóto.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER validar_client_email_update
BEFORE UPDATE ON Clients
FOR EACH ROW
BEGIN
    IF NEW.email NOT REGEXP '^[a-z0-9!#$%&''*+/=?^_`{|}~-]+(\\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?$' 
    THEN SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Erro: Email do cliente inválido. Não sejas tóto.';
    END IF;
END //
DELIMITER ;

# Trigger para verificar operador email antes de um insert e update
DROP TRIGGER IF EXISTS validar_operator_email;
DROP TRIGGER IF EXISTS validar_operator_email_update;
DELIMITER //
CREATE TRIGGER validar_operator_email
BEFORE INSERT ON Operator
FOR EACH ROW
BEGIN
    IF NEW.email NOT REGEXP '^[a-z0-9!#$%&''*+/=?^_`{|}~-]+(\\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?$'
    THEN SIGNAL SQLSTATE '45000'											# 45 é uma classe reservado para erros defenidos pelo usuário, li que é uma boa prática
	SET MESSAGE_TEXT = 'Erro: Email do cliente inválido. Não sejas tóto.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER validar_operator_email_update
BEFORE UPDATE ON Operator
FOR EACH ROW
BEGIN
    IF NEW.email NOT REGEXP '^[a-z0-9!#$%&''*+/=?^_`{|}~-]+(\\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?$' 
    THEN SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Erro: Email do cliente inválido. Não sejas tóto.';
    END IF;
END //
DELIMITER ;


# Validar password de Cliente e Operator

DELIMITER //
CREATE TRIGGER validar_client_password
BEFORE INSERT ON Clients
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.password_client) < 6
	OR NEW.password_client NOT REGEXP '[0-9]'
	OR NEW.password_client NOT REGEXP '[a-z]'
	OR NEW.password_client NOT REGEXP '[A-Z]'
	OR NEW.password_client NOT REGEXP '[!$#?%]'
    THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Erro: Senha do cliente inválida. És tóto.';
    END IF;
    SET NEW.password_client = SHA2(NEW.password_client, 256);	#Encriptamos a password com modelo SHA2
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER validar_client_password_update
BEFORE UPDATE ON Clients
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.password_client) < 6
	OR NEW.password_client NOT REGEXP '[0-9]'
	OR NEW.password_client NOT REGEXP '[a-z]'
	OR NEW.password_client NOT REGEXP '[A-Z]'
	OR NEW.password_client NOT REGEXP '[!$#?%]'
    THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Erro: Senha do cliente inválida. És tóto.';
    END IF;
    SET NEW.password_client = SHA2(NEW.password_client, 256);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER validar_operator_password
BEFORE INSERT ON Operator
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.password_operator) < 6
	OR NEW.password_operator NOT REGEXP '[0-9]'
	OR NEW.password_operator NOT REGEXP '[a-z]'
	OR NEW.password_operator NOT REGEXP '[A-Z]'
	OR NEW.password_operator NOT REGEXP '[!$#?%]'
    THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Erro: Senha do operador inválida. És tóto.';
    END IF;
    SET NEW.password_operator = SHA2(NEW.password_operator, 256);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER validar_operator_password_update
BEFORE UPDATE ON Operator
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.password_operator) < 6
	OR NEW.password_operator NOT REGEXP '[0-9]'
	OR NEW.password_operator NOT REGEXP '[a-z]'
	OR NEW.password_operator NOT REGEXP '[A-Z]'
	OR NEW.password_operator NOT REGEXP '[!$#?%]'
    THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Erro: Senha do operador inválida. És tóto.';
    END IF;
    SET NEW.password_operator = SHA2(NEW.password_operator, 256);
END //
DELIMITER ;

# 3 Storage Procedures

# EXTRA ProductbyType
DROP PROCEDURE IF EXISTS GetProductByType;
DELIMITER //
CREATE PROCEDURE GetProductByType (IN input_type VARCHAR(50))
BEGIN
SELECT 
Product.product_id AS 'ID do Produto',
Product.price AS 'Preço do Produto',
Product.score AS 'Score do Produto',
Recommendation.reason AS 'Motivo da Recomendação',
Product.is_active AS 'Está ativo?',
Electronic.electronic_type AS 'Tipo de Eletrónico',
Book.genre AS 'Genero de Livro'
FROM Product
LEFT JOIN Recommendation ON Product.product_id = Recommendation.product_id		#Usamos LEFT JOIN em vez de INNER senão o SELECT mostra nada, porque nao existe um produto que tenha registo em ambos electronic_type nem book_genre
LEFT JOIN Electronic ON Product.product_id = Electronic.product_id
LEFT JOIN Book ON Product.product_id = Book.product_id
WHERE input_type IS NULL 														# Retorna todos os produtos se input_type for NULL
OR Electronic.electronic_type = input_type 										# ou caso o input for correspondente a electronic_type
OR Book.genre = input_type; 													# ou caso o input for correspondente a Book.Genre
END //
DELIMITER ;

# Testagem
CALL GetProductbyType ('smartphone');


# EXTRA DailyOrders
DROP PROCEDURE IF EXISTS DailyOrders;
DELIMITER //
CREATE PROCEDURE DailyOrders (IN input_type date)
BEGIN
SELECT 
Orders.order_id AS 'ID da Encomenda',
Orders.date_time AS 'Data Encomenda',
Orders.delivery_method AS 'Metodo de envio',
Orders.order_status AS 'Status da encomenda',
Orders.payment_card_number AS 'Numero de cartão',
Orders.payment_card_name AS 'Nome do Cartão',
Orders.payment_card_expiration AS 'Expiração do cartão',
Clients.fullname AS 'Nome do cliente'
FROM Orders
INNER JOIN Clients ON Orders.client_id = Clients.client_id
WHERE DATE (Orders.date_time) = input_type;
END //
DELIMITER ;

# Testagem
CALL DailyOrders ('2025-07-25');

# EXTRA AnnualOrders
DROP PROCEDURE IF EXISTS AnnualOrders;
DELIMITER //
CREATE PROCEDURE AnnualOrders (IN input_client_id INT, IN input_year INT)
BEGIN SELECT 
Orders.order_id AS 'ID da Encomenda',
Orders.date_time AS 'Data Encomenda',
Orders.delivery_method AS 'Metodo de envio',
Orders.order_status AS 'Status da encomenda',
Orders.payment_card_number AS 'Numero de cartão',
Orders.payment_card_name AS 'Nome do Cartão',
Orders.payment_card_expiration AS 'Expiração do cartão',
Clients.fullname AS 'Nome do cliente'
FROM Orders
INNER JOIN Clients ON Orders.client_id = Clients.client_id
WHERE Orders.client_id = input_client_id
AND YEAR (Orders.date_time) = input_year;
END //
DELIMITER ;

# Testagem
CALL AnnualOrders ('1' ,'2025');

# CreateOrder
DROP PROCEDURE IF EXISTS CreateOrder;
DELIMITER //
CREATE PROCEDURE CreateOrder (
IN input_client_id INT,
IN input_delivery_method ENUM('regular', 'urgent'),
IN input_payment_card_number BIGINT,
IN input_payment_card_name VARCHAR(20),
IN input_payment_card_expiration DATE)
BEGIN INSERT INTO Orders (client_id,
delivery_method,
payment_card_number,
payment_card_name,
payment_card_expiration)
VALUES
(input_client_id, input_delivery_method, input_payment_card_number, input_payment_card_name, input_payment_card_expiration);
END //
DELIMITER ;

# Testagem
CALL CreateOrder(1, 'urgent', 1234567890123456, 'João Silva', '2027-12-31');
SELECT * FROM Orders;

# GetOrderTotal
DROP PROCEDURE IF EXISTS GetOrderTotal;
DELIMITER //
CREATE PROCEDURE GetOrderTotal (IN input_order_id INT)
BEGIN
SELECT 
SUM(price * quantity * (1 + vat_amount / 100)) AS 'Montante Total da encomenda' # Temos de usar 1 + para incluir o preço base, senão isto não dá um valor real
FROM Ordered_Item
WHERE order_id = input_order_id;
END //
DELIMITER ;

# Testagem
CALL GetOrderTotal(1);