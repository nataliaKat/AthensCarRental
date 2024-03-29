use DB30;

/*
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
*/

create table Region(
	reg_id integer identity(10024,1) not null,
	name varchar(100) not null,
	population integer not null,
	average_revenue real not null,
	primary key(reg_id),
	constraint pos_pop check (population > 0),
	constraint pos_rev check (average_revenue > 0)
)

create table Customer(
	customer_id integer identity(1,1) not null,
	first_name varchar(100) not null,
	last_name varchar(100) not null,
	address varchar(150) not null,
	phonenumber bigint not null,
	reg_id integer not null,
	primary key(customer_id),
	constraint fk_regid foreign key (reg_id) references Region(reg_id) on delete cascade,
	constraint pos_phonenumber check (phonenumber > 0) 
)



create table Corporate_Customer(
	customer_id integer not null,
	AFM bigint not null,
	discount_percent real not null
	primary key (customer_id),
	constraint fk_custidcor foreign key (customer_id) references Customer(customer_id) on delete cascade,
	constraint pos_afm check (AFM > 0),
	constraint pos_perc check (discount_percent >= 0) 
)

create table Retail_Customer(
	customer_id integer not null,
	date_of_birth date not null,
	primary key (customer_id),
	constraint fk_custidret foreign key (customer_id) references Customer(customer_id) on delete cascade
)

create table Driver(
	first_name varchar(100) not null,
	last_name varchar(100) not null,
	dob date not null,
	customer_id integer not null
	primary key (first_name, last_name, customer_id)
	constraint fk_custiddri foreign key (customer_id) references Retail_Customer(customer_id) on delete cascade
)
create table Category(
	cat_id int IDENTITY(1,1) Primary Key not null,
	name varchar(255) not null,
	description varchar (255) not null
)

create table Car(
	vin char(17) Primary Key not null,
	manufacturer_company varchar(255) not null,
	color varchar(255) not null,
	model varchar(255) not null,
	purchase_date date not null,
	cat_id int NOT NULL
	constraint fkcat_id foreign key (cat_id) references Category(cat_id) on delete cascade
)

create table Payment(
	verification_number int IDENTITY(200104,1) Primary Key not null,
	cost float(24) not null,
	pdate date not null,
	credit_card_number int not null,
	cr_card_exp_date date not null,
	constraint pos_cost check (cost >= 0.0),
	constraint pdate_exp_date check (cr_card_exp_date > pdate)
)


create table Location(
	loc_id integer identity(1,1) not null,
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
	constraint fkloc_id foreign key (loc_id) references Location(loc_id) on delete cascade,
	constraint pos_phone check (phone > 0)
)

create table Rental(
	rental_id int IDENTITY(1,1) Primary Key not null,
	customer_id int not null,
	vin char(17) NOT NULL,
	start_date date not null default getdate(),
	end_date date,
	verification_number int unique NOT NULL,
	starts_loc integer not null,
	ends_loc integer 
	constraint custid foreign key (customer_id) references Customer(customer_id) on delete cascade,
	constraint fkvin foreign key (vin) references Car(vin) on delete cascade,
	constraint fkverifn foreign key (verification_number) references Payment(verification_number) on delete cascade,
	constraint startsloc foreign key (starts_loc) references Location(loc_id) on delete cascade,
	constraint endsloc foreign key (ends_loc) references Location(loc_id),
	constraint startenddate check (start_date <= end_date)
)

/*INSERTS*/
insert into Region(name, population, average_revenue)
values ('Macedonia', 2487447, 8110),
	   ('Sterea Ellada', 5039516, 9750),
	   ('Peloponnese', 1086935, 8610),
	   ('Aegean Islands', 503697, 7144)

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
	   (12, '1982-10-15')

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

insert into Car Values
('1234K67G90785T380', 'Toyota','Green','Toyota iQ', '2003-07-07',1),
('1234J67L00345I789', 'Smart' , 'Red', 'Smart ForTwo', '2010-01-01',1),
('2134P67S90356R789', 'Volkswagen', 'Blue', 'Volkswagen Golf', '2009-08-04',2),
('2134I67O09234H654', 'Ford', 'White', 'Ford Focus', '2005-05-21', 2),
('2134P57B98894F748', 'Audi', 'Black', 'Audi A3', '2010-01-01' ,2),
('3214K67P90345D690', 'Mazda', 'Red', 'Mazda MX-5', '2004-11-17' ,3),
('3214Y76P80456F780', 'BMW', 'Blue', 'BMW Z4', '2008-09-29' ,3),
('3215U89L90345G460', 'Mercedes-Benz', 'Black','Mercedes-Benz SLK', '2006-06-15',3),
('4099K35O38956K790', 'Opel', 'Yellow', 'Opel Astra GTC', '2007-12-14' ,4),
('4000L90I97568X456', 'Volkswagen', 'Brown', 'Volkswagen Scirocco', '2003-03-15' ,4),
('5875T67J78456D456', 'BMW', 'Gray', 'BMW X3', '2007-09-27' ,5),
('5875Y78U78900H890', 'Porsche', 'Black', 'Porsche Cayenne', '2003-08-17' ,5),
('5890U78Y89856P759', 'Land Rover','Black','Land Rover Range Rover', '2002-07-07',5);

