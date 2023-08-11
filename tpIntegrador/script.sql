drop database tpIntegrador;
create database tpIntegrador;

/* drop procedure ;
delimiter //
create procedure ()
begin

end//
delimiter ;
*/

/*
drop function ;
delimiter //
create function () returns not deterministic 
begin 
	
end //
delimiter ;
*/

/*
drop trigger ;
delimiter //
create trigger after/before insert/update/delete 
on tabla for each row
begin 

end //
delimiter ;
*/

INSERT INTO categorias (categoria) VALUES
('Electrónica'),
('Ropa y Accesorios'),
('Hogar'),
('Deportes'),
('Libros');

select * from categorias;

INSERT INTO usuario (dni, nombre, apellido, nivel, reputacion) VALUES
(12345678, 'Juan', 'Pérez', 'NORMAL', 80),
(87654321, 'María', 'Gómez', 'GOLD', 95),
(54321678, 'Pedro', 'Martínez', 'PLATINUM', 99),
(98765432, 'Laura', 'López', 'NORMAL', 75),
(34567812, 'Carlos', 'Rodríguez', 'GOLD', 92);

INSERT INTO producto (idproducto, nombre, descripcion) VALUES
(1, 'Smartphone', 'Teléfono inteligente.'),
(2, 'Camiseta', 'Camiseta de algodón en color blanco.'),
(3, 'Mesa de Centro', 'Mesa de centro de madera con acabado rústico.'),
(4, 'Pelota de Fútbol', 'Pelota de fútbol de tamaño estándar.'),
(5, 'El Principito', 'Libro clásico de Antoine de Saint-Exupéry.');
use tpIntegrador;
INSERT INTO publicacion (idpublicacion, precio, tipo, categorias_categoria, fechaFin, usuario_dni, producto_idproducto, estado) VALUES
(1, '15000', 'Venta directa', 'Electrónica', NULL, 12345678, 1, 'Activa'),
(2, '500', 'Subasta', 'Ropa y Accesorios', '2023-08-31', 87654321, 2, 'Activa'),
(3, '3500', 'Venta directa', 'Hogar', NULL, 54321678, 3, 'Activa'),
(4, '200', 'Subasta', 'Deportes', '2023-08-15', 98765432, 4, 'Activa'),
(5, '800', 'Venta directa', 'Libros', NULL, 34567812, 5, 'Activa');

INSERT INTO qYa (idqYa, publicacion_idpublicacion, pregunta, respuesta) VALUES
(1, 1, '¿Es el teléfono compatible con 4G?', 'Sí, es compatible con 4G.'),
(2, 2, '¿Cuál es la talla de la camiseta?', 'Es talla M.'),
(3, 3, '¿El producto viene armado?', 'Sí, viene armada.'),
(4, 4, '¿La pelota es para césped o para fútbol sala?', 'Es para césped.'),
(5, 5, '¿Este libro es la edición original?', 'Sí, es la edición original.');

INSERT INTO oferta (idoferta, publicacion_idpublicacion, usuario_dni, monto) VALUES
(1, 2, 12345678, 600),
(2, 2, 54321678, 550),
(3, 4, 12345678, 250),
(4, 4, 98765432, 300),
(5, 5, 87654321, 700);

INSERT INTO compra (idcompra, publicacion_idpublicacion, usuario_dni, metodoEnvio_tipoMetodoEnvio, metodoPago_tipoMetodoPago, fecha, califVendedor, califComprador) VALUES
(1, 1, 87654321, 'OCA', 'Tarjeta de Crédito', '2023-08-01', 90, 95),
(2, 3, 98765432, 'Correo Argentino', 'Pago Fácil', '2023-07-30', 80, 85),
(3, 2, 12345678, 'OCA', 'Tarjeta de Débito', '2023-07-29', 95, 90),
(4, 4, 54321678, 'OCA', 'Rapipago', '2023-08-02', 85, 80),
(5, 5, 34567812, 'Correo Argentino', 'Tarjeta de Crédito', '2023-08-03', 92, 88);

INSERT INTO metodoPago (tipoMetodoPago) VALUES
('Tarjeta de Crédito'),
('Tarjeta de Débito'),
('Pago Fácil'),
('Rapipago');

INSERT INTO metodoEnvio (tipoMetodoEnvio) VALUES
('OCA'),
('Correo Argentino');

-- Ejercicio 1 - Stored Procedures

drop procedure buscarPublicacion;
delimiter //
create procedure buscarPublicacion (in nombreProd varchar(45))
begin
	select idpublicacion, producto.nombre, categorias_categoria, precio from publicacion 
    join producto on idproducto=producto_idproducto where producto.nombre=nombreProd;
end//
delimiter ;

