"""Скрипт для заполнения данными таблиц в БД Postgres."""
import csv

import psycopg2

def reader_csv(file):
    '''функция для считывания данных из файла'''
    result = []
    with open(file, 'r', encoding="utf-8") as csv_file:
        reader: csv.DictReader = csv.DictReader(csv_file)
        for row in reader:
            result.append(row)
    return result

# считываем из файлов массивы с данными
read_csv_employess = reader_csv('../homework-1/north_data/employees_data.csv')
read_csv_customers = reader_csv('../homework-1/north_data/customers_data.csv')
read_csv_orders = reader_csv('../homework-1/north_data/orders_data.csv')

# подключаемся к базе данных north
conn = psycopg2.connect(host='localhost', database='north', user='postgres', password='1234')
try:
    with conn:
        with conn.cursor() as cur:
            for rowe in read_csv_employess:
                cur.execute("INSERT INTO employees VALUES (%s, %s, %s, %s, %s, %s)", (rowe['employee_id'], rowe['first_name'], rowe['last_name'], rowe['title'], rowe['birth_date'], rowe['notes']))

            for rowq in read_csv_customers:
                cur.execute("INSERT INTO customers VALUES (%s, %s, %s)", (rowq['customer_id'], rowq['company_name'], rowq['contact_name']))

            for rowo in read_csv_orders:
                cur.execute("INSERT INTO orders VALUES (%s, %s, %s, %s, %s)", (rowo['order_id'], rowo['customer_id'], rowo['employee_id'], rowo['order_date'], rowo['ship_city']))

finally:
    conn.close()