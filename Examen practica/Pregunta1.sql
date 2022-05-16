--Inserta una nueva fila en la tabla “Empleado”.
INSERT INTO EMPLEADO (id_emp,nombre,ape1,ape2,genero,f_nac,f_inicio_contrato,f_fin_contrato) VALUES (8, 'Jose','Fernandez','Peral','H','01/01/1976','10/03/2015','17/06/2017');
--Inserta una fila en la tabla Cargo para el empleado Jose Fernandez Peral
INSERT INTO CARGO VALUES ((SELECT ID_EMP FROM EMPLEADO WHERE Nombre='Jose' 
AND APE1 ='Fernandez' 
AND APE2='Peral'),to_date('15/02/2003',DD-MM-YYYY),'16/4/2005','Mensajero');

--Elimina la empleada Lucia Martin del Barco del departamento Ventas // DELETE FROM emp_dpto??
DELETE FROM EMPLEADO WHERE Nombre='Lucia' 
AND APE1 ='Martin' 
AND APE2='Del Barco'
AND 'Ventas' = 
(SELECT nombre_dpto FROM Departamento WHERE 
id_dpto = (SELECT id_dpto FROM emp_dpto WHERE 
id_emp = (SELECT id_emp from Empleado WHERE 
Nombre='Lucia' 
AND APE1 ='Martin' 
AND APE2='Del Barco' 
)));

DELETE FROM EMP_DPTO WHERE ID_EMP = (SELECT ID_EMP FROM EMPLEADO WHERE Nombre='Lucia' 
AND APE1 ='Martin' 
AND APE2='Del Barco') AND ID_DPTO = (SELECT ID_DPTO FROM DEPARTAMENTO WHERE NOMBRE_DPTO = 'Ventas');

--Elimina todos los salarios del empleado Vicente Escudero Fuertes salvo el actual
DELETE FROM SALARIO WHERE id_emp = (
SELECT id_EMP from empleado where
nombre = 'Vicente' AND
ape1 = 'Escudero' AND
ape2 = 'Fuertes') AND
F_FIN is not null;

--Actualiza el salario del empleado con id_emp=201103 // AND f_fin IS NULL;??
UPDATE SALARIO SET Salario = 500 WHERE id_emp = '19804' AND f_fin IS NULL;

