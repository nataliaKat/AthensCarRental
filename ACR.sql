create table Region(
	reg_id integer identity(1,1),
	name varchar(100),
	population integer,
	average_revenue real,
	primary key(reg_id)
)

create table Customer(
	customer_id integer identity(1,1),
	first_name varchar(100),
	last_name varchar(100),
	address varchar(150),
	phonenumber integer,
	reg_id integer not null,
	primary key(customer_id),
	constraint fk_regid foreign key (reg_id) references Region(reg_id) 
)

create table Corporate_Customer(
	customer_id integer not null,
	AFM integer
	primary key (customer_id),
	constraint fk_custidcor foreign key (customer_id) references Customer(customer_id)
)

create table Retail_Customer(
	customer_id integer not null,
	date_of_birth date,
	constraint fk_custidret foreign key (customer_id) references Customer(customer_id)
)

create table Driver(
	first_name varchar(100),
	last_name varchar(100),
	customer_id integer not null
	primary key (first_name, last_name, customer_id)
	constraint fk_custiddri foreign key (customer_id) references Customer(customer_id)
)

drop table Driver
drop table Retail_Customer
drop table Corporate_Customer
drop table Customer
drop table Region
