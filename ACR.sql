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
vin char(17) Primary Key,
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
	start_date datetime not null default getdate(),
	end_date datetime,
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
	   ('Natalia', 'Karanasiou', 'Pezodromos Choras 63, Andros', 213143153, 10027),
	   ('Katerina', 'Nikolaou', 'Trion Ierarxon 19, Athina', 676767676, 10025)					

select *from Retail_Customer

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
	   (11, '1982-10-15'),
	   (14, '1982-10-15')

insert into Driver(first_name, last_name, dob, customer_id)
values ('Thanasis', 'Dimitriou', '1994-03-07', 5),
	   ('Marios', 'Anagnostou', '1992-02-01', 5),
	   ('Eleni', 'Ioannou', '1998-06-24', 10),
	   ('Chrysi', 'Galata', '1989-07-9', 8);




insert into Category(name,description) Values
('Micro Car','The smallest car'),
('Hatchback','For Families'),
('Cabrio','Cars witout roof'),
('Coupe','Sport Cars with rear roofline and two doors'),
('SUV','Sports Utility Vehide');

select * from Category;

insert into Car Values
('1234K67G90785T380', 'Toyota','Green','Toyota iQ', '2003-07-07',1),
('1234J67L00345I789', 'Smart' , 'Red', 'Smart ForTwo', '2010-01-13',1),
('2134P67S90356R789', 'Volkswagen', 'Blue', 'Volkswagen Golf', '2009-08-04',2),
('2134I67O09234H654', 'Ford', 'White', 'Ford Focus', '2005-05-21', 2),
('2134P57B98894F748', 'Audi', 'Black', 'Audi A3', '2010-03-27' ,2),
('3214K67P90345D690', 'Mazda', 'Red', 'Mazda MX-5', '2004-11-17' ,3),
('3214Y76P80456F780', 'BMW', 'Blue', 'BMW Z4', '2008-09-29' ,3),
('3215U89L90345G460', 'Mercedes-Benz', 'Black','Mercedes-Benz SLK', '2006-06-15',3),
('4099K35O38956K790', 'Opel', 'Yellow', 'Opel Astra GTC', '2007-12-14' ,4),
('4000L90I97568X456', 'Volkswagen', 'Brown', 'Volkswagen Scirocco', '2003-03-15' ,4),
('5875T67J78456D456', 'BMW', 'Gray', 'BMW X3', '2007-09-27' ,5),
('5875Y78U78900H890', 'Porsche', 'Black', 'Porsche Cayenne', '2003-08-17' ,5),
('5890U78Y89856P759', 'Land Rover','Black','Land Rover Range Rover', '2002-07-07',5);

Select * from Car;

insert into Location(man_fname,man_lname,postal_code,street_name,street_number,city) Values
('Maria', 'Papa', 50219, 'Fillipou', '28' ,'Pella'),
('Manos', 'Petrou', 10671, 'Akadimias', '145', 'Athina'),
('Athanasios' , 'Makris', 84500 ,'Pavlou Mela', '34' , 'Andros'),
('Anna', 'Sali', 10671, 'Skoufa', '28' ,'Athina');

select * from Location;

insert into PhoneNumber Values
(2384067345,1),
(2384067349,1),
(2107896306,2),
(2107898756,2),
(2107856423,2),
(2751000097,3),
(2107956734,4),
(2107967894,4);

select * from PhoneNumber;

insert into Payment(cost,pdate,credit_card_number,cr_card_exp_date)
 VALUES (1500,'06-27-2010',5678432,'07-26-2014'),
                (220,'06-06-2010',234567,'12-27-2019'),
                (100,'06-05-2010',6507850,'07-14-2012'),
                (30,'06-24-2010',87536898,'09-06-2011'),
                (500,'09-09-2010',3495098,'05-08-2013'),
                (300,'06-15-2010',8900238,'06-07-2014'),
                (700,'09-30-2010',903920,'06-08-2014'),
                (2500,'07-12-2010',9709453,'04-12-2022');


insert into Rental(customer_id,vin,start_date,end_date,verification_number,starts_loc,ends_loc)
            VALUES(1,'1234K67G90785T380','06-01-2010','06-11-2010',200105,2,2),
(4,'1234J67L00345I789','04-04-2010','04-14-2010',200106,2,2),
(1,'1234K67G90785T380','08-08-2010','08-10-2010',200107,1,3),
(3,'1234J67L00345I789','08-12-2010','08-13-2010',200108,2,2),
(4,'1234J67L00345I789','04-08-2010','04-19-2010',200109,3,3),
(8,'3214K67P90345D690', '05-09-2010','05-26-2010',200110,1,2),
(4,'2134I67O09234H654','11-04-2010','11-11-2010',200110,3,1),
(5,'2134P67S90356R789','10-10-2010','10-20-2010',200111,2,3),
(7,'3214Y76P80456F780','04-08-2010','04-30-2010',200112,1,2);

go
CREATE TRIGGER insertretail
on Retail_Customer 
after insert
as
declare @id_to_insert integer
set @id_to_insert = (select customer_id from inserted)
begin
if (@id_to_insert in (select customer_id from Corporate_Customer)) 
	rollback transaction;
end

go
CREATE TRIGGER insertcorporate
on Corporate_Customer 
after insert
as
declare @id_to_insert integer
set @id_to_insert = (select customer_id from inserted)
begin
if (@id_to_insert in (select customer_id from Retail_Customer)) 
	rollback transaction;
end


go

use DB30
select * from Location;

drop table Rental;
drop table PhoneNumber;
drop table Location;
drop table Payment;
drop table Car;
drop table Category;
drop table Driver;
drop table Retail_Customer;
drop table Corporate_Customer;
drop table Customer;
drop table Region;
