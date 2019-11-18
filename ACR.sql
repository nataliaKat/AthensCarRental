create table Region(
	reg_id integer identity(10024,1),
	name varchar(100) not null,
	population integer not null,
	average_revenue real not null,
	primary key(reg_id),
	constraint pos_pop check (population > 0),
	constraint pos_rev check (average_revenue > 0)
)

create table Customer(
	customer_id integer identity(1,1),
	first_name varchar(100) not null,
	last_name varchar(100) not null,
	address varchar(150) not null,
	phonenumber bigint not null,
	reg_id integer not null,
	primary key(customer_id),
	constraint fk_regid foreign key (reg_id) references Region(reg_id),
	constraint pos_phonenumber check (phonenumber > 0) 
)



create table Corporate_Customer(
	customer_id integer not null,
	AFM bigint not null,
	discount_percent real not null
	primary key (customer_id),
	constraint fk_custidcor foreign key (customer_id) references Customer(customer_id),
	constraint pos_afm check (AFM > 0),
	constraint pos_perc check (discount_percent >= 0)
)

create table Retail_Customer(
	customer_id integer not null,
	date_of_birth date not null,
	primary key (customer_id),
	constraint fk_custidret foreign key (customer_id) references Customer(customer_id)
)

create table Driver(
	first_name varchar(100) not null,
	last_name varchar(100) not null,
	dob date not null,
	customer_id integer not null
	primary key (first_name, last_name, customer_id)
	constraint fk_custiddri foreign key (customer_id) references Retail_Customer(customer_id)
)
create table Category(
	cat_id int IDENTITY(1,1) Primary Key,
	name varchar(255) not null,
	description varchar (255) not null
)

create table Car(
	vin varchar(7) Primary Key,
	manufacturer_company varchar(255) not null,
	color varchar(255) not null,
	model varchar(255) not null,
	purchase_date date not null,
	cat_id int NOT NULL 
	constraint fkcat_id foreign key (cat_id) references Category(cat_id)
)

create table Payment(
	verification_number int IDENTITY(200104,1) Primary Key,
	cost float(24) not null,
	pdate date not null,
	credit_card_number int not null,
	cr_card_exp_date date not null,
	constraint pos_cost check (cost >= 0.0)
)

create table Location(
	loc_id integer identity(1,1),
	man_fname varchar(50) not null,
	man_lname varchar(60) not null,
	postal_code integer not null,
	street_name varchar(100) not null,
	street_number integer not null,
	city varchar(50) not null
	primary key(loc_id),
	constraint pos_code check (postal_code > 0),
	constraint pos_snumb check (street_number > 0)
)

create table PhoneNumber(
	phone bigint not null, 
	loc_id integer not null
	primary key(phone)
	constraint fkloc_id foreign key (loc_id) references Location(loc_id),
	constraint pos_phone check (phone > 0)
)

create table Rental(
	rental_id int IDENTITY(1,1) Primary Key,
	vin varchar(7) NOT NULL,
	start_date date not null default getdate(),
	end_date date,
	verification_number int NOT NULL,
	starts_loc integer not null,
	ends_loc integer 
	constraint fkvin foreign key (vin) references Car(vin),
	constraint fkverifn foreign key (verification_number) references Payment(verification_number),
	constraint startsloc foreign key (starts_loc) references Location(loc_id),
	constraint endsloc foreign key (ends_loc) references Location(loc_id),
	constraint startenddate check (start_date < end_date)
)


/*INSERTS*/
insert into Region(name, population, average_revenue)
values /*('Thrace', 101856, 6300),*/
	   ('Macedonia', 2487447, 8110),
	   /*('Epirus', 336856, 7150),
	   ('Thessaly', 732762, 8219),*/
	   ('Sterea Ellada', 5039516, 9750),
	   ('Peloponnese', 1086935, 8610),
	   /*('Ionian Islands', 207855, 7654),*/
	   ('Aegean Islands', 503697, 7144)
	   /*('Crete', 533506, 8153)*/

insert into Customer(first_name, last_name, address, phonenumber, reg_id) 
values ('Maria', 'Papadopoulou', 'Thiseos 147, Athina', 6911111111, 10025),
	   ('Giorgos', 'Eleftheriou', 'Patision 12, Athina', 6999999999, 10025),
	   ('Dimitris', 'Papaspyrou', 'Sofokleous 26, Livadeia', 21111111111, 10025),
	   ('Margarita', 'Eftstathiou', 'Ethnikis Antistaseos 47, Mesologgi', 321313212, 10025),
	   ('Eleni', 'Apostolopoulos', 'Eleftheriou Venizelou 32, Tripoli', 2135433543, 10026),
	   ('Andreas', 'Pavlopoulos', 'Vasileos Georgiou 9, Kalamata', 2145646678, 10026),
	   ('Michalis', 'Kalliontzidis', 'Egnatias 112, Thessaloniki', 23104644357, 10024),
	   ('Marios', 'Athanasiadis', 'Makedonomachon 24, Florina', 6988888888, 10024),
	   ('Athina', 'Mosxou', 'Agias Sofias 19, Drama', 6989898989, 10024),
	   ('Nikos', 'Oikonomidis', 'Eparchiaki odos Katapolon 19, Amorgos', 21567325,10027),
	   ('Natalia', 'Karanasiou', 'Pezodromos Choras 63, Andros', 213143153, 10027)					

select *from Customer

insert into Corporate_Customer(customer_id, AFM, discount_percent)
values (1, 24254656576, 0.18),
	   (3, 34343434343, 0.2),
	   (7, 78787878787, 0.27),
	   (2, 67676767676, 0.16),
	   (9, 32132132112, 0.32)

insert into Retail_Customer(customer_id, date_of_birth)
values (4, '1974-12-01'),
	   (5, '1993-01-31'),
	   (6, '2000-03-21'),
	   (8, '1994-01-01'),
	   (10, '1984-05-29'),
	   (11, '1982-10-15')

insert into Driver(first_name, last_name, dob, customer_id)
values ('Thanasis', 'Dimitriou', '1994-03-07', 5),
	   ('Marios', 'Anagnostou', '1992-02-01', 5),
	   ('Eleni', 'Ioannou', '1998-06-24', 10),
	   ('Chrysi', 'Galata', '1989-07-9', 8)

insert into Category(name, description)
values ('')

use DB30
select * from Location

drop table Rental
drop table PhoneNumber
drop table Location
drop table Payment
drop table Car
drop table Category
drop table Driver
drop table Retail_Customer
drop table Corporate_Customer
drop table Customer
drop table Region