call buscarPublicacion ('Smartphone');

-- Ejercicio 2 - Stored Procedures

drop procedure crearPublicacion;
delimiter //
create procedure crearPublicacion (in publicacionId int, in publicacionPrecio decimal, in tipoPublicacion varchar(45), in categoriaPublicacion varchar(45), in fechaFinPublicacion date, in usuarioDNIPublicacion int, in productoIdPublicacion int, in estadoPublicacion varchar(45))
begin
	insert into publicacion values (publicacionId, publicacionPrecio, tipoPublicacion, categoriaPublicacion, fechaFinPublicacion, usuarioDNIPublicacion, productoIdPublicacion, estadoPublicacion);
end//
delimiter ;

-- Ejercicio 3 - Stored Procedures

drop procedure verPreguntas;
delimiter //
create procedure verPreguntas (in codPublicacion Int)
begin	
    select pregunta from qYa where codPublicacion = publicacion_idpublicacion;
end//
delimiter ;

call verPreguntas(1);
SET GLOBAL log_bin_trust_function_creators = 1;

-- Ejercicio 1 - Stored Functions

drop function comprarProducto;
delimiter //
create function comprarProducto (usuarioComprador INT, codPublicacion INT, metodoPago Varchar(45), tipoEnvio Varchar(45))
returns Varchar(45) deterministic 
begin 
	
    declare mensaje Varchar(45) default "no está activo";
	declare estadoActual Varchar(45) default "";
    declare tipoVenta varchar(45) default "";
    declare vendedor int default 0;
    
    select usuario_dni into vendedor from publicacion where idpublicacion=codPublicacion;
    select estado into estadoActual from publicacion where idpublicacion = codPublicacion;
	if estadoActual = "Activa" then
		select tipo into tipoVenta from publicacion where idpublicacion = codPublicacion;
        if tipoVenta = "Venta directa" then
			insert into compra values (null, codPublicacion, usuarioComprador, tipoEnvio, metodoPago, now(), null, null);
			call cerrarPublicacion(codPublicacion, vendedor);
        else
			set mensaje = "es una subasta";
		end if;
    end if;
    return mensaje;
    
end //
delimiter ;

-- Ejercicio 2 - Stored Functions

drop function cerrarPublicacion;
delimiter //
create function cerrarPublicacion (idPubli int,codUsuario int)
returns Varchar(45) deterministic 
begin 
	declare confirmacion boolean default false;
	declare publi int default 0;
    declare dni int default 0;
    declare califVen int default 0;
    declare califComp int default 0;
    select publicacion.usuario_dni, idpublicacion, califVendedor, califComprador into dni, publi, califVen, califComp from publicacion 
    join compra on publicacion_idpublicacion=idpublicacion
    where idpublicacion=idPubli and publicacion.usuario_dni=codUsuario;
    if publi=idPubli and dni=codUsuario and califVen is not null and califComp is not null then
		update publicacion set estado="vendido" where idpublicacion=idPubli;
        set confirmacion=true;
	end if;
    return confirmacion;
end //
delimiter ;

select cerrarPublicacion(2,87654321);


-- Ejercicio 3 - Stored Functions

drop function eliminarProducto;
delimiter //
create function eliminarProducto(idProd int) returns varchar(60) deterministic 
begin
	declare mensaje varchar(60) default "Esta asociado a una publicacion";
    declare publi int default null;
    select idpublicacion into publi from publicacion where producto_idproducto=idProd;
    if publi is null then
		delete from producto where idproducto=idProd;
        set mensaje="No esta asociado a ninguna publicacion y fue eliminado";
    end if;
    return mensaje;
end //
delimiter ;

-- Ejercicio 4 - Stored functions

drop function pausarPublicacion;
delimiter //
create function pausarPublicacion(codPublicacion int) returns varchar(45) deterministic 
begin 
	declare mensaje varchar(45) default "No existe la publicacion";
    declare publi int default null;
    select idpublicacion into publi from publicacion where idpublicacion=codPublicacion;
    if publi is not null then
		update publicacion set estado="Pausada" where idpublicacion=codPublicacion;
        set mensaje="La publicacion fue pausada";
    end if;
    return mensaje;
end //
delimiter ;

-- Ejercicio 5 - Stored Functions

drop function pujarProducto;
delimiter //
create function pujarProducto(codPublicacion int, precio decimal, codUsuario int) returns varchar(100) deterministic 
begin 
	declare pujaActual decimal default 0;
    declare mensaje varchar(100) default "La publicacion no esta activa o no es subasta";
    declare estadoActual varchar(45) default "";
    declare tipoPubli varchar(45) default "";
    select monto into pujaActual from oferta where publicacion_idpublicacion=codPublicacion;
    select estado into estadoActual from publicacion where idpublicacion=codPublicacion;
    select tipo into tipoPubli from publicacion where idpublicacion=codPublicacion;
    if tipoPubli="Subasta" and estadoActual="Activo" then
		set mensaje="El monto no pasa al anterior";
		if precio>pujaActual then
			update oferta set monto=precio, usuario_dni=codUsuario where publicacion_idpublicacion=codPublicacion;
            set mensaje="Oferta realizada con exito";
        end if;
    end if;
    return mensaje;
