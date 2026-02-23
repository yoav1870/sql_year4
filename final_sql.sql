DROP DATABASE IF EXISTS sales;
CREATE DATABASE sales CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE sales;

CREATE TABLE customers (
  customer_id int NOT NULL AUTO_INCREMENT,
  first_name varchar(50) DEFAULT NULL,
  last_name varchar(50) DEFAULT NULL,
  city varchar(50) DEFAULT NULL,
  country varchar(50) DEFAULT NULL,
  PRIMARY KEY (customer_id)
) ENGINE=InnoDB AUTO_INCREMENT=270 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE error_log (
  id int NOT NULL AUTO_INCREMENT,
  error_message text,
  json_input json DEFAULT NULL,
  created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE products (
  product_id int NOT NULL,
  product_name varchar(100) DEFAULT NULL,
  category varchar(50) DEFAULT NULL,
  price decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE regions (
  city varchar(50) NOT NULL,
  region varchar(50) DEFAULT NULL,
  PRIMARY KEY (city)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE sellers (
  seller_id int NOT NULL AUTO_INCREMENT,
  first_name varchar(50) DEFAULT NULL,
  last_name varchar(50) DEFAULT NULL,
  email varchar(100) DEFAULT NULL,
  created_at date DEFAULT NULL,
  PRIMARY KEY (seller_id),
  UNIQUE KEY email (email)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE sales (
  sale_id int NOT NULL AUTO_INCREMENT,
  product_id int DEFAULT NULL,
  customer_id int DEFAULT NULL,
  sale_date date DEFAULT NULL,
  quantity int DEFAULT NULL,
  sale_amount decimal(10,2) DEFAULT NULL,
  id_seller int DEFAULT NULL,
  PRIMARY KEY (sale_id),
  KEY fk_sales_seller (id_seller),
  KEY fk_sales_customer (customer_id),
  KEY fk_sales_product (product_id),
  CONSTRAINT fk_sales_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_sales_product FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_sales_seller FOREIGN KEY (id_seller) REFERENCES sellers (seller_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `customers` VALUES (201,'John','Doe','New York','USA'),(202,'Jane','Smith','London','UK'),(203,'Alice','Johnson','Sydney','Australia'),(204,'Robert','Brown','Toronto','Canada'),(205,'Emily','Davis','New York','USA'),(206,'Michael','Miller','Berlin','Germany'),(207,'Sarah','Wilson','Paris','France'),(208,'David','Anderson','Tokyo','Japan'),(209,'Linda','Thomas','Los Angeles','USA'),(210,'Daniel','Taylor','Rome','Italy'),(231,'Anna','White',NULL,NULL),(232,'Sara','Blue',NULL,NULL),(233,'Tom','Green',NULL,NULL),(234,'David','Black',NULL,NULL);
INSERT INTO `products` VALUES (101,'Product A','Electronics',150.00),(102,'Product B','Clothing',75.00),(103,'Product C','Home Goods',100.00),(104,'Product D','Electronics',150.00),(105,'Product E','Clothing',150.00),(106,'Product F','Home Goods',100.00),(107,'Product G','Electronics',150.00);
INSERT INTO `regions` VALUES ('Berlin','Europe'),('London','Europe'),('Los Angeles','North America'),('New York','North America'),('Paris','Europe'),('Rome','Europe'),('Sydney','Oceania'),('Tokyo','Asia'),('Toronto','North America');
INSERT INTO `sellers` VALUES (1,'Adam','Levi','adam.levi@sales.com','2024-01-01'),(2,'Noa','Cohen','noa.cohen@sales.com','2024-01-05'),(3,'Daniel','Peretz','daniel.peretz@sales.com','2024-01-10'),(4,'Maya','Rosen','maya.rosen@sales.com','2024-01-15'),(5,'Eitan','Katz','eitan.katz@sales.com','2024-02-01'),(6,'Shir','BenDavid','shir.bendavid@sales.com','2024-02-10'),(7,'Lior','Avrahami','lior.avrahami@sales.com','2024-02-20'),(8,'Yael','Friedman','yael.friedman@sales.com','2024-03-01'),(9,'Omer','Goldman','omer.goldman@sales.com','2024-03-10'),(10,'Tal','Mor','tal.mor@sales.com','2024-03-20'),(11,'Avi','Levi','avi.levi11@sales.com','2025-12-29'),(12,'Noam','Peretz','noam.peretz12@sales.com','2025-12-29'),(13,'Yael','Rosen','yael.rosen13@sales.com','2025-12-29'),(14,'Noam','Peretz','noam.peretz14@sales.com','2025-12-29'),(15,'Noam','Peretz','noam.peretz15@sales.com','2025-12-29'),(16,'Yael','Rosen','yael.rosen16@sales.com','2025-12-29'),(17,'Dana','Cohen','dana.cohen17@sales.com','2025-12-29'),(18,'Yael','Rosen','yael.rosen18@sales.com','2025-12-29'),(19,'Noam','Peretz','noam.peretz19@sales.com','2025-12-29'),(20,'Itay','Katz','itay.katz20@sales.com','2025-12-29');
INSERT INTO `sales` VALUES (1,101,201,'2024-01-05',3,450.00,3),(2,102,202,'2024-02-10',1,150.00,2),(3,103,203,'2024-03-15',2,300.00,8),(4,104,204,'2024-04-01',5,750.00,3),(5,101,205,'2024-04-20',2,300.00,1),(6,102,206,'2024-05-10',4,600.00,6),(7,103,207,'2024-06-15',1,100.00,7),(8,105,208,'2024-07-05',3,450.00,4),(9,106,209,'2024-08-10',2,200.00,1),(10,107,210,'2024-09-01',6,900.00,3),(12,107,210,'2025-04-14',2,300.00,1),(14,101,206,'2025-09-22',3,450.00,20),(16,101,209,'2025-03-28',4,600.00,15),(21,102,206,'2026-01-22',4,300.00,1),(23,103,208,'2025-11-07',7,700.00,13),(30,107,204,'2025-07-08',10,1500.00,4),(51,101,201,'2024-12-01',2,300.00,1),(52,102,201,'2024-12-05',3,225.00,1),(54,101,234,'2024-12-01',2,300.00,1),(55,101,201,'2024-12-01',2,300.00,1),(56,102,201,'2024-12-05',3,225.00,1),(58,101,201,'2024-12-01',2,300.00,1),(59,102,201,'2024-12-05',3,225.00,1),(61,101,234,'2024-12-01',2,300.00,1),(62,101,201,'2024-12-01',2,300.00,1),(63,102,201,'2024-12-05',3,225.00,1),(65,101,234,'2024-12-01',2,300.00,1),(66,101,201,'2024-12-01',2,300.00,1),(67,102,201,'2024-12-05',3,225.00,1),(69,102,233,'2025-08-25',10,750.00,20),(70,101,201,'2026-02-20',2,300.00,1),(71,101,201,'2024-12-01',2,300.00,1),(72,102,201,'2024-12-05',3,225.00,1),(78,103,233,'2026-01-02',4,400.00,9),(79,107,206,'2026-01-11',9,1350.00,15),(87,101,234,'2025-07-18',8,1200.00,3),(92,106,205,'2025-09-17',2,200.00,18),(95,105,205,'2025-12-17',4,600.00,5),(100,104,209,'2025-11-25',8,1200.00,17),(104,107,234,'2025-04-07',1,150.00,2),(105,103,232,'2025-10-11',9,900.00,7),(106,107,232,'2025-05-14',7,1050.00,10),(111,101,203,'2025-06-18',8,1200.00,18),(116,105,206,'2025-09-01',3,450.00,13),(119,102,231,'2026-01-23',5,375.00,6),(123,103,202,'2025-05-19',8,800.00,4),(127,104,204,'2025-07-19',10,1500.00,8),(133,104,205,'2025-06-24',6,900.00,20),(135,101,201,'2024-12-01',2,300.00,1),(136,102,201,'2024-12-05',3,225.00,1),(138,101,234,'2024-12-01',2,300.00,1),(139,101,201,'2024-12-01',2,300.00,1),(140,102,201,'2024-12-05',3,225.00,1),(142,101,201,'2024-12-01',2,300.00,1),(143,102,201,'2024-12-05',3,225.00,1),(145,101,201,'2024-12-01',2,300.00,3),(146,102,201,'2024-12-05',3,225.00,3),(148,101,201,'2024-12-01',2,300.00,3),(149,102,201,'2024-12-05',3,225.00,3),(151,101,201,'2024-12-01',2,300.00,3),(152,102,201,'2024-12-05',20,1500.00,3),(154,101,201,'2024-12-01',20,3000.00,3),(155,102,201,'2024-12-05',31,2325.00,3),(157,101,201,'2024-12-01',2,300.00,1),(158,102,201,'2024-12-05',3,225.00,1),(160,101,201,'2024-12-01',2,300.00,1),(161,102,201,'2024-12-05',3,225.00,1),(163,101,201,'2024-12-01',2,300.00,1),(164,102,201,'2024-12-05',3,225.00,1),(166,101,234,'2024-12-01',2,300.00,1);

-- #######################  reports  ###################################
SHOW TABLES;
DROP VIEW IF EXISTS vw_total_sales_per_seller;
DROP VIEW IF EXISTS vw_seller_ranking;
DROP VIEW IF EXISTS vw_avg_sale_per_seller;

CREATE OR REPLACE VIEW vw_total_sales_per_seller AS
WITH seller_totals AS (
    SELECT 
        s.id_seller,
        SUM(s.quantity) AS total_quantity,
        SUM(s.sale_amount) AS total_revenue
    FROM sales s
    GROUP BY s.id_seller
)
SELECT 
    st.id_seller,
    se.first_name,
    se.last_name,
    st.total_quantity,
    st.total_revenue
FROM seller_totals st
JOIN sellers se ON se.seller_id = st.id_seller;

SELECT * FROM vw_total_sales_per_seller;
-- ####################################################################

CREATE OR REPLACE VIEW vw_seller_ranking AS
WITH seller_totals AS (
    SELECT 
        s.id_seller,
        SUM(s.sale_amount) AS total_revenue
    FROM sales s
    GROUP BY s.id_seller
)
SELECT 
    st.id_seller,
    se.first_name,
    se.last_name,
    st.total_revenue,
    RANK() OVER (ORDER BY st.total_revenue DESC) AS revenue_rank
FROM seller_totals st
JOIN sellers se ON se.seller_id = st.id_seller;

SELECT * FROM vw_seller_ranking;
-- ####################################################################
CREATE OR REPLACE VIEW vw_avg_sale_per_seller AS
SELECT 
    s.id_seller,
    se.first_name,
    se.last_name,
    AVG(s.sale_amount) AS avg_sale_amount
FROM sales s
JOIN sellers se ON se.seller_id = s.id_seller
GROUP BY s.id_seller, se.first_name, se.last_name;

SELECT * FROM vw_avg_sale_per_seller;
-- #######################  procedures  ###################################
SHOW PROCEDURE STATUS WHERE Db = 'sales';
DROP PROCEDURE IF EXISTS p_generate_random_customers;
DROP PROCEDURE IF EXISTS p_generate_random_sellers;
DROP PROCEDURE IF EXISTS p_generate_random_sales;
DROP PROCEDURE IF EXISTS p_generate_random_data;
DROP PROCEDURE IF EXISTS p_insert_sales_from_json;
-- Save current max IDs
SELECT MAX(customer_id) INTO @max_customer_before FROM customers;
SELECT MAX(seller_id)   INTO @max_seller_before   FROM sellers;
SELECT MAX(sale_id)     INTO @max_sale_before     FROM sales;
-- Generate Random Customers
DELIMITER $$

CREATE PROCEDURE p_generate_random_customers(IN p_count INT)
BEGIN
    DECLARE v_counter INT DEFAULT 0;
    DECLARE v_exists INT DEFAULT 1;
    DECLARE v_random_city VARCHAR(50);
    DECLARE v_random_country VARCHAR(50);
    DECLARE v_seed_first_name VARCHAR(50);
    DECLARE v_seed_last_name VARCHAR(50);
    DECLARE v_first_name VARCHAR(50);
    DECLARE v_last_name VARCHAR(50);
    DECLARE v_first_name_max_len INT;
    DECLARE v_last_name_max_len INT;
    DECLARE v_token BIGINT UNSIGNED;

    SELECT c.CHARACTER_MAXIMUM_LENGTH
    INTO v_first_name_max_len
    FROM INFORMATION_SCHEMA.COLUMNS c
    WHERE c.TABLE_SCHEMA = DATABASE()
      AND c.TABLE_NAME = 'customers'
      AND c.COLUMN_NAME = 'first_name'
    LIMIT 1;

    SELECT c.CHARACTER_MAXIMUM_LENGTH
    INTO v_last_name_max_len
    FROM INFORMATION_SCHEMA.COLUMNS c
    WHERE c.TABLE_SCHEMA = DATABASE()
      AND c.TABLE_NAME = 'customers'
      AND c.COLUMN_NAME = 'last_name'
    LIMIT 1;

    IF v_first_name_max_len IS NULL OR v_last_name_max_len IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Missing customers column metadata';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM customers
        WHERE first_name IS NOT NULL
          AND last_name IS NOT NULL
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot generate customers without existing customer names';
    END IF;

    WHILE v_counter < p_count DO

        SET v_exists = 1;

        WHILE v_exists > 0 DO
            SELECT first_name, last_name
            INTO v_seed_first_name, v_seed_last_name
            FROM customers
            WHERE first_name IS NOT NULL
              AND last_name IS NOT NULL
            ORDER BY RAND()
            LIMIT 1;

            SET v_token = UUID_SHORT();
            SET v_first_name = LEFT(CONCAT(v_seed_first_name, v_token), v_first_name_max_len);
            SET v_last_name = LEFT(CONCAT(v_seed_last_name, v_token), v_last_name_max_len);

            SELECT COUNT(*)
            INTO v_exists
            FROM customers
            WHERE first_name = v_first_name
              AND last_name = v_last_name;
        END WHILE;

        SELECT city, country
        INTO v_random_city, v_random_country
        FROM customers
        WHERE city IS NOT NULL
          AND country IS NOT NULL
        ORDER BY RAND()
        LIMIT 1;

        IF v_random_city IS NULL THEN
            SELECT city
            INTO v_random_city
            FROM regions
            ORDER BY RAND()
            LIMIT 1;
        END IF;

        INSERT INTO customers(first_name, last_name, city, country)
        VALUES (
            v_first_name,
            v_last_name,
            v_random_city,
            v_random_country
        );

        SET v_counter = v_counter + 1;

    END WHILE;

END$$

DELIMITER ;
-- Generate Random Sellers
DELIMITER $$

CREATE PROCEDURE p_generate_random_sellers(IN p_count INT)
BEGIN
    DECLARE v_counter INT DEFAULT 0;
    DECLARE v_exists INT DEFAULT 1;
    DECLARE v_seed_first_name VARCHAR(50);
    DECLARE v_seed_last_name VARCHAR(50);
    DECLARE v_first_name VARCHAR(50);
    DECLARE v_last_name VARCHAR(50);
    DECLARE v_email VARCHAR(100);
    DECLARE v_email_domain VARCHAR(100);
    DECLARE v_first_name_max_len INT;
    DECLARE v_last_name_max_len INT;
    DECLARE v_email_max_len INT;
    DECLARE v_token BIGINT UNSIGNED;

    SELECT c.CHARACTER_MAXIMUM_LENGTH
    INTO v_first_name_max_len
    FROM INFORMATION_SCHEMA.COLUMNS c
    WHERE c.TABLE_SCHEMA = DATABASE()
      AND c.TABLE_NAME = 'sellers'
      AND c.COLUMN_NAME = 'first_name'
    LIMIT 1;

    SELECT c.CHARACTER_MAXIMUM_LENGTH
    INTO v_last_name_max_len
    FROM INFORMATION_SCHEMA.COLUMNS c
    WHERE c.TABLE_SCHEMA = DATABASE()
      AND c.TABLE_NAME = 'sellers'
      AND c.COLUMN_NAME = 'last_name'
    LIMIT 1;

    SELECT c.CHARACTER_MAXIMUM_LENGTH
    INTO v_email_max_len
    FROM INFORMATION_SCHEMA.COLUMNS c
    WHERE c.TABLE_SCHEMA = DATABASE()
      AND c.TABLE_NAME = 'sellers'
      AND c.COLUMN_NAME = 'email'
    LIMIT 1;

    SELECT SUBSTRING_INDEX(email, CHAR(64), -1)
    INTO v_email_domain
    FROM sellers
    WHERE email IS NOT NULL
      AND INSTR(email, CHAR(64)) > 0
    ORDER BY RAND()
    LIMIT 1;

    IF v_first_name_max_len IS NULL
       OR v_last_name_max_len IS NULL
       OR v_email_max_len IS NULL
       OR v_email_domain IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Missing seller generation metadata';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM sellers
        WHERE first_name IS NOT NULL
          AND last_name IS NOT NULL
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot generate sellers without existing seller names';
    END IF;

    WHILE v_counter < p_count DO

        SET v_exists = 1;

        WHILE v_exists > 0 DO

            SELECT first_name, last_name
            INTO v_seed_first_name, v_seed_last_name
            FROM sellers
            WHERE first_name IS NOT NULL
              AND last_name IS NOT NULL
            ORDER BY RAND()
            LIMIT 1;

            SET v_token = UUID_SHORT();
            SET v_first_name = LEFT(CONCAT(v_seed_first_name, v_token), v_first_name_max_len);
            SET v_last_name = LEFT(CONCAT(v_seed_last_name, v_token), v_last_name_max_len);
            SET v_email = LEFT(
                CONCAT(
                    LOWER(REPLACE(CONCAT(v_first_name, v_last_name, v_token), ' ', '')),
                    CHAR(64),
                    v_email_domain
                ),
                v_email_max_len
            );

            SELECT COUNT(*)
            INTO v_exists
            FROM sellers
            WHERE (first_name = v_first_name AND last_name = v_last_name)
               OR email = v_email;

        END WHILE;

        INSERT INTO sellers(first_name, last_name, email, created_at)
        VALUES (
            v_first_name,
            v_last_name,
            v_email,
            CURDATE()
        );

        SET v_counter = v_counter + 1;

    END WHILE;

END$$

DELIMITER ;
-- Generate Random Sales
DELIMITER $$

CREATE PROCEDURE p_generate_random_sales(IN p_count INT)
BEGIN
    DECLARE v_counter INT DEFAULT 0;
    DECLARE v_customer_id INT;
    DECLARE v_seller_id INT;
    DECLARE v_product_id INT;
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_quantity INT;
    DECLARE v_sale_date DATE;
    DECLARE v_min_sale_quantity INT;
    DECLARE v_max_sale_quantity INT;
    DECLARE v_max_sale_days_back INT;
    DECLARE v_quantity_range INT;

    SELECT
        MIN(quantity),
        MAX(quantity),
        MAX(DATEDIFF(CURDATE(), sale_date))
    INTO
        v_min_sale_quantity,
        v_max_sale_quantity,
        v_max_sale_days_back
    FROM sales
    WHERE quantity IS NOT NULL
      AND sale_date IS NOT NULL;

    IF v_min_sale_quantity IS NULL
       OR v_max_sale_quantity IS NULL
       OR v_max_sale_days_back IS NULL
       OR v_min_sale_quantity <= 0
       OR v_max_sale_quantity < v_min_sale_quantity
       OR v_max_sale_days_back <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot derive random-sales limits from existing sales data';
    END IF;

    SET v_quantity_range = (v_max_sale_quantity - v_min_sale_quantity) + 1;

    WHILE v_counter < p_count DO

        SELECT customer_id INTO v_customer_id
        FROM customers
        ORDER BY RAND()
        LIMIT 1;

        SELECT seller_id INTO v_seller_id
        FROM sellers
        ORDER BY RAND()
        LIMIT 1;

        SELECT product_id, price
        INTO v_product_id, v_price
        FROM products
        ORDER BY RAND()
        LIMIT 1;

        SET v_quantity = FLOOR(v_min_sale_quantity + RAND() * v_quantity_range);
        SET v_sale_date = DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * (v_max_sale_days_back + 1)) DAY);

        INSERT INTO sales(product_id, customer_id, sale_date, quantity, sale_amount, id_seller)
        VALUES (
            v_product_id,
            v_customer_id,
            v_sale_date,
            v_quantity,
            v_quantity * v_price,
            v_seller_id
        );

        SET v_counter = v_counter + 1;
    END WHILE;

END$$

DELIMITER ;
-- main generate data Procedure
DELIMITER $$

CREATE PROCEDURE p_generate_random_data(
    IN p_customers INT,
    IN p_sellers INT,
    IN p_sales INT
)
main_block: BEGIN

    DECLARE v_max_customer_before INT DEFAULT 0;
    DECLARE v_max_seller_before INT DEFAULT 0;
    DECLARE v_max_sale_before INT DEFAULT 0;

    SELECT IFNULL(MAX(customer_id),0) INTO v_max_customer_before FROM customers;
    SELECT IFNULL(MAX(seller_id),0) INTO v_max_seller_before FROM sellers;
    SELECT IFNULL(MAX(sale_id),0) INTO v_max_sale_before FROM sales;

    START TRANSACTION;

    CALL p_generate_random_customers(p_customers);
    CALL p_generate_random_sellers(p_sellers);
    CALL p_generate_random_sales(p_sales);

    COMMIT;

    SELECT * 
    FROM customers
    WHERE customer_id > v_max_customer_before;

    SELECT *
    FROM sellers
    WHERE seller_id > v_max_seller_before;

    SELECT *
    FROM sales
    WHERE sale_id > v_max_sale_before;

END$$

DELIMITER ;

SET @demo_customers = (SELECT COUNT(*) FROM regions);
SET @demo_sellers = (SELECT COUNT(*) FROM products);
SET @demo_sales = (
    SELECT COUNT(*) * (SELECT COUNT(*) FROM regions)
    FROM products
);

CALL p_generate_random_data(@demo_customers, @demo_sellers, @demo_sales);

SELECT * FROM customers WHERE customer_id > @max_customer_before;
SELECT * FROM sellers WHERE seller_id > @max_seller_before;
SELECT * FROM sales WHERE sale_id > @max_sale_before;

DELETE FROM sales WHERE sale_id > @max_sale_before;
DELETE FROM customers WHERE customer_id > @max_customer_before;
DELETE FROM sellers WHERE seller_id > @max_seller_before;
-- ####################################################################
SHOW PROCEDURE STATUS WHERE Db = 'sales';
DROP PROCEDURE IF EXISTS p_log_error;
DROP PROCEDURE IF EXISTS p_validate_json_structure;
DROP PROCEDURE IF EXISTS p_validate_seller;
DROP PROCEDURE IF EXISTS p_insert_sales_from_json;
-- Error Logging Procedure
DELIMITER $$

CREATE PROCEDURE p_log_error(
    IN p_message TEXT,
    IN p_json JSON
)
BEGIN
    INSERT INTO error_log(error_message, json_input)
    VALUES (p_message, p_json);
END$$

DELIMITER ;
-- JSON Structure Validation
DELIMITER $$

CREATE PROCEDURE p_validate_json_structure(
    IN p_json JSON,
    OUT p_is_valid BOOLEAN,
    OUT p_error_message TEXT
)
validation_block: BEGIN

    SET p_is_valid = TRUE;
    SET p_error_message = NULL;

    IF JSON_EXTRACT(p_json, '$.sales') IS NULL THEN
        SET p_is_valid = FALSE;
        SET p_error_message = 'Missing sales object';
        LEAVE validation_block;
    END IF;

    IF JSON_EXTRACT(p_json, '$.sales.CustomerFirstName') IS NULL THEN
        SET p_is_valid = FALSE;
        SET p_error_message = 'Missing CustomerFirstName';
        LEAVE validation_block;
    END IF;

    IF JSON_EXTRACT(p_json, '$.sales.CustomerLastName') IS NULL THEN
        SET p_is_valid = FALSE;
        SET p_error_message = 'Missing CustomerLastName';
        LEAVE validation_block;
    END IF;

    IF JSON_EXTRACT(p_json, '$.sales.SellerID') IS NULL THEN
        SET p_is_valid = FALSE;
        SET p_error_message = 'Missing SellerID';
        LEAVE validation_block;
    END IF;

    IF JSON_EXTRACT(p_json, '$.sales.purchases') IS NULL THEN
        SET p_is_valid = FALSE;
        SET p_error_message = 'Missing purchases array';
        LEAVE validation_block;
    END IF;

END$$

DELIMITER ;
-- validate seller
DELIMITER $$

CREATE PROCEDURE p_validate_seller(
    IN p_json JSON,
    OUT p_is_valid BOOLEAN,
    OUT p_error_message TEXT
)
seller_block: BEGIN
    DECLARE v_seller_id INT;

    SET p_is_valid = TRUE;
    SET p_error_message = NULL;

    SET v_seller_id = JSON_EXTRACT(p_json, '$.sales.SellerID');

    IF NOT EXISTS (
        SELECT 1
        FROM sellers
        WHERE seller_id = v_seller_id
    ) THEN
        SET p_is_valid = FALSE;
        SET p_error_message = 'Invalid Seller ID';
        LEAVE seller_block;
    END IF;

END$$

DELIMITER ;
-- insert json 
DELIMITER $$

CREATE PROCEDURE p_insert_sales_from_json(
    IN p_json JSON
)
insert_block: BEGIN

    DECLARE v_customer_id INT;
    DECLARE v_seller_id INT;
    DECLARE v_first_name VARCHAR(50);
    DECLARE v_last_name VARCHAR(50);
    DECLARE v_inserted_count INT DEFAULT 0;
    DECLARE v_failed_count INT DEFAULT 0;
    DECLARE v_failed_items_json JSON;
    DECLARE v_completed_items_json JSON;

    DECLARE v_is_valid BOOLEAN;
    DECLARE v_error TEXT;

    CALL p_validate_json_structure(p_json, v_is_valid, v_error);

    IF v_is_valid = FALSE THEN
        CALL p_log_error(v_error, p_json);
        SELECT JSON_OBJECT(
            'inserted_rows', 0,
            'failed_rows', 0,
            'status', v_error,
            'failed_items', JSON_ARRAY(),
            'completed_items', JSON_ARRAY()
        ) AS result;
        LEAVE insert_block;
    END IF;

    CALL p_validate_seller(p_json, v_is_valid, v_error);

    IF v_is_valid = FALSE THEN
        CALL p_log_error(v_error, p_json);
        SELECT JSON_OBJECT(
            'inserted_rows', 0,
            'failed_rows', 0,
            'status', v_error,
            'failed_items', JSON_ARRAY(),
            'completed_items', JSON_ARRAY()
        ) AS result;
        LEAVE insert_block;
    END IF;

    START TRANSACTION;

    SET v_first_name = JSON_UNQUOTE(JSON_EXTRACT(p_json, '$.sales.CustomerFirstName'));
    SET v_last_name  = JSON_UNQUOTE(JSON_EXTRACT(p_json, '$.sales.CustomerLastName'));
    SET v_seller_id  = JSON_EXTRACT(p_json, '$.sales.SellerID');

    SELECT customer_id INTO v_customer_id
    FROM customers
    WHERE first_name = v_first_name
      AND last_name  = v_last_name
    LIMIT 1;

    IF v_customer_id IS NULL THEN
        INSERT INTO customers(first_name, last_name, city, country)
        VALUES (v_first_name, v_last_name, NULL, NULL);
        SET v_customer_id = LAST_INSERT_ID();
    END IF;

    DROP TEMPORARY TABLE IF EXISTS tmp_purchases;

    CREATE TEMPORARY TABLE tmp_purchases AS
    SELECT 
        jt.productId,
        jt.quantity,
        jt.saleDate,
        CASE
            WHEN jt.productId IS NULL
                THEN 'Missing product ID'
            WHEN p.product_id IS NULL
                THEN 'Invalid product ID'
            WHEN jt.quantity IS NULL OR jt.quantity <= 0
                THEN 'Invalid quantity'
            WHEN jt.saleDate IS NULL OR jt.saleDate > CURDATE()
                THEN 'Invalid sale date'
            ELSE 'VALID'
        END AS validation_status
    FROM JSON_TABLE(
            p_json,
            '$.sales.purchases[*]'
            COLUMNS (
                productId INT PATH '$.productId',
                quantity  INT PATH '$.quantity',
                saleDate  DATE PATH '$.saleDate'
            )
         ) jt
    LEFT JOIN products p ON p.product_id = jt.productId;

    INSERT INTO error_log(error_message, json_input)
    SELECT validation_status, p_json
    FROM tmp_purchases
    WHERE validation_status <> 'VALID';

    SET v_failed_count = ROW_COUNT();

    INSERT INTO sales (
        product_id,
        customer_id,
        sale_date,
        quantity,
        sale_amount,
        id_seller
    )
    SELECT 
        tp.productId,
        v_customer_id,
        tp.saleDate,
        tp.quantity,
        tp.quantity * p.price,
        v_seller_id
    FROM tmp_purchases tp
    JOIN products p ON p.product_id = tp.productId
    WHERE tp.validation_status = 'VALID';

    SET v_inserted_count = ROW_COUNT();

    COMMIT;

    SELECT IFNULL(
        JSON_ARRAYAGG(
            JSON_OBJECT(
                'productId', productId,
                'quantity', quantity,
                'saleDate', saleDate,
                'error', validation_status
            )
        ),
        JSON_ARRAY()
    )
    INTO v_failed_items_json
    FROM tmp_purchases
    WHERE validation_status <> 'VALID';

    SELECT IFNULL(
        JSON_ARRAYAGG(
            JSON_OBJECT(
                'productId', productId,
                'quantity', quantity,
                'saleDate', saleDate
            )
        ),
        JSON_ARRAY()
    )
    INTO v_completed_items_json
    FROM tmp_purchases
    WHERE validation_status = 'VALID';

    SELECT JSON_OBJECT(
        'inserted_rows', v_inserted_count,
        'failed_rows', v_failed_count,
        'status', 'Completed',
        'failed_items', IFNULL(v_failed_items_json, JSON_ARRAY()),
        'completed_items', IFNULL(v_completed_items_json, JSON_ARRAY())
    ) AS result;

END$$

DELIMITER ;
-- valid json 
SET @json_valid = '
{
  "sales": {
    "CustomerFirstName": "John",
    "CustomerLastName": "Doe",
    "SellerID": 1,
    "purchases": [
      { "productId": 101, "quantity": 2, "saleDate": "2024-12-01" },
      { "productId": 102, "quantity": 3, "saleDate": "2024-12-05" }
    ]
  }
}';

CALL p_insert_sales_from_json(@json_valid);
SELECT * FROM error_log ORDER BY id DESC;
SELECT * FROM sales ORDER BY sale_id DESC LIMIT 2;
-- invalid seller 
SET @json_invalid_seller = '
{
  "sales": {
    "CustomerFirstName": "Mike",
    "CustomerLastName": "Smith",
    "SellerID": 9999,
    "purchases": [
      { "productId": 101, "quantity": 2, "saleDate": "2024-12-01" }
    ]
  }
}';

CALL p_insert_sales_from_json(@json_invalid_seller);
SELECT * FROM error_log ORDER BY id DESC;
-- invalid product
SET @json_invalid_product = '
{
  "sales": {
    "CustomerFirstName": "Anna",
    "CustomerLastName": "White",
    "SellerID": 1,
    "purchases": [
      { "productId": 9999, "quantity": 2, "saleDate": "2024-12-01" }
    ]
  }
}';

CALL p_insert_sales_from_json(@json_invalid_product);
SELECT * FROM error_log ORDER BY id DESC;
-- invalid quantity
SET @json_invalid_quantity = '
{
  "sales": {
    "CustomerFirstName": "Sara",
    "CustomerLastName": "Blue",
    "SellerID": 1,
    "purchases": [
      { "productId": 101, "quantity": -5, "saleDate": "2024-12-01" }
    ]
  }
}';

CALL p_insert_sales_from_json(@json_invalid_quantity);
SELECT * FROM error_log ORDER BY id DESC;
-- invalid saleDate
SET @json_invalid_date = '
{
  "sales": {
    "CustomerFirstName": "Tom",
    "CustomerLastName": "Green",
    "SellerID": 1,
    "purchases": [
      { "productId": 101, "quantity": 2 , "saleDate": null}
    ]
  }
}';

CALL p_insert_sales_from_json(@json_invalid_date);
SELECT * FROM error_log ORDER BY id DESC;
-- one good , two not 
SET @json_mixed = '
{
  "sales": {
    "CustomerFirstName": "David",
    "CustomerLastName": "Black",
    "SellerID": 1,
    "purchases": [
      { "productId": 101, "quantity": 2, "saleDate": "2024-12-01" },
      { "productId": 9999, "quantity": 2, "saleDate": "2024-12-01" },
      { "productId": 102, "quantity": -1, "saleDate": "2024-12-01" }
    ]
  }
}';

CALL p_insert_sales_from_json(@json_mixed);
SELECT * FROM error_log ORDER BY id DESC;
-- missing customers info
SET @json_missing_field = '
{
  "sales": {
    "CustomerFirstName": "NoLastName",
    "SellerID": 1,
    "purchases": [
      { "productId": 101, "quantity": 2, "saleDate": "2024-12-01" }
    ]
  }
}';

CALL p_insert_sales_from_json(@json_missing_field);
SELECT * FROM error_log ORDER BY id DESC;
-- clean new data 
DROP PROCEDURE IF EXISTS p_cleanup_demo_data;

DELIMITER $$

CREATE PROCEDURE p_cleanup_demo_data(
    IN p_customer_threshold INT,
    IN p_seller_threshold INT
)
BEGIN

    DECLARE v_deleted_sales INT DEFAULT 0;
    DECLARE v_deleted_customers INT DEFAULT 0;
    DECLARE v_deleted_sellers INT DEFAULT 0;
    DECLARE v_deleted_logs INT DEFAULT 0;

    START TRANSACTION;
    -- Delete dependent sales first
    DELETE FROM sales
    WHERE id_seller >= p_seller_threshold
       OR customer_id >= p_customer_threshold;

    SET v_deleted_sales = ROW_COUNT();
    -- Delete customers
    DELETE FROM customers
    WHERE customer_id >= p_customer_threshold;

    SET v_deleted_customers = ROW_COUNT();
    -- Delete sellers
    DELETE FROM sellers
    WHERE seller_id >= p_seller_threshold;

    SET v_deleted_sellers = ROW_COUNT();
    -- Delete logs
    DELETE FROM error_log;

    SET v_deleted_logs = ROW_COUNT();

    COMMIT;
    -- Return summary
    SELECT 
        v_deleted_sales     AS deleted_sales,
        v_deleted_customers AS deleted_customers,
        v_deleted_sellers   AS deleted_sellers,
        v_deleted_logs      AS deleted_error_logs,
        'Cleanup Completed' AS status;

END$$

DELIMITER ;

SET @cleanup_customer_threshold = (
    SELECT IFNULL(MAX(customer_id), 0) + 1
    FROM customers
);
SET @cleanup_seller_threshold = (
    SELECT IFNULL(MAX(seller_id), 0) + 1
    FROM sellers
);

CALL p_cleanup_demo_data(@cleanup_customer_threshold, @cleanup_seller_threshold);
