--Inserta una nueva fila en la tabla “Piloto”.
INSERT INTO PILOTO VALUES (1001, 'Jorge','Martin','Nunez','SAO','La mia',27,102);

--Actualiza la fila en la tabla Tarjeta para el empleado Casi Naelle Giovanizio
UPDATE TARJETA SET consumo = 1500 WHERE NUM=(SELECT NUMTARJETA FROM PILOTO WHERE NOMBRE ='Casi' AND APE1='Naelle' AND APE2='Giovanizio');

--Elimina la tarjeta del piloto 132 
DELETE FROM TARJETA WHERE NUM = (SELECT NUMTARJETA FROM PILOTO WHERE ID = 132);

--Elimina todos los pilotos del pais EMIRATOS ARABES
DELETE FROM PILOTO WHERE CIUDAD in(SELECT CODCIUDAD FROM CIUDAD WHERE PAIS in (SELECT CODPAIS From PAIS WHERE NOMBRE = 'EMIRATOS ARABES'));

--Actualiza consumo de la tarjeta 188
UPDATE TARJETA SET CONSUMO = 1500 WHERE NUM=188;

--Actualiza el modelo de todos los pilotos de mas de 45 años a senior
UPDATE TARJETA SET MODELO ='senior' where  NUM in (SELECT NUMTARJETA FROM PILOTO WHERE EDAD > 45) AND MODELO = 'junior';

--Crea un metodo que actualice a Senior los mayores de 45 años y que sean junior
declare
PROCEDURE cambiarSenior
IS
begin
    UPDATE TARJETA SET MODELO ='senior' where  NUM in (SELECT NUMTARJETA FROM PILOTO WHERE EDAD > 45) AND MODELO = 'junior';
END;
begin
cambiarSenior ();
end;
/

--Añade un constructor a OCiudad
ALTER TYPE OCIUDAD ADD CONSTRUCTOR FUNCTION OCIUDAD(
    codCiudad VARCHAR2,
	nombre VARCHAR2,
	pais REF oPais,
	tamanno INTEGER) RETURN SELF AS RESULT CASCADE;
/
CREATE OR REPLACE TYPE BODY OCIUDAD AS
    CONSTRUCTOR FUNCTION OCIUDAD(
    codCiudad VARCHAR2,
	nombre VARCHAR2,
	pais REF oPais,
	tamanno INTEGER)
    RETURN SELF AS RESULT IS
    BEGIN
        SELF.CODCIUDAD := CODCIUDAD;
        SELF.NOMBRE := NOMBRE;
        SELF.pais := PAIS;
        SELF.TAMANNO := TAMANNO;
        RETURN;
    END;
END;
/

--Añade un constructor a OTarjeta;
ALTER TYPE OTARJETA ADD CONSTRUCTOR FUNCTION OTARJETA(
     num INTEGER,
     modelo VARCHAR2,
     compannia VARCHAR2,
     consumo INTEGER) RETURN SELF AS RESULT CASCADE;
 /
 
 CREATE OR REPLACE TYPE BODY OTARJETA AS
    CONSTRUCTOR FUNCTION OTARJETA(
     num INTEGER,
     modelo VARCHAR2,
     compannia VARCHAR2,
     consumo INTEGER) RETURN SELF AS RESULT IS
     BEGIN
        SELF.num := num;
        SELF.modelo := modelo;
        SELF.compannia := compannia;
        SELF.consumo := consumo;
        RETURN;
    END;
END;
/

--Crea la tabla salarios de OSALARIO
CREATE TABLE SALARIOS OF OSALARIO;

CREATE TABLE OTarjetas of Otarjeta;
--Crea un Varray de 2 tarjetas
    CREATE TYPE Vtarjeta as VARRAY(2) of Otarjeta;
/
--

declare
    Vtarjeta1 Vtarjeta;
    Otarjeta1 Otarjeta;
    Otarjeta2 Otarjeta;
BEGIN
    Otarjeta1 := new otarjeta(1002,'senior','Dark umbra',1500);
    Otarjeta2 := new otarjeta(1003,'junior','White umbra',5100);
    Vtarjeta1 := vtarjeta(otarjeta1,otarjeta2);
    insert into OTarjetas values(Otarjeta1);
    insert into OTarjetas values(Otarjeta2);
    commit;
END;
/

--Crea un disparador que compruebe que el piloto es mayor de edad
Create or replace Trigger tEdad
Before insert or Update ON piloto
for EACH row
declare
menEdad Exception;

begin
if(:new.edad < 18)
    then raise menEdad;
end if;

exception
    when menEdad then
    RAISE_APPLICATION_ERROR(-20001,'El piloto no puede ser menor de edad');
end tEdad;
/

--INSERT INTO piloto VALUES(1202, 'Killian', 'Nadege', 'Ollarenshaw', 'ANC', '5547 Declaration Parkway', 18, 130);

--Crear un disparador que compruebe que el consumo de la tarjeta sea mayor que 0
Create or replace Trigger tConsumo
Before insert or Update ON tarjeta
for EACH row
declare
conNeg Exception;

begin
if(:new.consumo <= 0)
    then raise conNeg;
end if;

exception
    when conNeg then
    RAISE_APPLICATION_ERROR(-20002,'El consumo debe ser mayor que 0');
end tConsumo;
/

--INSERT INTO tarjeta VALUES(1522, 'experimental', 'Thrasher, curve-billed',1);

--Crear un disparador que compruebe que el modelo de la tarjeta no esta retirado antes de asignarselo a un nuevo piloto
create or replace Trigger tRet2
Before insert or update ON piloto
for Each row
declare
tarRet exception;
    tar tarjeta.modelo%type;