end //
delimiter ;

-- Ejercicio 6 - Stored Functions

drop function eliminarCategoria;
delimiter //
create function eliminarCategoria(nombreCat varchar(45)) returns varchar(45) deterministic 
begin 
	declare idPubli int default null;
    declare mensaje varchar(45) default "No se pudo eliminar";
	select idPublicacion into idPubli from publicacion where nombreCat=categorias_categoria;
    if idPubli is null then
		delete from categorias where nombreCat=categoria;
        set mensaje ="Categoria eliminada";
    end if;
    return mensaje;
end //
delimiter ;


-- Ejercicio 7- stored functions

drop function puntuarComprador;
delimiter //
create function puntuarComprador(codVendedor int, codCompra int, calif int) returns varchar(45) deterministic 
begin 
	declare mensaje Varchar(45) default "Error al actualizar la calificacion";
    declare publi int default null;
    declare vendedor int default 0;
    declare comprador int default 0;
    declare reputacionFinal decimal default 0;
    select idpublicacion, publicacion.usuario_dni into publi, vendedor from publicacion join compra on publicacion_idpublicacion=idpublicacion
    where idcompra=codCompra;
    if publi is not null and vendedor=codVendedor then
		update compra set califComprador=calif where idcompra=codCompra;
        select usuario_dni into comprador from compra where idcompra=codCompra;
        select avg(califComprador) into reputacionFinal from compra where usuario_dni=comprador;
        update usuario set reputacion=reputacionFinal where dni=comprador;
        set mensaje="Calificacion actualizada";
    end if;
    return mensaje;
end //
delimiter ;


select usuario_dni from compra where idcompra=1;
  select avg(califComprador) from compra where usuario_dni=12345678;
select puntuarComprador(87654321,3,100);
select * from usuario where dni=87654321;
select avg(califComprador) from compra where usuario_dni=87654321;

-- Ejercicio 8 - Stored Functions

drop function responderPregunta;
delimiter //
create function responderPregunta(idVendedor int, preg varchar(100), resp varchar(100)) returns varchar(45) deterministic 
begin 
	declare mensaje varchar(45) default "Solo el vendedor puede responder";
    declare vendedor int default null; 
    declare idPubli int default null;
    select usuario_dni, idpublicacion into vendedor, idPubli from publicacion join qYa on publicacion_idpublicacion=idpublicacion
    where pregunta=preg;
    if vendedor=idVendedor then
		update qYa set respuesta=resp where idPubli=publicacion_idpublicacion and preg=pregunta;
        set mensaje="Ok";
    end if;
    return mensaje;
end //
delimiter ;

-- Ejercicio 1 - Triggers

drop trigger borrarPreguntas;
delimiter //
create trigger borrarPreguntas before delete 
on publicacion for each row
begin 
	delete from qYa where publicacion_idpublicacion = old.idpublicacion;
end //
delimiter ;

select * from qYa;
delete from publicacion where idpublicacion=2;

-- Ejercicio 2 - Triggers

drop trigger Calificar;
delimiter //
create trigger Calificar after update
on compra for each row
begin 
if new.califComprador is not null and new.califVendedor is not null then 
	update usuario set reputacion = (select avg(califComprador+calComprador) from compra
    where dni=new.usuario_dni) where usuario_dni=new.usuario_dni;
    update usuario set reputacion = (select avg(califVendedor+calVendedor) from publicacion join compra on idpublicacion=publicacion_idPublicacion
    where dni=new.usuario_dni) where usuario_dni=new.usuario_dni;
end if;
	
end //
delimiter ;

-- Ejercicio 3 - Triggers
drop trigger cambiarCategorias;
delimiter //
create trigger cambiarCategorias after insert 
on compra for each row
begin
	declare cantidadVentas int default 0;
    select count(*) into cantidadVentas from compra where usuario_dni = new.usuario_dni;
    if cantidad < 6 then
		update usuario set nivel = "NORMAL" where usuario_dni = new.usuario_dni;
	else if cantidad < 10 then
		update usuario set nivel = "GOLD" where usuario_dni = new.usuario_dni;
	else 
		update usuario set nivel = "PLATINUM" where usuario_dni = new.usuario_dni;
	end if;
    end if;
end //
delimiter ;

