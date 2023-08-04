drop database tpIntegrador;
create database tpIntegrador;
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


/* drop procedure buscarPublicacion;
delimiter //
create procedure buscarPublicacion ()
begin

end//
delimiter ;
*/

-- Ejercicio 1 - Procedures
drop procedure buscarPublicacion;
delimiter //
create procedure buscarPublicacion (in nombreProd varchar(45))
begin
	select idpublicacion, producto.nombre, categorias_categoria, precio from publicacion 
    join producto on idproducto=producto_idproducto where producto.nombre=nombreProd;
end//
delimiter ;

call buscarPublicacion ('Smartphone');

-- Ejercicio 2 - Procedures
drop procedure crearPublicacion;
delimiter //
create procedure crearPublicacion (in publicacionId int, in publicacionPrecio decimal, in tipoPublicacion varchar(45), in categoriaPublicacion varchar(45), in fechaFinPublicacion date, in usuarioDNIPublicacion int, in productoIdPublicacion int, in estadoPublicacion varchar(45))
begin
	insert into publicacion values (publicacionId, publicacionPrecio, tipoPublicacion, categoriaPublicacion, fechaFinPublicacion, usuarioDNIPublicacion, productoIdPublicacion, estadoPublicacion);
end//
delimiter ;

-- Ejercicio 3 - Procedures
drop procedure verPreguntas;
delimiter //
create procedure verPreguntas (in codPublicacion Int)
begin
	
    select pregunta from pYa where codPublicacion = publicacion_idpublicacion;
    
end//
delimiter ;


SET GLOBAL log_bin_trust_function_creators = 1;
-- Ejercicio 1 - Stored Functions
drop function comprarProducto;
delimiter //
create function comprarProducto (usuarioComprador INT, codPublicacion INT, metodoPago Varchar(45), tipoEnvio Varchar(45))
returns Varchar(45) not deterministic 
begin 
	
    declare mensaje Varchar(45) default "no está activo";
	declare estadoActual Varchar(45) default "";
    declare tipoVenta varchar(45) default "";
    
    select estado into estadoActual from publicacion where idpublicacion = codPublicacion;
	if estadoActual = "Activa" then
		select tipo into tipoVenta from publicacion where idpublicacion = codPublicacion;
        if tipoVenta = "Venta directa" then
			update 
			insert into compra values (null, codPublicacion, usuarioComprador, tipoEnvio, metodoPago, now(), null, null);
        else
			set mensaje = "es una subasta";
		end if;
    end if;
    return mensaje;
    
end //
delimiter ;


drop function cerrarPublicacion;
delimiter //
create function cerrarPublicacion (idPubli int,codUsuario int)
returns Varchar(45) not deterministic 
begin 
	declare confirmacion boolean default false;
	declare publi int default 0;
    declare dni int default 0;
    declare califVen int default 0;
    declare califComp int default 0;
    select usuario_dni, idpublicacion, califVendedor, califComprador into publi, dni, califVen, califComp from publicacion 
    where idpublicacion=idPubli and usuario_dni=codUsuario;
    if publi=idPubli and dni=codUsuario and califVen!=null and califComp!=null then
		update publicacion set estado="vendido" where idpublicacion=idPubli;
        set confirmacion=true;
	end if;
    return confirmacion;
end //
delimiter ;