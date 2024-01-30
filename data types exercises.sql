-- java-DB-datatypes

-- 1. Enum data type usage
-- Create enum that will contain statuses 'NEW', "PAID", "WAITING FOR PAYMENT".
-- Create table "Invoices" with columns: buyer, seller, value, account number, status. Chose the right column types.
-- Insert a few rows into this table with different statuses.
-- Select only those invoices with status = "NEW"

drop table if exists invoices;
create type status_types as enum('NEW', 'PAID', 'WAITING FOR PAYMENT');
create table invoices(inv_id serial primary key, buyer varchar(60) not null, seller varchar(60) not NULL
					 , account_number varchar(20), status status_types);
					 
insert into invoices(buyer,seller, account_number, status)
     values('Annah','Peter','1253694','PAID'),('Alice','John','599822','WAITING FOR PAYMENT'),
	 	   ('Annah','Ali','1253694','NEW'),('Smith','John','599822','NEW'),
		   ('Anita','Bob','1253694','PAID'),('Sali','Elisa','599822','WAITING FOR PAYMENT');

select * from invoices where status = 'NEW';

-- 2. UUID data type usage
-- Modify table "Invoices" - add column that will keep "internal_id".
-- Update each row with a value in a column "internal_id". 
-- You can use this generator: https://www.uuidgenerator.net/

ALTER TABLE invoices add COLUMN internal_id uuid unique;

update invoices set internal_id = 'f523b68d-b0b1-4e1d-9d78-9ae60e5a82f0'
where inv_id = 6;

-- 3. JSON data type usage - 
-- Modify table "Invoices" - add 2 columns that will keep json view of an entity. One column should be 
-- with type json and other with type jsonb.
-- Try to fill newly created columns with below json:
-- '{ "buyer": "company a", "seller": "company b", "status": "NEW", "account_number": 123321123 "value": 23.43 }

ALTER TABLE invoices add COLUMN json_data json;
ALTER TABLE invoices add COLUMN jsonb_data jsonb;

update invoices set json_data = '{ "buyer": "Annah", "seller": "Peter", "status": "PAID", "account_number": 123321123}',
					jsonb_data = '{ "buyer": "Annah", "seller": "Peter", "status": "PAID", "account_number": 123321123 }'::jsonb
					where inv_id = 1;
					
-- 4. Array data type usage
-- Modify table "Invoices". Add a column where phone numbers of buyer will be kept. Maximum number of those number is 3.
-- Insert a list of phone numbers for an invoice with id = 3: 123211233, 125433221, 127643454
-- Insert a list of phone numbers for an invoice with id = 2: 432323112, 123344311
-- Select buyer name and his LAST phone number for invoice with id = 3;
-- Select an invoice which contains phone: 432323112

alter table invoices add column phone_numbers integer[3];

update invoices set phone_numbers = array[123211233, 125433221, 127643454] where inv_id = 3;
update invoices set phone_numbers = array[ 432323112, 123344311] where inv_id = 2;

select buyer, phone_numbers[3] from invoices where inv_id = 3;

select * from invoices where 432323112 = any(phone_numbers);

-- 5. Binary data type usage
-- Create a file, can be an image or just a text file
-- Create a new column in Invoices table that will keep this file
-- Insert this file into database for invoice with id = 1

alter table invoices add column file_data bytea;

update invoices set file_data = pg_read_binary_file('/home/dci-student/Sql_scripts/bytea.txt')::bytea
where inv_id = 1;

-- 6.  Date/time data types usage
-- Modify table "Invoices", add 4 new columns: payment deadline, transaction time, transaction hour, cyclic payment. Choose the right column types.
-- Update each column with values
-- Update timezone in transaction type, set it to be Melbourne, Australia.
-- Update timezone in transaction time column, set it to be Melbourne, Australia.
-- Select transaction time column, make sure that 10 hours has been added to the time that previously was set.

alter table invoices add column payment_deadline timestamptz;
alter table invoices add column transaction_time timetz;
alter table invoices add column transaction_hour timetz;
alter table invoices add column cyclic_payment interval;

update invoices set payment_deadline = timestamp '2024-02-29 23:59:59';
update invoices set transaction_time = timetz '11:00:00+10:00';
update invoices set transaction_hour = timetz '12:00:00+10:00';
update invoices set cyclic_payment = interval '3 Month';

select transaction_time from invoices;
