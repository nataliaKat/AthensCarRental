use DB30

/* 1) Äåßîå ìßá ëßóôá ôùí ðåëáôþí ìå ôïí êùäéêü ôïõò, ôï åðþíõìü ôïõò, ôç äéåýèõíóÞ ôïõò êáé ôï ôçëÝöùíü ôïõò. */ 	
select customer_id, last_name, address, phonenumber
from Customer;

/* 2) Äåßîå ãéá êÜèå åíïéêßáóç ôïí êùäéêü ôçò êáé ôï ÷ñïíéêü äéÜóôçìÜ ôçò (áðü, Ýùò), åÜí ç áîßá åßíáé ðÜíù áðü 200 */
select rental_id, start_date, end_date 
from Rental, Payment
where Rental.verification_number = Payment.verification_number and cost > 200;

/* 3) Ãéá êÜèå ðåëÜôç, äåßîå ôïí êùäéêü ôïõ, ôï ïíïìáôåðþíõìü ôïõ, ôï ôçëÝöùíü ôïõ êáé ôïõò êùäéêïýò ôùí åíïéêéÜóåùí ðïõ Ý÷åé êÜíåé*/
select Customer.customer_id, first_name, last_name, phonenumber, rental_id
from Customer, Rental
where Customer.customer_id = Rental.customer_id;

/* 4) Äåßîå ôï ïíïìáôåðþíõìï êáé ôçëÝöùíï ôùí ðåëáôþí ðïõ åß÷áí óôçí êáôï÷Þ ôïõò áõôïêßíçôï ôçí 23/9/2010 êáé ðñïÝñ÷ïíôáé áðü ãåùãñáöéêÞ ðåñéï÷Þ ìå êùäéêü 10025 */
select first_name, last_name, phonenumber
from Customer, Rental
where Customer.customer_id = Rental.customer_id and '2010-09-23' >= start_date and '2010-09-23' <= end_date and reg_id = 10025;

/* 5) Ìåßùóå ôçí áîßá üëùí ôùí åíïéêéÜóåùí êáôÜ 5% */
update Payment
set cost = cost * 0.95;

/* 6) Äåßîå ãéá êÜèå ìÞíá ôïõ 2010 ôï óýíïëï êáé ôï ìÝóï üñï ôùí ðëçñùìþí ðïõ Ý÷ïõí ãßíåé */
select month(pdate) as month, sum(cost) as total, avg(cost) as average 
from Payment
where year(pdate) = '2010'
group by month(pdate);

/* 7) Äåßîå ôç óõíïëéêÞ áîßá ôùí åíïéêéÜóåùí áíÜ êáôçãïñßá áõôïêéíÞôïõ êáé ãåùãñáöéêü äéáìÝñéóìá */
select cat_id as category, reg_id as region, sum(cost) as total
from Customer, Payment, Rental, Car
where Payment.verification_number = Rental.verification_number and Customer.customer_id = Rental.customer_id and Car.vin = Rental.vin
group by cat_id, reg_id;

/* 8) Äåßîå ôïõò êùäéêïýò ôùí ðåëáôþí ðïõ Ý÷ïõí ãéá ôï ìÞíá Éïýíéï 2010 ðÜíù áðü 4 åíïéêéÜóåéò êáé ç ìÝóç áîßá åíïéêßáóçò Þôáí ðÜíù áðü 150.*/
go
create view June_rentals(customer_id, number_of_rentals, average_June) as 
select customer_id, count(customer_id), avg(cost) 
from Rental, Payment
where Rental.verification_number = Payment.verification_number and 
	  ((year(start_date) = '2010' and month(start_date) <= 6) or year(start_date) < 2010) and 
	  ((year(end_date) = '2010' and month(end_date) >=6) or  year(end_date) > 2010)
group by customer_id;	  

select customer_id
from June_rentals
where number_of_rentals > 4 and average_june > 150;

/* 9) ×ñçóéìïðïéþíôáò åìöùëåõìÝíá õðïåñùôÞìáôá, äåßîå ôïí êùäéêü êáé ôï ïíåìáôåðþíõìï ôùí ðåëáôþí ðïõ Ý÷ïõí êÜíåé óõíïëéêÝò ðëçñùìÝò ôïí Áðñßëéï ôïõ 2010 ðÜíù áðü 1500. */
select Customer.customer_id, first_name, last_name 
from (select customer_id, sum(cost) as total
	  from Rental, Payment
	  where Rental.verification_number = Payment.verification_number and month(pdate) = 4 and year(pdate) = 2010
	  group by customer_id) as April_payments, Customer
