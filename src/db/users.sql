use BuyPy;

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