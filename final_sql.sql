use sales;

-- #######################  error_logs  ###################################


CREATE TABLE IF NOT EXISTS error_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    error_message TEXT,
    json_input JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- #######################  reports  ###################################
SHOW TABLES;
DROP TEMPORARY TABLE IF EXISTS vw_total_sales_per_seller;
DROP TEMPORARY TABLE IF EXISTS vw_seller_ranking;
DROP TEMPORARY TABLE IF EXISTS vw_avg_sale_per_seller;



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
    DECLARE v_random_country VARCHAR(50);
    DECLARE v_first_name VARCHAR(50);
    DECLARE v_last_name VARCHAR(50);
    

    WHILE v_counter < p_count DO

        SET v_exists = 1;

        WHILE v_exists > 0 DO
            SET v_first_name = CONCAT('Customer_', FLOOR(RAND()*10000));
            SET v_last_name  = CONCAT('Last_', FLOOR(RAND()*10000));

            SELECT COUNT(*)
            INTO v_exists
            FROM customers
            WHERE first_name = v_first_name
              AND last_name = v_last_name;
        END WHILE;

        -- Get random existing country
        SELECT country
        INTO v_random_country
        FROM customers
        WHERE country IS NOT NULL
        ORDER BY RAND()
        LIMIT 1;

        INSERT INTO customers(first_name, last_name, city, country)
        VALUES (
            v_first_name,
            v_last_name,
            (SELECT city FROM regions ORDER BY RAND() LIMIT 1),
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
    DECLARE v_first_name VARCHAR(50);
    DECLARE v_last_name VARCHAR(50);
    DECLARE v_email VARCHAR(100);

    WHILE v_counter < p_count DO

        SET v_exists = 1;

        WHILE v_exists > 0 DO

            SET v_first_name = CONCAT('Seller_', FLOOR(RAND()*10000));
            SET v_last_name  = CONCAT('Last_', FLOOR(RAND()*10000));
            SET v_email      = CONCAT('seller_', FLOOR(RAND()*1000000), '@mail.com');

            SELECT COUNT(*)
            INTO v_exists
            FROM sellers
            WHERE first_name = v_first_name
              AND last_name  = v_last_name
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

        SET v_quantity = FLOOR(1 + RAND()*10);
        SET v_sale_date = DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY);

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


CALL p_generate_random_data(10, 5, 20);

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

    SELECT JSON_OBJECT(
        'inserted_rows', v_inserted_count,
        'failed_rows', v_failed_count,
        'status', 'Completed',
        'failed_items',
            IFNULL(
                (
                    SELECT JSON_ARRAYAGG(
                        JSON_OBJECT(
                            'productId', productId,
                            'quantity', quantity,
                            'saleDate', saleDate,
                            'error', validation_status
                        )
                    )
                    FROM tmp_purchases
                    WHERE validation_status <> 'VALID'
                ),
                JSON_ARRAY()
            ),
        'completed_items',
            IFNULL(
                (
                    SELECT JSON_ARRAYAGG(
                        JSON_OBJECT(
                            'productId', productId,
                            'quantity', quantity,
                            'saleDate', saleDate
                        )
                    )
                    FROM tmp_purchases
                    WHERE validation_status = 'VALID'
                ),
                JSON_ARRAY()
            )
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

CALL p_cleanup_demo_data(235, 31);



