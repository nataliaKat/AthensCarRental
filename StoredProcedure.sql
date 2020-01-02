CREATE PROCEDURE customer_info
(@customer_id integer
)
AS
BEGIN

SET NOCOUNT ON;

IF 1 = (SELECT COUNT(customer_id) FROM Corporate_Customer WHERE customer_id = @customer_id)

SELECT Customer.customer_id, first_name, last_name, address, phonenumber, reg_id, AFM, discount_percent
FROM Customer, Corporate_Customer
WHERE Customer.customer_id=@customer_id AND
Customer.customer_id = Corporate_Customer.customer_id;

ELSE

SELECT Customer.customer_id, first_name, last_name, address, phonenumber, reg_id, DATEDIFF(year, date_of_birth, GETDATE()) as age
FROM Customer, Retail_Customer
WHERE Customer.customer_id=@customer_id AND
Customer.customer_id = Retail_Customer.customer_id;

END
