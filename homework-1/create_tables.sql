-- SQL-команды для создания таблиц
CREATE TABLE employees
(
	employee_id int PRIMARY KEY,
	first_name varchar(100) NOT NULL,
	last_name varchar(100) NOT NULL,
	title varchar(100) NOT NULL,
	birth_date date,
	notes text
);

CREATE TABLE customers
(
	customer_id varchar(100) NOT NULL PRIMARY KEY,
	company_name varchar(100) NOT NULL,
	contact_name varchar(100)
);

CREATE TABLE orders
(
	order_id int NOT NULL PRIMARY KEY,
	customer varchar(100) NOT NULL,
	employee int NOT NULL,
	order_date date NOT NULL,
	ship_city varchar(100) NOT NULL,
	FOREIGN KEY (customer) REFERENCES customers(customer_id),
	FOREIGN KEY (employee) REFERENCES employees(employee_id)
);