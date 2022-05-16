--Pregunta3
--Construye un disparador  o disparadores que permita controlar las siguientes restricciones:

--a)El salario no puede ser negativo // Mejor crear asi para tener varios Triggers en una tabla o como en la solucion?
Create or replace Trigger a
Before insert or Update ON salario
for EACH row
declare
salarioNeg Exception;

begin
if(:new.salario < 0)
    then raise salarioNeg;
end if;

exception
    when salarioNeg then
    RAISE_APPLICATION_ERROR(-20001,'El salario no puede ser negativo');
end a;
/
--b)En la tabla empleado, el genero debe ser uno de los siguientes: H,M,N,O,X
--c)En la tabla empleado, la fecha de nacimiento no puede ser posterior a la de inicio de contrato
--d)En la tabla empleado, la fecha fin de contrato no puede ser posterior a la de inicio de contrato
Create or replace Trigger bcd
Before insert or update ON empleado
for EACH row
declare
ex_gen Exception;
ex_fecha_nac Exception;
ex_fecha_fin Exception;

begin
if(:new.genero NOT IN ('H','M','N','O','X'))
--if(:new.genero <> 'H' AND :new.genero <> 'M' AND :new.genero <> 'N' AND :new.genero <> 'O' AND :new.genero <> 'X')
    then raise ex_gen;
end if;

if(:new.f_inicio_contrato < :new.f_nac)
    then raise ex_fecha_nac;
end if;
if(:new.f_fin_contrato < :new.f_inicio_contrato)
    then raise ex_fecha_fin;
end if;

exception
    when ex_gen then
    RAISE_APPLICATION_ERROR(-20002,'El genero debe ser uno de los siguientes: H,M,N,O,X');
    when ex_fecha_nac then
    RAISE_APPLICATION_ERROR(-20003,'La fecha de nacimiento no puede ser posterior a la de inicio de contrato');
    when ex_fecha_fin then
    RAISE_APPLICATION_ERROR(-20004,'La fecha inicio de contrato no puede ser posterior a la de fin de contrato');
end bcd;
/

Create or replace Trigger e
Before insert or Update ON emp_dpto
for EACH row
declare
multiDep Exception;
ndptos integer;
 
begin 
select count(id_emp) into ndptos from emp_dpto where id_emp = :new.id_emp AND f_fin is null;

if(ndptos>=2)
    then raise multiDep;
end if;

exception
    when multiDep then
    RAISE_APPLICATION_ERROR(-20001,'Un empleado no puede estar en mas de dos departamentos');
end e;
/
--e)Un empleado no puede estar en mas de dos departamentos

INSERT INTO EMPLEADO (ID_EMP,NOMBRE,APE1,APE2,GENERO,F_NAC,F_INICIO_CONTRATO,F_FIN_CONTRATO) VALUES (13,'Vicente','Escudero','Fuertes','H','19/04/2004','12/10/2005','01/12/2006');
INSERT INTO EMP_DPTO (id_emp,id_dpto,f_inicio,f_fin) VALUES (6,4,'12/12/2011',null);

