use DB30;

declare @vin varchar(50), @manufacturerCompany varchar(50), @color varchar(50), @model varchar(100), @purchaseDate date, @categoryId int;
declare cars cursor for
select * from Car;
open cars;
fetch next from cars into @vin, @manufacturerCompany, @color, @model, @purchaseDate, @categoryId;
while @@FETCH_STATUS = 0
begin
	print 'Car: ' + @vin + ', Manufactured By: ' + @manufacturerCompany + ', Color: ' + @color + ', Model: ' + @model + ', Purchase Date ' + convert(varchar(50), @purchaseDate, 103) + ', Category Id: ' + convert(varchar(10), @categoryId);
	fetch next from cars into @vin, @manufacturerCompany, @color, @model, @purchaseDate, @categoryId;
end;
close cars;
deallocate cars;