-- Task 1 Feb. 8, 2023

-- 1. Create Database products
CREATE SCHEMA products DEFAULT CHARACTER SET utf8mb4;
USE products;


-- 2. Create Tables (product, quantity, transaction)
CREATE TABLE product (
product_id BIGINT NOT NULL,
product_name VARCHAR(55) NOT NULL,
product_description VARCHAR(255) NOT NULL,
product_manufacturer VARCHAR(50) NOT NULL,
PRIMARY KEY (product_id)
);

CREATE TABLE inventory (
inventory_id BIGINT NOT NULL,
product_id BIGINT NOT NULL,
quantity BIGINT NOT NULL,
PRIMARY KEY (inventory_id)
);

CREATE TABLE purchase_transaction (
	purchase_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    purchase_quantity BIGINT NOT NULL,
    PRIMARY KEY (purchase_id)
);

-- foreign keys
ALTER TABLE inventory 
ADD FOREIGN KEY (product_id) REFERENCES product(product_id);

ALTER TABLE purchase_transaction
ADD FOREIGN KEY (product_id) REFERENCES product(product_id);


-- 3. Insert Record into product table
INSERT INTO product VALUES
(1,'Air Force 1', 'Lifestyle Shoes', 'Nike'),
(2,'Stan Smith','Lifestyle Shoes','Adidas'),
(3,'Chuck 70s','High Tops Shoes','Converse'),
(4,'993 core','Lifestyle Shoes','New Balance'),
(5,'XT-6','Outdoor Shoes','Salomon'),
(6,'Superstar','Lifestyle Shoes','Adidas'),
(7,'Air Jordan 11','Basketball Shoes','Nike'),
(8,'SB Dunk','Skate Shoes','Nike'),
(9,'Samba','Lifestyle Shoes','Adidas'),
(10,'Fresh Foam','Running Shoes','New Balance'),
(11,'Flyknit','Running Shoes','Nike'),
(12,'Ultraboost','Running Shoes','Adidas'),
(13,'Cortez','Lifestyle Shoes','Nike'),
(14,'550','Lifestyle Shoes','New Balance'),
(15,'Yeezy 360','Lifestyle Shoes','Adidas');

-- insert Record into inventory
INSERT INTO inventory VALUES
(1, 14, 11),
(2, 4, 25),
(3, 1, 13),
(4, 7, 3),
(5, 3, 27),
(6, 13, 7),
(7, 11, 19),
(8, 10, 6),
(9, 9, 15),
(10, 8, 9),
(11, 2, 28),
(12, 6, 22),
(13, 12, 10),
(14, 5, 3),
(15, 15, 2);

-- 4. query / every purchase will reflect new quantity

SELECT purchase_transaction.purchase_id, inventory.product_id
FROM purchase_transaction
INNER JOIN inventory on purchase_transaction.product_id=inventory.product_id;

CREATE TRIGGER purchaseUpdateInventory
AFTER INSERT ON purchase_transaction


FOR EACH ROW
	UPDATE inventory
    set quantity = quantity - NEW.purchase_quantity
    WHERE product_id = NEW.product_id;
 

INSERT INTO purchase_transaction VALUES
(1, 13, 2), -- minus 2  product id 13  7 mgigng 5
(2, 11, 4), -- minus 4 pid 11 19 15
(3,10, 1), -- minus 1 pid 10 6 5
(4, 12, 5); -- pid 12 dapat maging 5



-- Disregard SQL Queries below

CREATE TRIGGER purchaseUpdateInventory
AFTER INSERT ON purchase_transaction
FOR EACH ROW
BEGIN
  DECLARE inventory_quantity INT

  SELECT inventory_quantity = quantity 
  FROM inventory 
  WHERE product_id = NEW.product_id;

  IF inventory_quantity - NEW.purchase_quantity >= 5 
  BEGIN 
    UPDATE inventory
    set quantity = quantity - NEW.purchase_quantity
    WHERE product_id = NEW.product_id;
  END 
  ELSE 
  BEGIN 
    PRINT 'Error in query, need to add inventory';
    ROLLBACK TRANSACTION;
  END;
END;

-- if item < 5, error in query need to add inventory