insert into Location(man_fname,man_lname,postal_code,street_name,street_number,city) Values
('Maria', 'Papa', 50219, 'Fillipou', '28' ,'Pella'),
('Manos', 'Petrou', 10671, 'Akadimias', '145', 'Athina'),
('Athanasios' , 'Makris', 84500 ,'Pavlou Mela', '34' , 'Andros'),
('Anna', 'Sali', 10671, 'Skoufa', '28' ,'Athina');

insert into PhoneNumber Values
(2384067345,1),
(2384067349,1),
(2107896306,2),
(2107898756,2),
(2107856423,2),
(2751000097,3),
(2107956734,4),
(2107967894,4);

insert into Payment(cost,pdate,credit_card_number,cr_card_exp_date)
 VALUES (500, '2010-11-06', 958933, '2012-09-09'),
		(1500,'2010-10-06',5678432,'2014-07-26'),
		(220,'2010-04-14',234567,'2019-12-27'),
		(100,'2010-08-10',6507850,'2012-07-14'),
		(30,'2010-08-13',87536898,'2011-09-06'),
		(500,'2010-04-19',3495098,'2013-05-08'),
		(300, '2010-05-26',8900238,'2014-06-07'),
		(700,'2010-10-20',903920,'2014-06-08'),
		(2500, '2010-04-30',9709453,'2022-12-04'),
	        (170.8, '2010-09-09', 9667878, '2018-12-17'),
		(300,'2010-10-10',905368, '2016-10-10'),
		(350, '2010-07-09', 5374243, '2019-09-09'),
		(132, '2010-09-08', 43232, '2019-09-09'),
		(432, '2010-06-09', 54732, '2017-12-12'),
		(160, '2011-01-01', 3214, '2016-09-29'),
		(1600.50,'2010-01-30',809643, '2013-05-20'),
 		(600,'2010-01-14',406732, '2012-07-10'),
		(400,'2010-01-10', 890456, '2015-08-12'),
		(200,'2010-02-18', 985789, '2011-03-09'),
		(320,'2010-02-27', 789234, '2013-08-19'),
		(145, '2010-12-06', 234243, '2015-09-09'),
		(112, '2010-12-25', 132443, '2014-03-14'),
		 (1600.50,'2011-01-30',809456, '2013-05-20'),
         (600,'2011-01-14',906732, '2012-07-10'),
        (400,'2011-02-10', 345456, '2015-08-12'),
        (200,'2011-02-18', 956789, '2017-03-09'),
        (320,'2011-03-27', 789218, '2013-08-19'),
        (1600.50,'2011-03-30',809843, '2013-05-20'),
        (600,'2011-04-14',406790, '2012-07-10'),
        (400,'2011-04-10', 859356, '2015-08-12'),
        (200,'2011-05-18', 987889, '2015-03-09'),
        (320,'2011-05-27', 789345, '2013-08-19'),
        (145, '2011-06-06', 234278, '2015-09-09'),
        (112, '2011-06-25', 132447, '2014-03-14'),
		(224, '2011-07-23', 324243, '2018-09-09'),
		(54, '2011-07-12', 2434, '2015-12-12'),
		(322, '2011-08-06', 2543546, '2016-12-03'),
		(430,'2011-08-23', 2546435, '2017-10-23'),
		(370, '2011-09-26', 234453, '2017-11-09'),
		(530, '2011-09-27', 3564664, '2017-11-09'),
		(230, '2011-10-15', 324535, '2019-12-17'),
		(112, '2011-10-20', 234543, '2018-09-09'),
		(76.8, '2011-11-14', 326654, '2014-11-07'),
		(34.7, '2011-11-18', 254326, '2015-12-17'),
		(110.9, '2011-12-22', 567324, '2016-03-12'),
		(160, '2011-12-31', 2345432, '2017-04-04'),
		(140, '2005-04-19', 2342413, '2019-12-12'),
		(200, '2005-06-18', 2341425, '2018-12-12'),
		(312, '2006-04-12', 2341421, '2012-04-13'),
		(124, '2005-01-18', 3234124, '2010-01-01'),
		(54, '2005-10-28', 3244244, '2011-12-14');



