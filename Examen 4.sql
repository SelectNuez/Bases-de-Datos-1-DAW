--PREGUNTA 4: Realiza cada uno de los ejercicios sobre bases de datos objeto-relacionales. Emplearemos un diseño de base de datos derivado del de las preguntas 1, 2 y 3.
--a) Declara el objeto oSalario con los siguientes parámetros:
--- f_inicio de tipo Fecha.
--- f_fin de tipo Fecha.
--- salario de tipo numero.

    CREATE TYPE oSalario AS OBJECT (
    f_inicio date,
    f_fin date,
    salario INTEGER
    );
    /

--b) Declara el objeto oCargo con los siguientes parámetros:
--- f_inicio de tipo Fecha.
--- f_fin de tipo Fecha.
--- cargo de tipo cadena de caracteres de longitud 50.
    CREATE TYPE oCargo AS OBJECT (
    f_inicio date,
    f_fin date,
    cargo varchar2(50)
    );
    /

--c) Redefine los objetos oSalario y oCargo y añade un constructor para ellos.
    CREATE TYPE oSalario AS OBJECT (
    f_inicio date,
    f_fin date,
    salario INTEGER,
    CONSTRUCTOR FUNCTION oSalario(f_inicio date,f_fin date,salario INTEGER)
        Return SELF as Result
    );
    /
    CREATE OR REPLACE TYPE BODY oSalario AS
    CONSTRUCTOR FUNCTION oSalario (f_inicio date,f_fin date,salario INTEGER)
        RETURN SELF AS RESULT IS
            BEGIN
                self.f_inicio := f_inicio;
                self.f_fin := f_fin;
                self.salario := salario;
                RETURN;
            END;
    END;
    /
    
    CREATE TYPE oCargo AS OBJECT (
    f_inicio date,
    f_fin date,
    cargo varchar2(50),
    CONSTRUCTOR FUNCTION oCargo(f_inicio date,f_fin date,cargo varchar2)
        Return SELF as Result
    );
    /
    CREATE OR REPLACE TYPE BODY oCargo AS
    CONSTRUCTOR FUNCTION oCargo (f_inicio date,f_fin date,cargo varchar2)
        RETURN SELF AS RESULT IS
            BEGIN
                self.f_inicio := f_inicio;
                self.f_fin := f_fin;
                self.cargo := cargo;
                RETURN;
            END;
    END;

--Si es necesario, supón que se eliminan antes con DROP TYPE.

--d) Declara el objeto oEmpleado con los siguientes parámetros.
--- nombre de tipo cadena de caracteres de longitud 14.
--- ape1 de tipo cadena de caracteres de longitud 25.
--- ape2 de tipo cadena de caracteres de longitud 25.
--- género de tipo carácter.
--- f_nac de tipo fecha.
--- f_inicio_contrato de tipo fecha.
--- f_fin_contrato de tipo fecha.
--- salarios de tipo VARRAY(2) de objetos oSalario.
--- cargos de tipo VARRAY(2) de objetos oCargo.
-- No olvides crear un constructor para el objeto.
        CREATE TYPE Vsalarios as VARRAY(2) of oSalario;
    /
        CREATE TYPE Vcargos as VARRAY(2) of oCargo;
    /


    CREATE OR REPLACE TYPE oEmpleado AS OBJECT (
    nombre varchar2(14),
    ape1 varchar2(25),
    ape2 varchar2(25),
    genero varchar2(1),
    f_nac date,
    f_inicio_contrato date,
    f_fin_contrato date,
    salarios vSalarios,
    cargos vCargos,
        CONSTRUCTOR FUNCTION oEmpleado(nombre varchar2,ape1 varchar2,ape2 varchar2,genero varchar2,f_nac date,f_inicio_contrato date,f_fin_contrato date,salarios VSalarios,cargos VCargos)
        Return SELF as Result
    );
    / 

    CREATE OR REPLACE TYPE BODY oEmpleado AS
    CONSTRUCTOR FUNCTION oEmpleado (nombre varchar2,ape1 varchar2,ape2 varchar2,genero varchar2,f_nac date,f_inicio_contrato date,f_fin_contrato date,salarios VSalarios,cargos VCargos)
        RETURN SELF AS RESULT IS
            BEGIN
                self.nombre := nombre;
                self.ape1 := ape1;
                self.ape2 := ape2;
                self.genero := genero;
                self.f_nac := f_nac;
                self.f_inicio_contrato := f_inicio_contrato;
                self.f_fin_contrato := f_fin_contrato;
                self.salarios := salarios;
                self.cargos := cargos;
                RETURN;
            END;
    END;
