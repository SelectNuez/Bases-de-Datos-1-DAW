drop table departamento cascade constraints;
drop table empleado cascade constraints;
drop table Emp_Dpto cascade constraints;
drop table Salario cascade constraints;
drop table Cargo cascade constraints;

create table Departamento(
    id_dpto integer primary key,
    nombre_dpto varchar2(40)
);
Create table Empleado(
    id_emp integer primary key,
    nombre varchar2(14),
    ape1 varchar2(25),
    ape2 varchar2(25),
    genero varchar2(1),
    f_nac date,
    f_inicio_contrato date,
    f_fin_contrato date
);
create table Emp_Dpto(
    id_emp integer,
    id_dpto integer,
    f_inicio date,
    f_fin date,
    constraint pk_Emp_Dpto primary key (id_emp,id_dpto),
    CONSTRAINT id_emp_Emp_Dpto_fk foreign key (id_emp) references empleado(id_emp),
    CONSTRAINT id_dpto_fk foreign key (id_dpto) references Departamento(id_dpto)
);
Create table Salario(
    id_emp integer,
    f_inicio date,
    f_fin date,
    salario number(6,2),
    constraint pk_Salario primary key (id_emp,f_inicio),
    CONSTRAINT id_emp_salario_fk foreign key (id_emp) references empleado(id_emp)
);

Create table Cargo(
    id_emp integer,
    f_inicio date,
    f_fin date,
    cargo varchar(50),
    constraint pk_Cargo primary key (id_emp,f_inicio),
    CONSTRAINT id_emp_Cargo_fk foreign key (id_emp) references empleado(id_emp)
);
-- insertar valores en Departamento
insert into Departamento values (1, 'Ventas');
insert into Departamento values (2, 'Compras');
insert into Departamento values (3, 'Asistencia Técnica');
insert into Departamento values (4, 'Dirección');
insert into Departamento values (5, 'Administración');
-- Insertar Empleados
insert into Empleado values(1, 'Jose','Fernandez','Peral','M','01/01/1976','10/03/2015','17/06/2017');
insert into Empleado values(2, 'Lucia','Martin','del Barco','F','05/03/1988','02/05/2019',null);
insert into Empleado values(3, 'Franciso','Raposo','Garcia','M','19/11/1966','28/12/2013',null);
insert into Empleado values(4, 'Mario','Fernandez','Velazquez','M','26/12/1995','07/09/2009',null);
insert into Empleado values(5, 'Alvaro','Garcia','Rapado','M','22/08/1982','08/10/2011',null);
insert into Empleado values(6, 'Laura','Garcilaso','de la Vega','F','19/06/1968','13/08/2003','11/07/2022');
-- Insertat Emp_Dpto
insert into Emp_Dpto values(1,2,'10/03/2015','17/06/2017');
insert into Emp_Dpto values(2,1,'02/05/2019',null);
insert into Emp_Dpto values(3,5,'28/12/2013',null);
insert into Emp_Dpto values(4,5,'07/09/2009',null);
insert into Emp_Dpto values(5,4,'08/10/2011',null);
insert into Emp_Dpto values(6,3,'13/08/2003','11/07/2022');
-- Insertar Salario
insert into Salario values(1,'10/03/2015','17/06/2017',3000.2);
insert into Salario values(2,'02/05/2019',null,1425.12);
insert into Salario values(3,'28/12/2013',null,1666.78);
insert into Salario values(4,'07/09/2009',null,7865.45);
insert into Salario values(5,'08/10/2011',null,1200.86);
insert into Salario values(6,'13/08/2003','11/07/2022',1700.51);
-- Insertar Cargo
insert into Cargo values(1,'10/03/2015','17/06/2017','Comprador');
insert into Cargo values(2,'02/05/2019',null,'Vendedor');
insert into Cargo values(3,'28/12/2013',null,'Recepcionista');
insert into Cargo values(4,'07/09/2009',null,'Secretario');
insert into Cargo values(5,'08/10/2011',null,'Director');
insert into Cargo values(6,'13/08/2003','11/07/2022','Inforamtico');