insert into Rental(customer_id,vin,start_date,end_date,verification_number,starts_loc,ends_loc)
            VALUES (3,'5890U78Y89856P759', '2010-09-06','2010-11-06',200104,3,1),
				   (1,'1234K67G90785T380','2010-01-06','2010-10-06',200105,2,2),
				   (4,'1234J67L00345I789','2010-04-04','2010-04-14',200106,2,2),
				   (1,'1234K67G90785T380','2010-08-08','2010-08-10',200107,1,3),
				   (3,'1234J67L00345I789','2010-08-12','2010-08-13',200108,2,2),
				   (4,'1234J67L00345I789','2010-04-08','2010-04-19',200109,3,3),
				   (8,'3214K67P90345D690', '2010-05-09','2010-05-26',200110,1,2),
				   (5,'2134P67S90356R789','2010-10-10','2010-10-20',200111,2,3),
				   (7,'3214Y76P80456F780','2010-04-08','2010-04-30',200112,1,2),
				   (1,'1234J67L00345I789','2010-09-01','2010-09-09',200113,3,3),
				   (12,'1234J67L00345I789','2010-09-20','2010-10-10',200114,1,1 ),
				   (1,'1234J67L00345I789', '2010-05-03', '2010-07-09', 200115,2,2),
				   (1, '4099K35O38956K790', '2009-12-31', '2010-09-08', 200116, 1, 2),
				   (1, '3214K67P90345D690', '2010-03-03', '2010-06-09', 200117, 3, 4),
				   (1, '4000L90I97568X456', '2010-02-14', '2011-01-01', 200118, 1, 3),
				   (11,'5875Y78U78900H890','2010-01-01','2010-01-30',200119,1,1),
				   (7,'3214K67P90345D690','2010-01-10','2010-01-14',200120,2,3),
				   (6,'2134P67S90356R789','2010-01-03','2010-01-10',200121,2,2),
				   (3,'1234K67G90785T380','2010-02-03','2010-02-18',200122,2,1),
				   (2,'1234K67G90785T380','2010-02-19','2010-02-27',200123,2,1),
				   (5, '5875Y78U78900H890', '2010-01-01', '2010-12-06', 200124, 4,3),
				   (2, '5890U78Y89856P759', '2010-11-18', '2010-12-25', 200125, 2,1),
				   (9,'5875Y78U78900H890','2011-01-01','2011-01-30',200126,3,1),
                   (12,'3214K67P90345D690','2011-01-10','2011-01-14',200127,1,1),
                   (8,'2134P67S90356R789','2011-02-03','2011-02-10',200128,3,2),
                   (4,'1234K67G90785T380','2011-02-03','2011-02-18',200129,2,1),
                   (5,'1234K67G90785T380','2011-03-19','2011-03-27',200130,2,2),
                   (5,'5875Y78U78900H890','2011-03-01','2011-03-30',200131,1,1),
                   (7,'3214K67P90345D690','2011-04-10','2011-04-14',200132,2,4),
                   (6,'2134P67S90356R789','2011-04-03','2011-04-10',200133,2,2),
                   (3,'1234K67G90785T380','2011-05-03','2011-05-18',200134,2,1),
                    (2,'1234K67G90785T380','2011-05-19','2011-05-27',200135,2,1),
                   (5, '5875Y78U78900H890', '2011-06-01', '2011-06-06', 200136, 4,3),
                   (2, '5890U78Y89856P759', '2011-06-18', '2011-06-25', 200137, 2,1),
				   (11, '5890U78Y89856P759', '2010-08-04', '2011-07-23', 200138, 3, 4),
				   (12, '3215U89L90345G460', '2011-06-23', '2011-07-12', 200139, 2,1),
				   (6, '2134I67O09234H654', '2011-08-01', '2011-08-06', 200140, 2, 3),
				   (9, '1234J67L00345I789', '2011-01-09', '2011-08-23', 200141, 3, 4),
				   (10, '2134P67S90356R789', '2010-12-12', '2011-09-26', 200142, 1, 4),
				   (11, '4099K35O38956K790', '2011-08-12', '2011-09-27', 200143, 3, 2),
				   (4, '1234J67L00345I789', '2011-05-29', '2011-10-15', 200144, 1, 2),
				   (5, '3215U89L90345G460', '2011-10-01', '2011-10-20', 200145, 3, 4),
				   (9, '2134I67O09234H654', '2011-11-14', '2011-11-14', 200146, 2, 4),
				   (11, '3215U89L90345G460', '2011-10-17', '2011-11-18', 200147, 1, 3),
				   (11, '4099K35O38956K790', '2011-10-22', '2011-12-22', 200148, 4, 1),
				   (12, '3214K67P90345D690', '2011-08-17', '2011-12-31', 200149, 3, 1),
				   (4, '3215U89L90345G460', '2004-12-25', '2005-04-19', 200150, 4, 1),
				   (5, '5875Y78U78900H890', '2005-01-02', '2005-06-18', 200151, 3, 2),
				   (4, '1234K67G90785T380', '2005-09-27', '2006-04-12', 200152, 2, 3),
				   (5, '5875Y78U78900H890', '2004-12-18', '2005-01-18', 200153, 1, 4),
				   (4, '2134P67S90356R789', '2005-10-25', '2005-10-28', 200154, 4, 2);

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