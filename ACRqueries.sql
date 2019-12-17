use DB30;

/* 1)  Δείξε μία λίστα των πελατών με τον κωδικό τους, το επώνυμό τους, τη διεύθυνσή τους και το τηλέφωνό τους. */
select customer_id, last_name, address, phonenumber
from Customer;

/* 2) Δείξε για κάθε ενοικίαση τον κωδικό της και το χρονικό διάστημά της (από, έως) εάν η αξία είναι πάνω από 200€. */
select rental_id, start_date, end_date 
from Rental, Payment
where Rental.verification_number = Payment.verification_number and cost > 200;

/* 3) Για κάθε πελάτη, δείξε τον κωδικό του, το ονοματεπώνυμό του, το τηλέφωνό του και τους κωδικούς των ενοικιάσεων
	  που έχει κάνει */
select Customer.customer_id, first_name, last_name, phonenumber, rental_id
from Customer, Rental
where Customer.customer_id = Rental.customer_id;

/* 4) Δείξε το ονοματεπώνυμο και τηλέφωνο των πελατών που είχαν στην κατοχή τους αυτοκίνητο την 23/9/2010 και προέρχονται
	  από γεωγραφική περιοχή με κωδικό 10025. */
select first_name, last_name, phonenumber
from Customer, Rental
where Customer.customer_id = Rental.customer_id and '2010-09-23' >= start_date and '2010-09-23' <= end_date and reg_id = 10025;

/* 5) Μείωσε την αξία όλων των ενοικιάσεων κατά 5% */
update Payment
set cost = cost * 0.95;

/* 6) Δείξε για κάθε μήνα του 2010 το σύνολο και το μέσο όρο των πληρωμών που έχουν γίνει. */
select month(pdate) as month, sum(cost) as total, avg(cost) as average 
from Payment
where year(pdate) = '2010'
group by month(pdate);

/* 7) Δείξε τη συνολική αξία των ενοικιάσεων ανά κατηγορία αυτοκινήτου και γεωγραφικό διαμέρισμα. */
select cat_id as category, reg_id as region, sum(cost) as total
from Customer, Payment, Rental, Car
where Payment.verification_number = Rental.verification_number and Customer.customer_id = Rental.customer_id and Car.vin = Rental.vin
group by cat_id, reg_id;

/* 8) Δείξε τους κωδικούς των πελατών που έχουν για το μήνα Ιούνιο 2010 πάνω από 4 ενοικιάσεις και η μέση
      αξία ενοικίασης ήταν πάνω από 150€. */
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

/* 9) Χρησιμοποιώντας εμφωλευμένα υποερωτήματα, δείξτε τον κωδικό και το ονοματεπώνυμο των πελατών που έχουν
      κάνει συνολικές πληρωμές τον Απρίλιο του 2010 πάνω από 1500€. */
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

/* 10) Για κάθε κατηγορία αυτοκινήτων, δείξε τη συνολική αξία ενοικιάσεων της κατηγορίας σαν ποσοστό της συνολικής
	   αξίας όλων των ενοικιάσεων. */
go
create view SumCost(total) as 
select sum(cost)
from Payment

select Car.cat_id, sum(cost) / total as sales_percentage
from Payment, Rental, Car, SumCost
where Payment.verification_number = Rental.verification_number and Car.vin = Rental.vin 
group by cat_id, total;

/* 11) Για κάθε μήνα του 2010, σύγκρινς τις συνολικές πληρωμές του μήνα με αυτές του αντίστοιχου μήνα του 2010 (σαν ποσοστό). */
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

/* 12) Δείξε τους κωδικούς των γεωγραφικών διαμερισμάτων που είχαν μέση αξία ενοικίασης μεγαλύτερη
	   από τη συνολική μέση αξία ενοικίασης. */
select reg_id
from Payment, Rental, Customer
where Payment.verification_number = Rental.verification_number and Customer.customer_id = Rental.customer_id
group by reg_id
having avg(cost) > (select avg(cost)
					from Payment);

/* 13) Για κάθε μήνα, μέτρησε πόσοι πελάτες έχουν μέση αξία ενοικίασης μεγαλύτερη από τη συνολική
	   μέση αξία του μήνα. */
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

/* 14) Για κάθε μήνα του 2010, δείξε τη μέση χρονική διάρκεια ενοικίασης (σε ημέρες).
	   Θεωρείστε ότι μία ενοικίαση ανοίκει στο μήνα εκείνο στον οποίο αρχίζει.*/
select month(start_date) as month, avg(datediff(day, start_date, end_date)) as average
from Rental
group by month(start_date);