/
--e) Crea una tabla Empleado_objs para almacenar objetos de tipo oEmpleado.
    CREATE TABLE Empleado_objs OF oEmpleado;
    /
--f) Crea un objeto de tipo oEmpleado con los siguientes datos:
-- nombre: Flor
-- ape1: Carmona
-- ape2: Delgado
-- género: F
-- f_nac: 12/01/1991
-- f_inicio_contrato: 23/06/2018
-- f_fin_contrato: NULL;
-- salarios:
--1. Salario1:
--a. f_inicio: 23/06/2018
--b. f_fin: 01/09/2021
--c. salario: 1300.33
--2. Salario2:
--a. f_inicio: 02/09/2021
--b. f_fin: NULL
--c. salario: 1970.55
-- Cargos:
--1. Cargo1:
--a. f_inicio: 23/06/2018
--b. f_fin: 01/09/2021
--c. Cargo: Administrativa
--2. Salario2:
--a. f_inicio: 02/09/2021
--b. f_fin: NULL
--c. Cargo: Jefa Servicio

DECLARE
vsalarios1 vsalarios;
oSalario1 oSalario;
oSalario2 oSalario;

vsalarios2 vsalarios;
oSalario3 oSalario;

vcargos1 vcargos;
oCargo1 oCargo;
oCargo2 oCargo;

vcargos2 vcargos;
oCargo3 oCargo;

Empleado1 oEmpleado;
Empleado2 oEmpleado;

BEGIN
oSalario1 := new oSalario('23/06/2018','02/09/2021',1300);
oSalario2 := new oSalario('02/09/2021',null,1970);
vsalarios1 := vsalarios(oSalario1,oSalario2);
oCargo1 := new oCargo('23/06/2018','01/09/2021','Administrativa');
oCargo2 := new oCargo('02/09/2021',null,'Jefa Servicio');
vcargos1 := vcargos(ocargo1,ocargo2);

Empleado1 := new oEmpleado('Flor','Carmona','Delgado','F','12/01/1991','20/06/2018',null,vsalarios1,vcargos1);

--g) Crea otro objeto de tipo oEmpleado con datos inventados por ti.
oSalario3 := new oSalario('23/06/2018','02/09/2021',1300);
vsalarios2 := vsalarios(oSalario3);
oCargo3 := new oCargo('23/06/2018','01/09/2021','Administrativa');
vcargos2 := vcargos(ocargo3);

Empleado2 := new oEmpleado('Mercedes','Lopez','Delgado','M','19/04/1995','28/06/2017',null,vsalarios2,vcargos2);
--h) Guarda en la tabla Empleado_objs los dos objetos que obtuviste en los
--apartados f y g. Muestra el contenido de la tabla Empleado_Objs.
insert into empleado_objs values(Empleado1);
insert into empleado_objs values(Empleado2);


--i) Modifica el valor del atributo f_fin_contrato del objeto que almacena la ficha de la empleada Flor Carmona Delgado.
Empleado1.f_fin_contrato := '15/05/2022';
end;
--j) Muestra el objeto almacenado en la tabla Empleado_Objs donde se refleje la
--modificación.
SELECT * FROM empleado_objs;
--No entiendo que me pida mostrar la tabla si no he insertado el objeto en la tabla
/
drop table empleado_objs;/
drop type oEmpleado;/
drop type vSalarios;/
drop type vCargos;/
drop type oSalario;/
drop type oCargo;/