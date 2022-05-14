--Tarea 2
--Añadir a la tabla STOCK
ALTER TABLE STOCK ADD(
--Una columna de tipo fecha, llamada FechaUltimaEntrada, que por defecto tome el valor de la fecha actual.
FECHAULTIMAENTRADA DATE DEFAULT SYSDATE,
--Una columna llamada Beneficio, que contendrá el tipo de porcentaje de beneficio que esa tienda aplica en ese producto. Se debe controlar que el valor que almacene sea 1,2, 3, 4 o 5.
BENEFICIO NUMBER(1));

ALTER TABLE STOCK ADD CONSTRAINT CK_BENEFICIO
    CHECK (BENEFICIO >0  AND BENEFICIO<6);
--En la tabla PRODUCTO Eliminar de la tabla producto la columna Descripción.
ALTER TABLE PRODUCTO DROP COLUMN DESCRIPCION;
--Añadir una columna llamada perecedero, que únicamente acepte los valores: S o N.
ALTER TABLE PRODUCTO ADD(PERECEDERO CHAR(1));
ALTER TABLE PRODUCTO ADD CONSTRAINT CK_PERECEDERO
    CHECK (PERECEDERO IN ('S','N')); 

--Modificar el tamaño de la columna Denoproducto a 50.
ALTER TABLE PRODUCTO MODIFY
    DENOPRODUCTO VARCHAR2(50);
--En la tabla FAMILIA, Añadir una columna llamada IVA, que represente el porcentaje de IVA y únicamente pueda contener los valores 21,10,ó 4.
ALTER TABLE FAMILIA ADD
    IVA DECIMAL(2,0);
ALTER TABLE FAMILIA ADD CONSTRAINT CK_IVA
    CHECK (IVA = 21 OR IVA=10 OR IVA=4);
--En la tabla tienda, La empresa desea restringir el número de tiendas con las que trabaja, de forma que no pueda haber más de una tienda en una misma zona (la zona se identifica por el código postal). 
--Definir mediante DDL las restricciones necesarias para que se cumpla en el campo correspondiente.
ALTER TABLE TIENDA ADD CONSTRAINT UC_CODIGOPOSTAL
    UNIQUE (CODIGOPOSTAL);

--B) Renombra la tabla STOCK por PRODXTIENDAS.
RENAME STOCK TO PRODXTIENDAS;
--C) Elimina la tabla FAMILIA y su contenido si lo tuviera.
DROP TABLE FAMILIA CASCADE CONSTRAINTS; --Usamos CASCADE CONSTRAINTS ya que en la tabla hay una clave que es ajena en otra tabla como PRODUCTO
--D) Crea un usuario llamado C##INVITADO siguiendo los pasos de la unidad 1 y dale todos los privilegios sobre la tabla PRODUCTO.
CREATE USER C##INVITADO IDENTIFIED BY CLAVEINVITADO;
GRANT CONNECT TO C##INVITADO;
GRANT ALL ON PRODUCTO TO C##INVITADO;
--E) Retira los permisos de modificar la estructura de la tabla y borrar contenido de la tabla PRODUCTO al usuario anterior.
REVOKE ALL ON PRODUCTO FROM C##INVITADO;