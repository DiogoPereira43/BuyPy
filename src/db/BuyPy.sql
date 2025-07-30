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

#Inserir valores
INSERT INTO Clients (client_id, fullname, email, password_client, address, zip_code, city, country, phone_number, last_login, birthdate, is_active)
VALUES 
(1, 'Diogo Pedro Silva', 'diogo.silva@email.com', 'Pass#123', 'Rua das Porcas, nº10', 1234, 'Lisboa', 'Portugal', '912345678', '2025-07-26 14:00:00', '1990-01-15', TRUE),
(2, 'Ana Sofia Costa', 'ana.costa@email.com', 'Test$456', 'Avenida Central, nº25', 5678, 'Porto', 'Portugal', '923456789', '2025-07-26 14:05:00', '1985-03-22', TRUE),
(3, 'Pedro Miguel Santos', 'pedro.santos@email.com', 'Abc?789', 'Rua da Cabra, nº50', 9012, 'Faro', 'Portugal', '934567890', '2025-07-26 14:10:00', '1995-07-10', FALSE),
(4, 'Maria Clara Oliveira', 'maria.oliveira@email.com', 'Xyz%101', 'Praça da Liberdade, nº15', 3456, 'Coimbra', 'Portugal', '945678901', '2025-07-26 14:15:00', '1988-11-30', TRUE),
(5, 'Lucas André Almeida', 'lucas.almeida@email.com', 'Qwe!202', 'Rua da Carlota, nº30', 7890, 'Braga', 'Portugal', '956789012', '2025-07-26 14:20:00', '1992-05-05', FALSE);
SELECT * FROM Clients;

INSERT INTO Orders (order_id, date_time, delivery_method, order_status, payment_card_number, payment_card_name, payment_card_expiration, client_id)
VALUES 
(1, '2025-07-25 10:00:00', 'regular', 'open', 1234567890123456, 'João Silva', '2027-12-31', 1),
(2, '2025-07-25 15:30:00', 'express', 'open', 9876543210987654, 'Ana Costa', '2028-01-31', 2),
(3, '2025-07-26 09:00:00', 'regular', 'open', 4567891234567890, 'Pedro Santos', '2027-11-30', 3),
(4, '2025-07-26 12:45:00', 'express', 'open', 3210987654321098, 'Maria Oliveira', '2028-06-30', 4),
(5, '2025-07-26 16:20:00', 'regular', 'open', 6543219876543210, 'Lucas Almeida', '2027-09-30', 5);
SELECT * FROM Orders;

INSERT INTO Product (product_id, quantity, price, vat, score, product_image, is_active, reason)
VALUES  #Já que o Product_ID é VARCHAR, podemos fazer algo alfanumerico, em empresas ahco que é normal usar P001 - P002 por ai fora. Assim tb fica unico
('P001', 10, 999.99, 23.00, 85, 'smartphone.jpg', TRUE, NULL),
('P002', 5, 29.99, 6.00, 90, 'novel.jpg', TRUE, NULL),
('P003', 15, 4999.99, 23.00, 95, 'laptop.jpg', FALSE, 'Discontinued model'),
('P004', 8, 19.99, 6.00, 88, 'book.jpg', TRUE, NULL),
('P005', 20, 149.99, 23.00, 82, 'tablet.jpg', FALSE, 'Out of stock'),
('P006', 12, 199.99, 23.00, 87, 'headphones.jpg', TRUE, NULL),
('P007', 7, 1299.99, 23.00, 92, 'tv.jpg', TRUE, NULL),
('P008', 10, 24.99, 6.00, 85, 'scifi.jpg', TRUE, NULL),
('P009', 6, 22.99, 6.00, 89, 'mystery.jpg', TRUE, NULL),
('P010', 8, 27.99, 6.00, 91, 'fantasy.jpg', TRUE, NULL);
SELECT * FROM Product;

INSERT INTO Ordered_Item (ordered_item_id, order_id, product_id, quantity, price, vat_amount)
VALUES 
(1, 1, 'P001', 2, 999.99, 23.00),
(2, 2, 'P002', 3, 29.99, 6.00),
(3, 3, 'P003', 1, 4999.99, 23.00), 
(4, 4, 'P004', 5, 19.99, 6.00),
(5, 5, 'P005', 2, 149.99, 23.00);
SELECT * FROM Ordered_Item;

INSERT INTO Recommendation (recommendation_id, reason, start_date, client_id, product_id)
VALUES 
(1, 'Highly recommended smartphone', '2025-07-20', 1, 'P001'),
(2, NULL, '2025-07-21', 2, 'P002'),
(3, 'Great for tech enthusiasts', NULL, 3, 'P003'),
(4, 'Perfect for history buffs', '2025-07-22', 4, 'P004'),
(5, NULL, NULL, 5, 'P005');
SELECT * FROM Recommendation;

