

-- 1)
drop view punto1;
create view classicmodels.punto1 
as select orderNumber, products.productCode, productName, productDescription, buyPrice, buyPrice*quantityOrdered
from orderdetails join products on products.productCode=orderdetails.productCode order by orderNumber;

select * from punto1;

-- 2) 

drop view punto2;
create view classicmodels.punto2 
as select sum(priceEach*quantityOrdered) from orderdetails group by orderNumber;

select * from punto2;

-- 3)

drop view punto3;
create view classicmodels.punto3
as select productCode from products where buyPrice > (select avg(buyPrice) from products);

select * from punto3;

-- 4)

drop view punto4;
create view classicmodels.punto4 
as select productCode from products where buyPrice < (select avg(buyPrice) from products);

select * from punto4;

-- 5)

drop view punto5;
create view classicmodels.punto5 
as select offices.officeCode, city, employeeNumber, lastName, firstName 
from employees join offices on employees.officeCode = offices.officeCode 
order by offices.officeCode, employeeNumber;

select * from punto5;

-- 6)

drop view punto6;
create view classicmodels.punto6 
as select customers.customerNumber, customerName, contactLastName
from customers left join payments on customers.customerNumber=payments.customerNumber
where checkNumber is null;

select * from punto6;

-- 7)

drop view punto7;
create view classicmodels.punto7 
as select * from orders order by customerNumber;

select * from punto7;

-- 8)

drop view punto8;
create view classicmodels.punto8
as select customers.customerNumber, customerName, orders.orderNumber, orders.orderDate, orderdetails.productCode, orderdetails.quantityOrdered, products.productName from customers
join orders on orders.customerNumber=customers.customerNumber
join orderdetails on orders.orderNumber=orderdetails.orderNumber
join products on products.productCode=orderdetails.productCode; 

select * from punto8;

-- 9)

drop view punto9;
create view classicmodels.punto9 
as select count(productCode) from products join productlines on productlines.productLine=products.productLine group by productlines.productLine; 

select * from punto9;

-- 10)

drop view punto10;
create view classicmodels.punto10 
as select offices.officeCode, offices.city, employeeNumber, lastName, firstName, customerName, customerNumber 
from employees join offices on employees.officeCode = offices.officeCode 
join customers on employees.employeeNumber=customers.salesRepEmployeeNumber
order by offices.officeCode, employeeNumber;

select * from punto10;

-- 11)

drop view punto11;
create view classicmodels.punto11 
as select customerName, phone, addressLine1, sum(priceEach*quantityOrdered) from customers 
join orders on customers.customerNumber=orders.customerNumber
join orderdetails on orders.orderNumber=orderdetails.orderNumber
where orderDate<"2021-01-01" group by orders.orderNumber
having sum(priceEach*quantityOrdered)>30000;

select * from punto11;

-- 12)

drop view punto12;
create view classicmodels.punto12 
as select officeCode from employees group by officeCode 
having count(*) =(select max(cantidad) from (select count(employeeNumber) as cantidad 
from employees group by officeCode)as tabla);

select * from punto12;
-- 13)

drop view punto13;
create view classicmodels.punto13 
as select * from orders where shippedDate>requiredDate or shippedDate is null;

select * from punto13;

-- 14)

drop view punto14;
create view classicmodels.punto14 
as select offices.officeCode from offices left join employees on offices.officeCode = employees.officeCode where email is null;

select * from punto14;

-- 15)

drop view punto15;
create view classicmodels.punto15 
as select customerNumber, max(cantidad) from orders join orderdetails on orderdetails.orderNumber=orders.orderNumber;

select * from punto15; -- no anda profe ;(

-- 16)

drop view punto16;
create view classicmodels.punto16 
as select comments from orders where orders.status="cancelled";

select * from punto16;

-- 17)

drop view punto17;
create view classicmodels.punto17 
as select customerNumber as numero from orders where orders.status="cancelled" and requiredDate= 
(select max(requiredDate) from orders where orders.customerNumber=numero);

select * from punto17;







/*
drop view ;
create view classicmodels. 
as select

select * from ;
*/