where Customer.customer_id = April_payments.customer_id;

Select customer_id, first_name, last_name
from Customer
Where 150 < (Select Sum(cost)
             From Payment,Rental
             Where year(pdate) = 2010 AND month(pdate) = 4 AND Rental.verification_number = Payment.verification_number AND Customer.customer_id = Rental.customer_id
             Group By customer_id);

/* 10) Ãéá êÜèå êáôçãïñßá áõôïêéíÞôùí, äåßîå ôç óõíïëéêÞ áîßá åíïéêéÜóåùí ôçò êáôçãïñßáò óáí ðïóïóôü ôçò óõíïëéêÞò áîßáò üëùí ôùí åíïéêéÜóåùí. */
go
create view SumCost(total) as 
select sum(cost)
from Payment

select Car.cat_id, sum(cost) / total as sales_percentage
from Payment, Rental, Car, SumCost
where Payment.verification_number = Rental.verification_number and Car.vin = Rental.vin 
group by cat_id, total;

/* 11) Ãéá êÜèå ìÞíá ôïõ 2011, óýãêñéíå ôéò óõíïëéêÝò ðëçñùìÝò ôïõ ìÞíá ìå áõôÝò ôïõ áíôßóôïé÷ïõ ìÞíá ôïõ 2010 (óáí ðïóïóôü) */
go
create view Payments10(month, total) as
select month(pdate), sum(cost)
from Payment
where year(pdate) = '2010'
group by month(pdate);

go 
create view Payments11(month, total) as 
select month(pdate), sum(cost)
from Payment
where year(pdate) = '2011'
group by month(pdate);
insert into payment(cost, pdate, credit_card_number, cr_card_exp_date)
values /*(200, '2011-01-04', 23423, '2017-01-01'),*/
	   (400, '2011-06-09', 3453, '2017-06-08');

select Payments11.month, ((Payments11.total - Payments10.total) / Payments10.total) as percentage_difference
from Payments11
left outer join Payments10 on Payments10.month = Payments11.month;

/* 12) Äåßîå ôïõò êùäéêïýò ôùí ãåùãñáöéêþí äéáìåñéóìÜôùí ðïõ åß÷áí ìÝóç áîßá åíïéêßáóçò ìåãáëýôåñç áðü ôç óõíïëéêÞ ìÝóç áîßá åíïéêßáóçò */
select reg_id
from Payment, Rental, Customer
where Payment.verification_number = Rental.verification_number and Customer.customer_id = Rental.customer_id
group by reg_id
having avg(cost) > (select avg(cost)
					from Payment);

/* 13) Ãéá êÜèå ìÞíá ìÝôñçóå ðüóïé ðåëÜôåò Ý÷ïõí ìÝóç áîßá åíïéêßáóçò ìåãáëýôåñç áðü ôç óõíïëéêÞ ìÝóç áîßá ôïõ ìÞíá */
go 
create view Avg_Month(month, average) as
select month(pdate), avg(cost)
from Rental, Payment
group by month(pdate);

go 
create view AvgCustMonth(customer_id, month, average) as
select customer_id, month(pdate), avg(cost)
from Rental, Payment
where Rental.verification_number = Payment.verification_number
group by customer_id, month(pdate);

select count(customer_id), Avg_Month.month
from AvgCustMonth, Avg_Month
where Avg_Month.month = AvgCustMonth.month and AvgCustMonth.average > Avg_Month.average
group by Avg_Month.month;

/* 14) Ãéá êÜèå ìÞíá ôïõ 2010, äåßîå ôç ìÝóç ÷ñïíéêÞ äéÜñêåéá åíïéêßáóçò (óå çìÝñåò). Èåùñåßóôå üôé ìßá åíïéêßáóç áíÞêåé óôï ìÞíá åêåßíï óôïí ïðïßï áñ÷ßæåé. */
go
create view Dur(month, duration) as
select month(start_date), datediff(day, start_date, end_date)
from Rental
where year(start_date) = 2010;

select month, avg(duration) as average
from Dur
group by month;

