use BuyPy;

#Inserir valores
INSERT INTO Clients (client_id, fullname, email, password_client, address, zip_code, city, country, phone_number, last_login, birthdate, is_active)
VALUES 
(1, 'Diogo Pedro Silva', 'diogo.silva@email.com', 'Pass#123', 'Rua das Porcas, nº10', 1234, 'Lisboa', 'Portugal', '912345678', '2025-07-26 14:00:00', '1990-01-15', TRUE),
(2, 'Ana Sofia Costa', 'ana.costa@email.com', 'Test$456', 'Avenida Central, nº25', 5678, 'Porto', 'Portugal', '923456789', '2025-07-26 14:05:00', '1985-03-22', TRUE),
(3, 'Pedro Miguel Santos', 'pedro.santos@email.com', 'Abc?789', 'Rua da Cabra, nº50', 9012, 'Faro', 'Portugal', '934567890', '2025-07-26 14:10:00', '1995-07-10', FALSE),
(4, 'Maria Clara Oliveira', 'maria.oliveira@email.com', 'Xyz%101', 'Praça da Vigarista, nº15', 3456, 'Coimbra', 'Portugal', '945678901', '2025-07-26 14:15:00', '1988-11-30', TRUE),
(5, 'Lucas André Almeida', 'lucas.almeida@email.com', 'Qwe!202', 'Rua da Carlota, nº30', 7890, 'Braga', 'Portugal', '956789012', '2025-07-26 14:20:00', '1992-05-05', FALSE);
SELECT * FROM Clients;

INSERT INTO Orders (order_id, date_time, delivery_method, order_status, payment_card_number, payment_card_name, payment_card_expiration, client_id)
VALUES 
(1, '2025-07-25 10:00:00', 'regular', 'open', 1234567890123456, 'Diogo Silva', '2027-12-31', 1),
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
('P004', '9780987654321', 'History', 'history', 'Paramount', '2019-06-15'),
('P008', '9781112223334', 'Sci-Fi Adventure', 'science fiction', 'Toti Books', '2021-03-10'),
('P009', '9784445556667', 'Mystery Case', 'mystery', 'HarperCollins', '2022-09-20'),
('P010', '9787778889990', 'Fantasy World', 'fantasy', 'Orbit', '2023-02-28');
SELECT * FROM Book;


INSERT INTO Author (author_id, author_name, fullname, birthdate)
VALUES 
(1, 'J.K. Powling', 'Joanne Powling', '1965-07-31'),
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
