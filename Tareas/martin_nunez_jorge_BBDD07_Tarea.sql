
--1.Crea el tipo de objetos "Personal"

CREATE TYPE Personal AS OBJECT (
codigo INTEGER,
dni VARCHAR2(10),
nombre VARCHAR2(30),
apellidos VARCHAR2(30),
sexo VARCHAR2(1),
fecha_nac DATE
) NOT FINAL;
/

--Crea, como tipo heredado de "Personal", el tipo de objeto "Responsable"

CREATE TYPE Responsable UNDER Personal (
    tipo CHAR ,
    antiguedad INTEGER,

--2.Crea un método constructor para el tipo de objetos "Responsable"

    CONSTRUCTOR FUNCTION Responsable(nombre VARCHAR2, apellido1 VARCHAR2, apellido2 VARCHAR2, tipo CHAR)
        RETURN SELF AS RESULT,
--3.Crea un método getNombreCompleto para el tipo de objetos Responsable que permita obtener su nombre completo con el formato apellidos nombre
    MEMBER FUNCTION getNombreCompleto RETURN VARCHAR2
              
);
/

CREATE OR REPLACE TYPE BODY Responsable AS
CONSTRUCTOR FUNCTION Responsable (nombre VARCHAR2, apellido1 VARCHAR2, apellido2 VARCHAR2, tipo CHAR)
    RETURN SELF AS RESULT IS
            BEGIN
                self.nombre := nombre;
                self.apellidos := apellido1 || ' ' || apellido2;
                self.tipo := tipo;
                RETURN;
            END;
    MEMBER FUNCTION getNombreCompleto RETURN VARCHAR2 IS
    BEGIN
        RETURN Self.apellidos || ' ' || self.nombre;
    END;
            
END;
/

--Crea el tipo de objeto "Zonas"

CREATE TYPE Zonas AS OBJECT (
codigo INTEGER, 
nombre VARCHAR2(20), 
refRespon REF Responsable, 
codigoPostal CHAR(5),
--9.Crea un método MAP ordenarZonas para el tipo Zonas. Este método debe retornar el nombre completo del Responsable al que hace 
--referencia cada zona. Para obtener el nombre debes utilizar el método getNombreCompleto que se ha creado anteriormente
MAP MEMBER FUNCTION OrdenarZonas RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY Zonas AS
    MAP MEMBER FUNCTION OrdenarZonas RETURN VARCHAR2 IS
        Respon Responsable;
    BEGIN
        SELECT DEREF(refRespon) INTO Respon FROM DUAL;
        RETURN Respon.getNombreCompleto();
    END;
END;
/

--Crea, como tipo heredado de "Personal", el tipo de objeto "Comercial"
CREATE TYPE Comercial UNDER Personal (
zonaComercial Zonas
);
/





--4.Crea un tabla TablaResponsables de objetos  Responsable

CREATE TABLE TablaResponsables OF Responsable;
/
--5.Crea una colección VARRAY llamada ListaZonas en la que se puedan almacenar hasta 10 objetos Zonas.
--Guarda en una instancia listaZonas1 de dicha lista, dos Zonas

CREATE TYPE ListaZonas as VARRAY(10) OF Zonas;
/

--6.Crea una tabla TablaComerciales de objetos Comercial.
CREATE TABLE TablaComerciales OF Comercial;
/



DECLARE 
    ListaZonas1 ListaZonas;
    
    Zona1 Zonas;
    Zona2 Zonas;
    
    refRespon REF Responsable;
    --7.Obtener, de la tabla TablaComerciales, el Comercial que tiene el código 100, asignándoselo a una variable unComercial 
    unComercial Comercial;
    
    
BEGIN
    INSERT INTO TablaResponsables VALUES (Responsable(5,'51083099F','ELENA','POSTA LLANOS','F','31/03/1975','N',4));
    INSERT INTO TablaResponsables VALUES (new Responsable('JAVIER','JARAMILLO','HERNANDEZ','C')); --El codigo no puede añadirse con el contructor ya que no se ha definido en el mismo
    UPDATE "TABLARESPONSABLES" SET CODIGO = '6' WHERE TablaResponsables.Nombre = 'JAVIER';
    
    SELECT REF(r) INTO refRespon FROM TablaResponsables r WHERE r.dni = '51083099F';
    Zona1 := new Zonas(1,'zona 1',refRespon,'06834');

    SELECT REF(r) INTO refRespon FROM TablaResponsables r WHERE r.codigo = 6;
    Zona2 := new Zonas(2,'Zona 2',refRespon,'28003');
    
    ListaZonas1 := ListaZonas(Zona1,Zona2);
    
   INSERT INTO TablaComerciales VALUES (Comercial(100,'23401092Z','MARCOS','SUAREZ LOPEZ','M','30/3/1990',listazonas1(1)));
   INSERT INTO TablaComerciales VALUES (Comercial(102,'6932288V','ANASTASIA','GOMES PEREZ','F','28/11/1984',listazonas1(2)));
   
   SELECT VALUE(c) INTO unComercial FROM tablacomerciales c WHERE c.codigo = 100;
    --8.Modifica el código del Comercial guardado en esa variable unComercial asignando el valor 101, y su zona debe ser la segunda 
    --que se había creado anteriormente. Inserta ese Comercial en la tabla TablaComerciales  
    unComercial.codigo := 101;
    unComercial.zonaComercial := listaZonas1(2);
    
    INSERT INTO tablacomerciales VALUES (unComercial);
   
END;
/
--10.Realiza una consulta de la tabla TablaComerciales ordenada por zonaComercial para comprobar el funcionamiento del método MAP. 
SELECT * FROM TablaComerciales ORDER BY zonaComercial;

