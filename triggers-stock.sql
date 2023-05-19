-- 1)

delimiter // 
create trigger trigger1 after insert on pedido_producto
for each row
begin
	update ingresostock_producto set cantidad=cantidad-new.cantidad where new.Producto_codProducto=codProducto;
end //
delimiter ;

-- 2)

delimiter //
create trigger trigger2 before delete on ingresostock
for each row 
begin
	delete from ingresostock_producto where old.idIngreso=IngresoStock_idIngreso;
end //
delimiter ;

-- 3)

drop procedure ej3;
delimiter //
create procedure ej3(in cod int)
begin
	declare total decimal default 0;
	select sum(precioUnitario*cantidad) into total from pedidoProducto 
    join pedido on Pedido_idPedido=idPedido where Cliente.codCliente=cod 
    and (year(now())-year(fecha))<=2;
    if total<=50000 then
		update cliente set categoria="Bronce" where codcliente=cod;
    else if total>50000 and total<=100000 then
		update cliente set categoria="Plata" where codcliente=cod;
    else if total>100000 then
		update cliente set categoria="Oro" where codcliente=cod;
    end if;
    end if;
    end if;
end //
delimiter ;
call ej3(3);

select codCliente from cliente;
delimiter // 
create trigger trigger3 after insert on pedido
for each row 
begin
	call ej3(old.codCliente);
end //
delimiter ;

-- 4)

delimiter //
create trigger trigger4 after insert on ingresostock_producto
for each row
begin 
	update producto set stock = stock + new.cantidad where codProducto=new.Producto_codProducto;
end // 
delimiter ;

-- 5)

-- Al querer borrar un pedido no me dejaría debido al no action 
-- y la relacion de las claves foraneas utilizadas en otras tablas

-- una opcion podría ser borrar todas las tablas hijas que hagan uso de esa foreign key
-- la otra seria cambiar el tipo de restriccion del delete a cascade por ejemplo (igualmente vamos a hacer solo la de arriba)

delimiter //
create trigger trigger5 before delete on pedido
for each row
begin 
	delete from pedido_producto where old.idPedido=Pedido_idPedido;
end //
delimiter ;