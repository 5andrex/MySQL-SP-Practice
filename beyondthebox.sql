-- 1. Create Database
CREATE SCHEMA beyondthebox DEFAULT CHARACTER SET utf8mb4;
USE beyondthebox;


-- 2. Create Tables (products, inventory, purchase_transaction)
CREATE TABLE apple_product (
	product_id BIGINT NOT NULL AUTO_INCREMENT,
    product_type VARCHAR(55) NOT NULL,
    product_model VARCHAR(55) NOT NULL,
    PRIMARY KEY (product_id)
);

CREATE TABLE store_inventory (
	inventory_id BIGINT NOT NULL AUTO_INCREMENT,
    product_id BIGINT NOT NULL,
    inventory_quantity BIGINT NOT NULL,
    PRIMARY KEY (inventory_id),
    FOREIGN KEY (product_id) REFERENCES apple_product(product_id)
);

CREATE TABLE purchase_transaction (
	transaction_id BIGINT NOT NULL AUTO_INCREMENT,
    inventory_id BIGINT NOT NULL,
    purchase_quantity BIGINT NOT NULL,
    PRIMARY KEY (transaction_id),
    FOREIGN KEY (inventory_id) REFERENCES store_inventory(inventory_id)
);


-- 3. Insert records in the tables
INSERT INTO apple_product (product_type, product_model)
VALUES 
('iPhone', 'iPhone 12'),
('iPhone','iPhone 13 Pro'),
('iPad', 'iPad Mini'),
('Mac', 'MacBook Air with M1 chip'),
('Mac', 'MacBook Pro 13"');

INSERT INTO store_inventory (product_id, inventory_quantity)
VALUES
(3, 30),
(1, 15),
(5, 7),
(4, 11),
(2, 18);

-- update inventory quantities
UPDATE store_inventory
set inventory_quantity = 50
WHERE inventory_id IN(1,2,3,4,5);


-- Create Stored Procedure
USE `beyondthebox`;
DROP procedure IF EXISTS `purchaseTransaction`;

USE `beyondthebox`;
DROP procedure IF EXISTS `beyondthebox`.`purchaseTransaction`;
;

DELIMITER $$
USE `beyondthebox`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `purchaseTransaction`(in inventoryID BIGINT, in quantity BIGINT)
BEGIN

DECLARE inv_quantity BIGINT;

SELECT inventory_quantity INTO inv_quantity
FROM store_inventory WHERE inventory_id = inventoryID;

	IF inv_quantity <= 5 THEN
		SELECT 'Error in query, please add item in inventory';
    
    ELSE
        INSERT INTO purchase_transaction (inventory_id, purchase_quantity) VALUES
        (inventoryID, quantity);
        
        UPDATE store_inventory
		set inventory_quantity = inventory_quantity - quantity 
		WHERE inventory_id = inventoryID; 
        
END IF;

END$$

DELIMITER ;
;





-- Disregard
-- CREATE TRIGGER updatePurchaseTransaction
-- AFTER INSERT ON purchase_transaction

-- FOR EACH ROW
--     UPDATE store_inventory
--     set inventory_quantity = inventory_quantity - NEW.purchase_quantity 
--     WHERE inventory_id = NEW.inventory_id;
    
-- INSERT INTO purchase_transaction (inventory_id, purchase_quantity)
-- VALUES
-- (1, 3); -- inventory_quantity of inventory_id = 1 will be subtracted by 3
