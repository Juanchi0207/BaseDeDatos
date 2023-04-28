/*
delimiter //
drop function //
create function  () returns deterministic
begin
	
end //
delimiter ; 
*/

-- 1)

delimiter //
drop function punto1//
create function punto1(fechaInicio date, fechaFin date, estado varchar(45))
returns int deterministic
begin
	declare cantOrdenes int default 0;
	select count(*) into cantOrdenes from orders where orders.status=estado and orderDate>=fechaInicio and orderDate<=fechaFin;
    return cantOrdenes;
end //
delimiter ; 

select punto1("2003-01-01","2003-02-01","Shipped");

-- 2)

delimiter //
drop function punto2//
create function punto2(desde date, hasta date) returns int deterministic
begin
	declare cantEnviados int default 0;
    select count(*) into cantEnviados from orders where shippedDate>=desde and shippedDate<=hasta;
    return cantEnviados;
end //
delimiter ; 

select punto2("2003-01-01","2003-02-02");

-- 3) 

delimiter // 
drop function punto3//
create function punto3 (nroCliente int) returns varchar(50) deterministic
begin
	declare ciudad varchar(45);
    select offices.city into ciudad from offices join employees on offices.officeCode=employees.officeCode 
    join customers on salesRepEmployeeNumber=employeeNumber where nroCliente=customerNumber;
    return ciudad;
end//
delimiter ;

select punto3(103);

-- 4)

delimiter //
drop function punto4 //
create function punto4(lineaProducto varchar(50)) returns varchar(50) deterministic
begin
	declare cantidad varchar(50);
    select count(*) into cantidad from productlines where productLine=lineaProducto;
    return cantidad;
end //

select punto4("Classic Cars");

-- 5)

delimiter //
drop function punto5 //
create function punto5(codigoOficina int) returns int deterministic
begin 
	declare cantClientes int default 0;
    select count(customerNumber) into cantClientes from customers
    join employees on salesRepEmployeeNumber=employeeNumber where officeCode=codigoOficina;
    return cantClientes;
end //

select punto5(4);

-- 6)

delimiter //
drop function punto6//
create function punto6(codigoOficina int) returns int deterministic
begin
	declare cantOrdenesOficina int default 0;
    select count(orders.orderNumber) into cantOrdenesOficina from orders
    join customers on orders.customerNumber=customers.customerNumber 
    join employees on salesRepEmployeeNumber=employeeNumber where employees.officeCode=codigoOficina;
    return cantOrdenesOficina;
end //
delimiter ; 

select punto6(4);

-- 7)

delimiter //
drop function punto7//
create function punto7(codOrden int, codProd varchar(45)) returns decimal(10,2) deterministic
begin
	declare beneficio decimal(10,2) default 0.0;
    select (priceEach-buyPrice) into beneficio from orderdetails 
    join products on products.productCode=orderdetails.productCode 
    where orderdetails.productCode=codProd and orderNumber=codOrden;
    return beneficio;
end //
delimiter ; 

select punto7(10100,"S18_1749");

-- 8)

delimiter //
drop function punto8 //
create function punto8(numOrden int) returns int deterministic
begin
	declare respuesta int default 0;
	declare estado varchar(45);
    select orders.status into estado from orders where orderNumber=numOrden;
    if estado = "cancelled" then
		 set respuesta=-1;
	end if;    
    return respuesta;
end //

select punto8(10179);

-- 9) 

delimiter //
drop function punto9//
create function punto9(numCliente int) returns date deterministic
begin
	declare primeraOrden date;
    select min(orderDate) into primeraOrden from orders where orders.customerNumber=numCliente;
    return primeraOrden;
end //
delimiter ; 

select punto9(103);

-- 10)

delimiter //
drop function punto10//
create function punto10 (codProd varchar(15)) returns int deterministic
begin
	declare cantidad int;
    declare total int;
    declare porcentaje float;
 	select count(products.productCode) into cantidad from products 
    join orderdetails on orderdetails.productCode=products.productCode 
    where priceEach<MSRP and codProd=orderdetails.productCode;
    select count(*) into total from products where codProd=productCode;
    set porcentaje = (100*cantidad)/total;
    return porcentaje;
end //
delimiter ; 

select punto10("S18_1749");

-- 11)

delimiter //
drop function punto11//
create function punto11(numOrden int) returns int deterministic
begin
	declare cantDias int;
    select datediff(shippedDate, orderDate) into cantDias from orders where numOrden=orderNumber;
    return cantDias;
end //
delimiter ; 

select punto11(10100);

-- 12)

delimiter //
drop function punto12//
create function punto12(codProducto varchar(15)) returns date deterministic
begin
	declare fechaMax date;
    select max(orderDate) into fechaMax from orders join orderdetails on orderdetails.orderNumber=orders.orderNumber
    where codProducto=productCode;
    return fechaMax;
end //
delimiter ; 

select punto12("S18_1749");

-- 13)

delimiter //
drop function punto13//
create function punto13(fechaDesde date, fechaHasta date, codProducto varchar(45)) returns decimal(10, 2) deterministic
begin
	declare precio decimal default 0;
    select max(priceEach) into precio from orderdetails 
    join orders on orderdetails.orderNumber=orders.orderNumber
    where orders.orderDate>fechaDesde and orders.orderDate<fechaHasta and orderdetails.productCode=codProducto;
    return precio;
end //
delimiter ; 

select punto13("2003-01-01","2003-12-31","S2_1749");

-- 14)

delimiter //
drop function punto14//
create function punto14(numEmpleado int) returns int deterministic
begin
	declare cantClientes int default 0;
    select count(customerNumber) into cantClientes from customers where salesRepEmployeeNumber=numEmpleado;
    return cantClientes;
end //
delimiter ;

select punto14(1165);

-- 15)

delimiter //
drop function punto15//
create function punto15(numEmpleado int) returns varchar(45) deterministic
begin
	declare apellido varchar(45);
    select lastName into apellido from employees 
    where employeeNumber=(select reportsTo from employees where employeeNumber=numEmpleado);
    return apellido;
end //
delimiter ;

select punto15(1166);