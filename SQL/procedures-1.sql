-- 1)
delimiter //
create procedure listarProductos(out cantidad int)
begin
	select productName from products where buyPrice <(select avg(buyPrice) from products);
	select count(*) into cantidad from products where buyPrice <(select avg(buyPrice) from products);
end//
delimiter ;
drop procedure listarProductos;
call listarProductos(@cantidad);
select @cantidad;

-- 2)
delimiter //
create procedure borrarorden(in numerorden int, out cant int)
begin
	select count(*) into cant from orderdetails where orderNumber = numerorden;
	delete from orderdetails where orderNumber = numerorden;
	delete from orders where orderNumber = numerorden;
end//
delimiter ; 
set @orden=07;
call borrarorden(@orden, @cantidad);
select @cantidad;


-- 3)
drop procedure borrarLinea;
delimiter // 
create procedure borrarLinea(out mensaje varchar(45), in numeroLinea int)
begin
declare coincidencia int;
	select count(*) into coincidencia from products where numeroLinea=productLine;
	if coincidencia=0 then
		delete from productlines where numeroLinea=productLine;
		set mensaje = "La línea de productos fue borrada";
    else
		set mensaje ="La línea de productos no pudo borrarse porque contiene productos asociados." ;
	end if;
end//
delimiter ;
select @mensaje;
drop procedure borrarLinea;
call borrarLinea(@mensaje, @numeroLinea);    
	
-- 4)

drop procedure listarOrdenes;
delimiter //
create procedure listarOrdenes()
begin
	select count(orderNumber), state from orders join customers on customers.customerNumber=orders.customerNumber group by state;
end //
delimiter ;
call listarOrdenes();

-- 5)

drop procedure listarOrdenes2;
delimiter //
create procedure listarOrdenes2(in desde date, in hasta date)
begin
	select count(orderNumber), state from orders 
    join customers on customers.customerNumber=orders.customerNumber 
    where orderDate>=desde and orderDate<=hasta group by state;
end //
delimiter ;
call listarOrdenes2(@desde, @hasta);

-- 6)

drop procedure listarEmpleados;
delimiter //
create procedure listarEmpleados()
begin
	select count(reportsTo) as subordinados, reportsTo 
    from employees group by reportsTo;
end //
delimiter ;
call listarEmpleados();

-- 7)

drop procedure precioTotal;
delimiter //
create procedure precioTotal()
begin
	select sum(quantityOrdered*priceEach) as total, orderNumber from orderdetails group by orderNumber;
end //
delimiter ;
call precioTotal();

-- 8)

drop procedure numeroCliente;
delimiter //
create procedure numeroCliente()
begin
	select customers.customerNumber, customerName,orders.orderNumber,sum(quantityOrdered*priceEach) as total 
    from customers join orders on customers.customerNumber=orders.customerNumber 
    join orderdetails on orderdetails.orderNumber=orders.orderNumber group by orders.orderNumber;
end //
delimiter ;
call numeroCliente();

-- 9)

drop procedure modificarComments;
delimiter //
create procedure modificarComments(in numeroOrden int, in comentario text, out retorno bool)
begin
	set retorno=0;
		if exists (select * from orders where numeroOrden=orderNumber) then
			update orders set comments = comentario where orderNumber = numeroOrden;
			set retorno=1;
    end if;
end //
delimiter ;
call modificarComments(10100,"hola",@retorno);
select @retorno;