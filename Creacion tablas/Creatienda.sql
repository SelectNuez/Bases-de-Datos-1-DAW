--EJERCICIO 1
CREATE TABLE FAMILIA --Contiene las familias a las que pertenecen los productos, como por ejemplo ordenadores, impresoras,etc.
(
  CODFAMILIA NUMBER(3) PRIMARY KEY, --C�digo que distingue una familia de otra
  DENOFAMILIA VARCHAR2(50) NOT NULL UNIQUE   --Denominaci�n de la familia
);

CREATE TABLE PRODUCTO( --Contendr� informaci�n general sobre los productos que distribuye la empresa a las tiendas.
CODPRODUCTO NUMBER(5) PRIMARY KEY, --C�digo que distingue un producto de otro
DENOPRODUCTO VARCHAR2(20) NOT NULL, --Denominaci�n del producto
DESCRIPCION VARCHAR2(100), --Descripci�n del producto
PRECIOBASE NUMBER(10,2) NOT NULL, --Precio base del producto
PORCREPOSICION NUMBER(3), --Porcentaje de reposici�n aplicado a ese producto. Se utilizar� para aplicar a las unidades m�nimas y obtener el n�mero total de unidades a reponer cuando el stock est� bajo m�nimo
UNIDADESMINIMAS NUMBER(4) NOT NULL, --Unidades m�nimas recomendables en almac�n
CODFAMILIA NUMBER(3) NOT NULL --C�digo de la familia a la que pertenece el producto
);

ALTER TABLE PRODUCTO ADD CONSTRAINT CK_PRECIOBASE --Mayor que 0
    CHECK (PRECIOBASE > 0);
ALTER TABLE PRODUCTO ADD CONSTRAINT CK_PORCREPOSICION --Mayor que 0
    CHECK (PORCREPOSICION > 0);
ALTER TABLE PRODUCTO ADD CONSTRAINT CK_UNIDADESMINIMAS --Mayor que 0
    CHECK (UNIDADESMINIMAS > 0);
ALTER TABLE PRODUCTO  --Clave ajena, referencia a Codfamilia de la tabla FAMILIA.
ADD FOREIGN KEY (CODFAMILIA) REFERENCES FAMILIA(CODFAMILIA);

CREATE TABLE TIENDA( --Contendr� informaci�n b�sica sobre las tiendas que distribuyen los productos.
CODTIENDA NUMBER(3) PRIMARY KEY, --C�digo que distingue una tienda de otra.
DENOTIENDA VARCHAR2(20) NOT NULL, --Denominaci�n o nombre de la tienda.
TELEFONO VARCHAR2(11), --Tel�fono de la tienda
CODIGOPOSTAL VARCHAR2(5) NOT NULL, --Codigo Postal donde se ubica la tienda
PROVINCIA VARCHAR2(5) NOT NULL --Provincia donde se ubica la tienda
);


CREATE TABLE STOCK( --Contendr�, para cada tienda, el n�mero de unidades disponibles de cada producto. La clave primaria est� formada por la concatenaci�n de los campos Codtienda y Codproducto.
CODTIENDA NUMBER(3) NOT NULL, --C�digo de la tienda.
CODPRODUCTO NUMBER(5) NOT NULL, --C�digo del producto
UNIDADES NUMBER(6) NOT NULL --Unidades de ese producto en esa tienda
);

ALTER TABLE STOCK ADD CONSTRAINT PK_STO --Clave primaria:(Codtienda,Codproducto)
    PRIMARY KEY(CODTIENDA, CODPRODUCTO);
ALTER TABLE STOCK ADD CONSTRAINT FK_CODTIENDA --Clave ajena, referencia a Codtienda de la tabla tienda.
    FOREIGN KEY (CODTIENDA) REFERENCES TIENDA(CODTIENDA);
ALTER TABLE STOCK ADD CONSTRAINT FK_CODPRODUCTO --Clave ajena, referencia a Codproducto de la tabla PRODUCTO.
    FOREIGN KEY (CODPRODUCTO) REFERENCES PRODUCTO(CODPRODUCTO);
ALTER TABLE STOCK ADD CONSTRAINT CK_UNIDADES --Mayor o igual a 0.
    CHECK (UNIDADES > 0);