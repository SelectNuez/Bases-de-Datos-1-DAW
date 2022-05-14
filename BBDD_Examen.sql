CREATE TABLE EMP_DPTO 
(
  ID_EMP INT PRIMARY KEY
, ID_DPTO INT 
, F_INICIO DATE 
, F_FIN DATE
);


CREATE TABLE EMPLEADO(
id_emp INT PRIMARY KEY
,nombre varchar2(14),
ape1 varchar2(25),
ape2 varchar2(25),
genero CHAR,
f_nac date,
f_inicio_contrato date,
f_fin_contrato date
);

CREATE TABLE DEPARTAMENTO 
(
  ID_DPTO INT PRIMARY KEY
, NOMBRE_DPTO VARCHAR2(20)
);

CREATE TABLE SALARIO(
id_emp int primary key,
f_inicio date,
f_fin date,
salario number(6,2)
);

CREATE TABLE Cargo(
id_emp int primary key,
f_inicio date,
f_fin date,
cargo varchar2(50)
);
