use b;
/*drop procedure ;
delimiter //
create procedure()
begin
	
end //
delimiter ;
call();*/


-- 1

drop procedure getCiudadesOffices;
delimiter //
create procedure getCiudadesOffices(out listaCiudades VARCHAR(4000))
begin
	declare terminar boolean DEFAULT 0;
    declare ciudadActual varchar(45) default "";
	declare nombreCursor CURSOR for SELECT city from offices;
    DECLARE CONTINUE HANDLER for not found SET terminar=1;
    set listaCiudades="";
    open nombreCursor;
    bucle:loop
		fetch nombreCursor into ciudadActual;
		if terminar=1 then
			leave bucle;
		end if;
        SET listaCiudades=concat(listaCiudades,", ",ciudadActual);
	end loop bucle;
    close nombreCursor;
end //
delimiter ;
call getCiudadesOffices(@listaCiudades);
select @listaCiudades; -- ta vacio :( actualizacion: ya no está más vacío :)



-- 2 

CREATE TABLE `CancelledOrders` (
	`orderNumber` int(11) NOT NULL,
    `orderDate` date NOT NULL,
    `customerNumber` int(11) NOT NULL,
    PRIMARY KEY (`orderNumber`)
);

drop procedure insertCancelledOrders;
delimiter //
create procedure insertCancelledOrders(out contadorCancelados int)
begin
    declare terminar boolean DEFAULT 0;
    declare orderNumber int;
    declare orderDate date;
    declare customerNumber int;
    declare nombreCursor CURSOR for SELECT orders.orderNumber, orders.orderDate, orders.customerNumber from orders where orders.status="cancelled";
	DECLARE CONTINUE HANDLER for not found SET terminar=1;
    set contadorCancelados=0;
    open nombreCursor;
    bucle:loop
		fetch nombreCursor into orderNumber, orderDate, customerNumber;
        if terminar=1 then
			leave bucle;
		end if;
        insert into CancelledOrders values (orderNumber, orderDate, customerNumber);
        set contadorCancelados=+1;
	end loop bucle;
    close nombreCursor;
    
end //
delimiter ;
call insertCancelledOrders(@contadorCancelados);
select @contadorCancelados;
select * from CancelledOrders;



-- 3 

drop procedure alterCommentOrder;
delimiter //
create procedure alterCommentOrder(in customerNumber1 int)
begin
    declare terminar boolean DEFAULT 0;
    declare sumaTotal float;
    declare comments text;
    declare numOrden int;
    declare nombreCursor CURSOR for SELECT comments, orderNumber from orders where comments is null and customerNumber=customerNumber1;
	DECLARE CONTINUE HANDLER for not found SET terminar=1;
	
    open nombreCursor;
    bucle:loop
		fetch nombreCursor into comments, numOrden;
        if terminar=1 then
			leave bucle;
		end if;
        select sum(quantityOrdered*priceEach) into sumaTotal from orderdetails
        join orders on orders.orderNumber = orderdetails.orderNumber where orders.orderNumber=numOrden;
        -- SET comments=concat("El total de la orden es ", sumaTotal);
		update orders set comments=concat("El total de la orden es ", sumaTotal) where orderNumber=numOrden;
	end loop bucle;
    close nombreCursor;
end //
delimiter ;
call alterCommentOrder(103); 
select comments from orderdetails join orders on orders.orderNumber = orderdetails.orderNumber where customerNumber=103;


-- 4

drop procedure ejercicioLibre;
delimiter //
create procedure ejercicioLibre(out ciudadYPais varchar(4000))
begin
	declare terminar boolean DEFAULT 0;
	declare ciudad varchar(45) default "";
    declare pais varchar(45) default "";
	declare nombreCursor CURSOR for SELECT city,country from customers;
	DECLARE CONTINUE HANDLER for not found SET terminar=1;
	set ciudadYPais="";
    open nombreCursor;
    bucle:loop
		fetch nombreCursor into ciudad, pais;
        if terminar=1 then
			leave bucle;
		end if;
		set ciudadYPais=concat(ciudadYPais, " | ", ciudad, "(",pais,")");
	end loop bucle;
	close nombreCursor;
end //
delimiter ;
call ejercicioLibre(@ciudadYPais);
select @ciudadYPais;
