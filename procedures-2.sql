/*drop procedure ;
delimiter //
create procedure()
begin
	
end //
delimiter ;
call();*/

-- 1)

drop procedure pedidosFinalizados;
delimiter //
create procedure pedidosFinalizados(in anio int)
begin
	select idPedido, fecha, cliente_codCliente from pedido where year(fecha)=anio;
end //
delimiter ;
call pedidosFinalizados(2040);

-- 2)

drop procedure eliminarPedidos;
delimiter //
create procedure eliminarPedidos(in idPed int, out cantItemEliminados int)
begin
	set cantItemEliminados = (select count(item) from pedido_producto where Pedido_idPedido=idPed);
	delete from pedido_producto where Pedido_idPedido=idPed;
    delete from pedido where idPedido=idPed;
end //
delimiter ;
call eliminarPedidos(5, @cantItemEliminados);
select @cantItemEliminados;

-- 3)

drop procedure pedidosAnio;
delimiter //
create procedure pedidosAnio(in anio int, in mes int, in cod int)
begin
	select * from pedido where pedido.Cliente_codCliente=cod and month(pedido.fecha)=mes and year(pedido.fecha)=anio;
end //
delimiter ;
call pedidosAnio(2030,5,10);

-- 4)

drop procedure insertarDatos;
end //
delimiter ;
call insertarDatos(2,"si",10,4,5,@retorno);
select @retorno;

-- 5) 

drop procedure eliminarPedido;
delimiter //
create procedure eliminarPedido(in idPed int, out retorno bool)
begin
	set retorno=0;
    if (select estado.nombre from estado join pedido on Estado_idEstado=estado.idEstado where idPedido=idPed and estado.nombre!="Pendiente")!="Pendiente" then
	delete from pedido_producto where Pedido_idPedido=idPed;
    delete from pedido where idPedido=idPed;
    set retorno=1;
    end if;
end //
delimiter ;
call eliminarPedido(4,@retorno);
select @retorno;

-- 6)

drop procedure variacionDescuento;
delimiter //
create procedure variacionDescuento(in cod int, in nombreDescuento varchar(45))
begin
	if nombreDescuento="Descuento Amigo" then
		update cliente set porcDescuento=20.0 where codCliente=cod;
	elseif nombreDescuento="Descuento Familiar" then 
		update cliente set porcDescuento=50.0 where codCliente=cod;
	elseif nombreDescuento="Descuento de Compromiso" then
		update cliente set porcDescuento=5.0 where codCliente=cod;
	end if;
end //
delimiter ;
call variacionDescuento(3,"Descuento Familiar");

	if not exists (select codProducto from producto where codProducto=cod) then
		insert into producto values (cod,descrip,prec,cat,stoc);
        set retorno=1;
	end if;
end //
delimiter ;
call insertarDatos(2,"si",10,4,5,@retorno);
select @retorno;

-- 5) 

drop procedure eliminarPedido;
delimiter //
create procedure eliminarPedido(in idPed int, out retorno bool)
begin
	set retorno=0;
    if (select estado.nombre from estado join pedido on Estado_idEstado=estado.idEstado where idPedido=idPed and estado.nombre!="Pendiente")!="Pendiente" then
	delete from pedido_producto where Pedido_idPedido=idPed;
    delete from pedido where idPedido=idPed;
    set retorno=1;
    end if;
end //
delimiter ;
call eliminarPedido(4,@retorno);
select @retorno;

-- 6)

drop procedure variacionDescuento;
delimiter //
create procedure variacionDescuento(in cod int, in nombreDescuento varchar(45))
begin
	if nombreDescuento="Descuento Amigo" then
		update cliente set porcDescuento=20.0 where codCliente=cod;
	elseif nombreDescuento="Descuento Familiar" then 
		update cliente set porcDescuento=50.0 where codCliente=cod;
	elseif nombreDescuento="Descuento de Compromiso" then
		update cliente set porcDescuento=5.0 where codCliente=cod;
	end if;
end //
delimiter ;
call variacionDescuento(3,"Descuento Familiar");

delimiter //
create procedure insertarDatos(in cod int, in descrip varchar(45), in prec decimal, in cat int, in stoc int, out retorno bool)
begin
	set retorno=0;
	if not exists (select codProducto from producto where codProducto=cod) then
		insert into producto values (cod,descrip,prec,cat,stoc);
        set retorno=1;
	end if;
end //
delimiter ;
call insertarDatos(2,"si",10,4,5,@retorno);
select @retorno;

-- 5) 

drop procedure eliminarPedido;
delimiter //
create procedure eliminarPedido(in idPed int, out retorno bool)
begin
	set retorno=0;
    if (select estado.nombre from estado join pedido on Estado_idEstado=estado.idEstado where idPedido=idPed and estado.nombre!="Pendiente")!="Pendiente" then
	delete from pedido_producto where Pedido_idPedido=idPed;
    delete from pedido where idPedido=idPed;
    set retorno=1;
    end if;
end //
delimiter ;
call eliminarPedido(4,@retorno);
select @retorno;

-- 6)

drop procedure variacionDescuento;
delimiter //
create procedure variacionDescuento(in cod int, in nombreDescuento varchar(45))
begin
	if nombreDescuento="Descuento Amigo" then
		update cliente set porcDescuento=20.0 where codCliente=cod;
	elseif nombreDescuento="Descuento Familiar" then 
		update cliente set porcDescuento=50.0 where codCliente=cod;
	elseif nombreDescuento="Descuento de Compromiso" then
		update cliente set porcDescuento=5.0 where codCliente=cod;
	end if;
end //
delimiter ;
call variacionDescuento(3,"Descuento Familiar");