begin
    select modelo into tar from tarjeta where num = :new.numtarjeta;
    
    if(tar  ='retirado')
        then raise tarRet;
    end if;

exception
    when tarRet then
    RAISE_APPLICATION_ERROR(-20003,'La tarjeta no puede estar retirada');
end tarRet2;
/
--INSERT INTO piloto VALUES(150121, 'Killian', 'Nadege', 'Ollarenshaw', 'ANC', '5547 Declaration Parkway', 18, 748);

--Crea el objeto piloto con los mismos parametros que la tabla piloto. Siendo el numTarjeta una Varray de oTarjeta y ciudad una referencia de oCiuidad
CREATE TYPE vnumTarjeta as VARRAY(2) of oTarjeta;
/
--create type vTarjeta is varray(3) of oTarjeta;
--/
----
CREATE TYPE oPiloto AS OBJECT (
    idPiloto number(5,0),
    nombre varchar2(25),
    ape1 varchar2(25),
    ape2 varchar2(25),
    ciudad varchar2(25),
    direccion varchar2(25),
    edad number(5,0),
    numtarjeta vnumTarjeta
    );
    /
--create or replace type oPiloto as object(
--    idPiloto number(38,0),
--    nombre varchar2(25),
--    ape1 varchar2(25),
--    ape2 varchar2(25),
--    ciudad oCiudad,
--    direccion varchar2(50),
--    edad number(2,0),
--    numTarjeta vTarjeta
--);
--/
--Crea un constructor para el objeto piloto
ALTER TYPE oPiloto ADD CONSTRUCTOR FUNCTION oPiloto(
    idPiloto number,
    nombre varchar2,
    ape1 varchar2,
    ape2 varchar2,
    ciudad varchar2,
    direccion varchar2,
    edad number,
    numtarjeta vnumTarjeta) RETURN SELF AS RESULT CASCADE;
 
--alter type oPiloto add constructor function oPiloto(
--    idPiloto number, 
--    nombre varchar2, 
--    ape1 varchar2, 
--    ape2 varchar2, 
--    ciudad oCiudad, 
--    direccion varchar2, 
--    edad number,
--    numTarjeta vTarjeta) 
--    return self as result cascade; 
 CREATE OR REPLACE TYPE BODY oPiloto AS
    CONSTRUCTOR FUNCTION oPiloto(
    idPiloto number,
    nombre varchar2,
    ape1 varchar2,
    ape2 varchar2,
    ciudad varchar2,
    direccion varchar2,
    edad number,
    numtarjeta vnumTarjeta) RETURN SELF AS RESULT IS
     BEGIN
        SELF.idPiloto := idPiloto;
        SELF.nombre := nombre;
        SELF.ape1 := ape1;
        SELF.ape2 := ape2;
        SELF.ciudad := ciudad;
        SELF.direccion := direccion;
        SELF.edad := edad;
        SELF.numtarjeta := numtarjeta;
        RETURN;
    END;
END;
/
--    create or replace type body oPiloto as constructor function oPiloto(
--    idPiloto number, 
--    nombre varchar2, 
--    ape1 varchar2, 
--    ape2 varchar2, 
--    ciudad oCiudad, 
--    direccion varchar2, 
--    edad number,
--    numTarjeta vTarjeta) 
--    return self as result is
--    begin
--        self.idPiloto := idPiloto;
--        self.nombre := nombre;
--        self.ape1 := ape1;
--        self.ape2 := ape2;
--        self.ciudad := ciudad;
--        self.direccion := direccion;
--        self.edad := edad;
--        self.numTarjeta := numTarjeta;
--        return;
--    end;
--end;
--/
--Objeto de piloto e insertarlo en la tabla
CREATE TABLE oPilotos of oPiloto;
/
--create table tabla_OPiloto of oPiloto;
--/
--create table tabla_oPais of oPais;
--/
--insert into tabla_oPais values('ES','España');
--/
declare
   Vnumtarjeta1 Vnumtarjeta;
   Otarjeta3 Otarjeta;
   Otarjeta4 Otarjeta;
    opiloto1 opiloto;

BEGIN
    Otarjeta3 := new otarjeta(1004,'senior','Dark umbra',1500);
    Otarjeta4 := new otarjeta(1005,'junior','White umbra',5100);
    Vnumtarjeta1 := vnumtarjeta(otarjeta3,otarjeta4);
    opiloto1 := new opiloto('10000', 'Jorge', 'Martin', 'Nunez','DTT','13892', '27', Vnumtarjeta(otarjeta('1004','senior','Dark umbra','1500'),otarjeta('1005','junior','White umbra','5100')));
    insert into oPilotos values(oPiloto1);
    commit;
END;
/
--
--declare
--    unPiloto oPiloto;
--    unaCiudad oCiudad;
--    unPais REF oPais;
--begin
--    select ref(t) into unPais from tabla_oPais t where t.codPais='ES';
--    unaCiudad := new oCiudad('VAL', 'Valladolid', unPais, 10);
--    unPiloto := new oPiloto(100,'Alberto','Velazquez','Rapado',unaCiudad, 'Calle falsa 123',30,vTarjeta( oTarjeta(1004, 'senior', 'cosa1',1000),oTarjeta(1005, 'junior', 'cosa2',2000)
--            )
--        );
--    insert into tabla_OPiloto values (unPiloto); 
--end;
--/
--Modifica el atributo edad de piloto y actualiza la tabla con el
Declare
begin
    update Opilotos o set o.edad = '28' where o.nombre='Jorge' AND o.ape1 = 'Martin';
    commit;
end;
/