INSERT INTO Operator (id_operator, firstname, surname, email, password_operator)
VALUES 
(1, 'Carla', 'Mendes', 'carla.mendes@buypy.com', 'Op#123'),
(2, 'Rui', 'Pereira', 'rui.pereira@buypy.com', 'Op$456'),
(3, 'Sofia', 'Lima', 'sofia.lima@buypy.com', 'Op?789'),
(4, 'Tiago', 'Gomes', 'tiago.gomes@buypy.com', 'Op%101'),
(5, 'Inês', 'Fernandes', 'ines.fernandes@buypy.com', 'Op!202');
SELECT * FROM Operator;

INSERT INTO Electronic (product_id, serial_num, brand, model, spec_tec, electronic_type)
VALUES 
('P001', 123456789, 'Samsung', 'Galaxy S22', '8GB RAM, 128GB', 'smartphone'),
('P003', 987654321, 'Dell', 'XPS 13', '16GB RAM, 512GB SSD', 'laptop'),
('P005', 456789123, 'Apple', 'iPad Air', '64GB, Wi-Fi', 'tablet'),
('P006', 321654987, 'Sony', 'WH-1000XM5', 'Noise Cancelling', 'headphones'),
('P007', 654321789, 'LG', 'OLED55', '4K, 55 inches', 'tv');
SELECT * FROM Electronic;

INSERT INTO Book (product_id, isbn13, title, genre, publisher, publication_date)
VALUES 
('P002', '9781234567890', 'A Novel', 'fiction', 'Penguin', '2020-01-01'),
('P004', '9780987654321', 'History', 'history', 'Random House', '2019-06-15'),
('P008', '9781112223334', 'Sci-Fi Adventure', 'science fiction', 'Tor Books', '2021-03-10'),
('P009', '9784445556667', 'Mystery Case', 'mystery', 'HarperCollins', '2022-09-20'),
('P010', '9787778889990', 'Fantasy World', 'fantasy', 'Orbit', '2023-02-28');
SELECT * FROM Book;


INSERT INTO Author (author_id, author_name, fullname, birthdate)
VALUES 
(1, 'J.K. Rowling', 'Joanne Rowling', '1965-07-31'),
(2, 'George R.R. Martin', 'George Raymond Richard Martin', '1948-09-20'),
(3, 'Agatha Christie', 'Agatha Mary Clarissa Christie', '1890-09-15'),
(4, 'Isaac Asimov', 'Isaac Yudovich Asimov', '1920-01-02'),
(5, 'J.R.R. Tolkien', 'John Ronald Reuel Tolkien', '1892-01-03');
SELECT * FROM Author;

INSERT INTO BookAuthor (bookauthor_id, product_id, author_id)
VALUES 
(1, 'P002', 1),
(2, 'P004', 3),
(3, 'P008', 4),
(4, 'P009', 3),
(5, 'P010', 5);
SELECT * FROM BookAuthor;

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

DROP USER IF EXISTS 'WEB_CLIENT'@'localhost';
DROP USER IF EXISTS 'BUYDB_OPERATOR'@'localhost';
DROP USER IF EXISTS 'BUYDB_ADMIN'@'localhost';
# Criar utilizador WEB_CLIENT
CREATE USER 'WEB_CLIENT'@'localhost' IDENTIFIED BY 'Limaxy20#a';

GRANT SELECT ON BuyPy.* TO 'WEB_CLIENT'@'localhost';

GRANT INSERT, UPDATE ON BuyPy.Clients TO 'WEB_CLIENT'@'localhost';
GRANT INSERT, UPDATE ON BuyPy.Orders TO 'WEB_CLIENT'@'localhost';
GRANT INSERT, UPDATE ON BuyPy.Ordered_Item TO 'WEB_CLIENT'@'localhost';

GRANT DELETE ON BuyPy.Orders TO 'WEB_CLIENT'@'localhost';
GRANT DELETE ON BuyPy.Ordered_Item TO 'WEB_CLIENT'@'localhost';

GRANT UPDATE (quantity) ON BuyPy.Product TO 'WEB_CLIENT'@'localhost';

GRANT EXECUTE ON PROCEDURE BuyPy.CreateOrder TO 'WEB_CLIENT'@'localhost';
GRANT EXECUTE ON PROCEDURE BuyPy.GetOrderTotal TO 'WEB_CLIENT'@'localhost';

# Criar utilizador BUYDB_OPERATOR
CREATE USER 'BUYDB_OPERATOR'@'localhost' IDENTIFIED BY 'Limaxy20#a';

GRANT SELECT, INSERT, UPDATE, DELETE ON BuyPy.* TO 'BUYDB_OPERATOR'@'localhost';

GRANT EXECUTE ON PROCEDURE BuyPy.CreateOrder TO 'BUYDB_OPERATOR'@'localhost';
GRANT EXECUTE ON PROCEDURE BuyPy.GetOrderTotal TO 'BUYDB_OPERATOR'@'localhost';


# Criar utilizador BUYDB_ADMIN
CREATE USER 'BUYDB_ADMIN'@'localhost' IDENTIFIED BY 'Limaxy20#a';

GRANT ALL PRIVILEGES ON BuyPy.* TO 'BUYDB_ADMIN'@'localhost' WITH GRANT OPTION;

# Aplicar todas as alterações
FLUSH PRIVILEGES;