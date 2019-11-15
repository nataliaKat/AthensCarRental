create table Region(
	reg_id integer identity(1,1),
	name varchar(100),
	population integer,
	average_revenue real,
	primary key(reg_id)
);

create table Customer(
	customer_id integer identity(1,1),
	first_name varchar(100),
	last_name varchar(100),
	address varchar(150),
	phonenumber integer,
	reg_id integer not null,
	primary key(customer_id),
	constraint fk_regid foreign key (reg_id) references Region(reg_id) 
);

create table Corporate_Customer(
	customer_id integer not null,
	AFM integer,
	primary key (customer_id),
	constraint fk_custidcor foreign key (customer_id) references Customer(customer_id)
);

create table Retail_Customer(
	customer_id integer not null,
	date_of_birth date,
	constraint fk_custidret foreign key (customer_id) references Customer(customer_id)
);

create table Driver(
	first_name varchar(100),
	last_name varchar(100),
	customer_id integer not null,
	dob date,
	primary key (first_name, last_name, customer_id)
	constraint fk_custiddri foreign key (customer_id) references Customer(customer_id)
);

create table Category(
cat_id int IDENTITY(1,1) Primary Key,
name varchar(255),
description varchar (255)
);

create table Car(
vin varchar(7) Primary Key,
manufacturer_company varchar(255),
color varchar(255),
model varchar(255),
purchase_date date,
cat_id int NOT NULL FOREIGN KEY REFERENCES Category(cat_id)
);

create table Payment(
verification_number int IDENTITY(1,1) Primary Key,
cost float(24),
date date,
credit_card_number int,
cr_card_exp_date date
);

create table Rental(
rental_id int IDENTITY(1,1) Primary Key,
vin varchar(7) FOREIGN KEY REFERENCES Car(vin) NOT NULL,
start_date date,
end_date date,
verification_number int NOT NULL FOREIGN KEY REFERENCES Payment(verification_number)
);

drop table Rental;
drop table Payment;
drop table Car;
drop table Category;
drop table Driver;
drop table Retail_Customer;
drop table Corporate_Customer;
drop table Customer;
drop table Region;

