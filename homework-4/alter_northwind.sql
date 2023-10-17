-- Подключиться к БД Northwind и сделать следующие изменения:
-- 1. Добавить ограничение на поле unit_price таблицы products (цена должна быть больше 0)
ALTER TABLE products ADD CONSTRAINT chk_products_unit_price CHECK (unit_price > 0);

-- 2. Добавить ограничение, что поле discontinued таблицы products может содержать только значения 0 или 1
ALTER TABLE products ADD CONSTRAINT chk_products_discontinued CHECK (discontinued IN (0, 1));

-- 3. Создать новую таблицу, содержащую все продукты, снятые с продажи (discontinued = 1)
SELECT * INTO products_discontinued
FROM products
WHERE discontinued = 1

-- 4. Удалить из products товары, снятые с продажи (discontinued = 1)
-- Для 4-го пункта может потребоваться удаление ограничения, связанного с foreign_key. Подумайте, как это можно решить, чтобы связь с таблицей order_details все же осталась.

-- я так поняла, что в принципе можно сделать: отвязать ключи, удалить продукты снятые с продажи,
-- потом удалить связанные с ними записи в order_details, а потом связанные с ними записи в orders7.
-- И вернуть ключи
ALTER TABLE order_details DROP CONSTRAINT fk_order_details_products;

ALTER TABLE order_details DROP CONSTRAINT fk_order_details_orders;

DELETE FROM products WHERE discontinued = 1;

DELETE FROM order_details
WHERE product_id NOT IN (SELECT product_id FROM  products);


DELETE FROM orders
WHERE order_id NOT IN (SELECT order_id FROM order_details);

ALTER TABLE order_details ADD CONSTRAINT fk_order_details_products FOREIGN KEY(product_id) REFERENCES products(product_id);
ALTER TABLE order_details ADD CONSTRAINT fk_order_details_orders FOREIGN KEY(order_id) REFERENCES orders(order_id);


-- Но потом я подумала может быть параллельно создать дополнительные таблицы в которых сохранить данные
-- products_discontinued о продуктах снятых с продажи, archive_order_details и archive_orders с архивными
-- записями о заказах и деталях заказов. И попыталась связать их ключами так же, как в изначальных таблицах

ALTER TABLE order_details DROP CONSTRAINT fk_order_details_products;

SELECT * INTO products_discontinued FROM products WHERE discontinued = 1;
ALTER TABLE products_discontinued ADD CONSTRAINT pk_products_discontinued PRIMARY KEY(product_id);
ALTER TABLE products_discontinued ADD CONSTRAINT fk_products_categories FOREIGN KEY(category_id) REFERENCES categories(category_id);
ALTER TABLE products_discontinued ADD CONSTRAINT fk_products_suppliers FOREIGN KEY(supplier_id) REFERENCES suppliers(supplier_id);

DELETE FROM products WHERE discontinued = 1;

SELECT * INTO archive_order_details
FROM order_details
WHERE product_id IN (SELECT product_id FROM  products_discontinued);
ALTER TABLE archive_order_details ADD CONSTRAINT pk_archive_order_details PRIMARY KEY(product_id, order_id);
ALTER TABLE archive_order_details ADD CONSTRAINT fk_archive_order_details_archive_orders FOREIGN KEY(order_id) REFERENCES archive_orders(order_id);
ALTER TABLE archive_order_details ADD CONSTRAINT fk_archive_order_details_products_discontinued FOREIGN KEY(product_id) REFERENCES products_discontinued(product_id);

DELETE FROM order_details
WHERE product_id NOT IN (SELECT product_id FROM  products);

SELECT * INTO archive_orders
FROM orders
WHERE order_id IN (SELECT order_id FROM archive_order_details)
ALTER TABLE archive_orders ADD CONSTRAINT pk_archive_orders PRIMARY KEY(order_id);
ALTER TABLE archive_orders ADD CONSTRAINT fk_archive_orders_customers FOREIGN KEY(customer_id) REFERENCES customers(customer_id);
ALTER TABLE archive_orders ADD CONSTRAINT fk_archive_orders_employees FOREIGN KEY(employee_id) REFERENCES employees(employee_id);
ALTER TABLE archive_orders ADD CONSTRAINT fk_archive_orders_shippers FOREIGN KEY(ship_via) REFERENCES shippers(shipper_id);

ALTER TABLE order_details DROP CONSTRAINT fk_order_details_orders;

DELETE FROM orders
WHERE order_id NOT IN (SELECT order_id FROM order_details)

ALTER TABLE order_details ADD CONSTRAINT fk_order_details_products FOREIGN KEY(product_id) REFERENCES products(product_id);
ALTER TABLE order_details ADD CONSTRAINT fk_order_details_orders FOREIGN KEY(order_id) REFERENCES orders(order_id);
