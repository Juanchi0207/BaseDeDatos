

create table `customers_audit` (
	`idAudit`  int auto_increment not null primary key,
    `operacion` char(6) ,
    `users` varchar(45),
    `last_date_modified` date,
    `customerNumber` int(11) NOT NULL,
	`customerName` varchar(50) NOT NULL,
	`city` varchar(50) NOT NULL
);
-- 1.a)
delimiter // 
create trigger trigger1a after insert on customers
for each row 
begin 
	insert into customers_audit values(null, "insert", user(), curdate(), new.customerNumber, new.customerName, new.city);
end //
delimiter ;

-- 1.b)

delimiter //
create trigger trigger1b before update on customers
for each row
begin
	insert into customers_audit values(null, "update", user(), curdate(), old.customerNumber, old.customerName, old.city);
end//
delimiter ;

-- 1.c)

delimiter // create trigger trigger1c before delete on customers 
for each row 
begin
	insert into customers_audit values(null, "insert", user(), curdate(), old.customerNumber, old.customerName, old.city);
end//
delimiter ;

-- 2)

CREATE TABLE `employees_audit` (
  `idAudit` int auto_increment not null primary key,
  `operacion` char(6),	
  `users` varchar(45),
  `last_date_modified` date,
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL
);

-- 2.a)
  
delimiter //
create trigger trigger2a after insert on employees
for each row
begin
	insert into employees_audit values (null, "insert", user(), curdate(), new.employeeNumber, new.lastName, new.firstName);
end //
delimiter ;

-- 2.b) 

delimiter //
create trigger trigger2b before update on employees
for each row 
begin
	insert into employees_audit values (null, "insert", user(), curdate(), old.employeeNumber, old.lastName, old.firstName);
end //
delimiter ;

-- 2c)

delimiter //
create trigger trigger2c before delete on employees 
for each row 
begin
	insert into employees_audit values (null, "insert", user(), curdate(), new.employeeNumber, new.lastName, new.firstName);
end //
delimiter ;
    