
/*
Ejercicio 1.
Crear un procedimiento que permita cambiar a todos los agentes de una familia determinada (familia origen) a otra familia (familia destino).

El procedimiento tendrá la siguiente cabecera CambiarAgentesFamilia( id_FamiliaOrigen, id_FamiliaDestino),  
donde cada uno de los argumentos corresponde a un identificador de Familia. 
Cambiará la columna  Identificador de Familia de todos los agentes, de la tabla AGENTES, 
que pertenecen a la Familia con código id_FamiliaOrigen por el código id_FamiliaDestino

Previamente comprobará que ambas familias existen y que no son iguales.

Para la comprobación de la existencia de las familias se puede utilizar un cursor variable, 
o contar el número de filas y en caso de que no exista, 
se visualizará el mensaje correspondiente mediante una excepción del tipo RAISE_APPLICATION_ERROR.
También se mostrará un mensaje en caso de que ambos argumentos tengan el mismo valor.         

El procedimiento visualizará  el mensaje 
"Se han trasladado XXX agentes de la familia  XXXXXX a la familia ZZZZZZ" 
donde XXX es el número de agentes que se han cambiado de familia, XXXXXX es el nombre de la familia origen 
y ZZZZZZ es el nombre de la familia destino.
*/

--------------------------------------------------------------------------------
--Necestamos habilitar la salida de bloques para el DBMS con las variables
SET SERVEROUTPUT ON

--Declaramos todas las variables
declare
id_FamiliaOrigen familias.identificador%TYPE;
id_FamiliaDestino familias.identificador%TYPE;
nFamiliares familias.identificador%TYPE;
d_comprobar boolean;
--Declaramos las excepciones
fam_igual Exception;
fam_noEx Exception;

--Creo la funcion comprobar para poder llamarla para comprobar su valided
function comprobar (id_Familia familias.identificador%TYPE)
return boolean is
    existe boolean;
    fam number;
    
    begin
    existe := false;
    select count(*) into fam from Familias where familias.identificador = id_Familia ;
    IF (fam > 0)
    THEN existe := true; 
    end if;

    return existe;

END;

-- Creo la funcion familiares de manera que me dira, introduciendole el id_Familia el numero de familiares que tiene
function familiares (id_Familia familias.identificador%TYPE)
return number is
    fam number;    
    begin
    select count (*) into fam from AGENTES where agentes.familia = id_Familia ;
    return fam;
END;

--Creo el procedimiento en el que se actualizan los agentes
PROCEDURE CambiarAgentesFamilia( id_FamiliaOrigen familias.identificador%TYPE, id_FamiliaDestino familias.identificador%TYPE)
IS
begin
update agentes SET familia = id_FamiliaDestino where agentes.familia = id_FamiliaOrigen;
end;


begin
--Iniciamos las variables solicitandolas
id_FamiliaOrigen := &FamiliaOrigen;
id_FamiliaDestino := &FamiliaDestino;

--Si una de las dos familias no existe lanzamos la excepcion fam_noEx que nos indicara que no existe una familia
if ((comprobar(id_FamiliaOrigen) = false) OR (comprobar(id_FamiliaDestino) = false))
    then
    raise fam_noEx;
--Si las familias existen 
else 
--Si las familias son iguales lanzamos la excepcion fam_igual de manera que nos indicara que las familias son iguales
    IF(id_FamiliaOrigen = id_FamiliaDestino) 
            then 
            raise fam_igual;
        ELSE
        --En caso de que no sean iguales en la variable nFamiliares guardo la cantidad de familiares llamando a la funcion
        nFamiliares := familiares(id_FamiliaOrigen);
        --Llamo al procecimiento para que se efectue el cambio de familia, importante hacer esto despues de actualizar el numero de familiares
        CambiarAgentesFamilia(id_FamiliaOrigen,id_FamiliaDestino);
        dbms_output.put_line('Se han trasladado ' || nFamiliares || ' agentes de la familia ' || id_FamiliaOrigen || ' a la familia ' || id_FamiliaDestino);
     End if;
end if;

exception
--Declaro las excepciones 
            when fam_igual then
                RAISE_APPLICATION_ERROR(-20999, 'Las familias introducidas son identicas');

            when fam_noEx then
                RAISE_APPLICATION_ERROR(-20998, 'Alguna de las familias no existe');

            when others then
                RAISE_APPLICATION_ERROR(-20997, 'Ha ocurrido un error, por favor, vuelva a intentarlo mas tarde');

end;
--------------------------------------------------------------------------------

/*
Ejercicio 2.

Algunas de las restricciones implementadas con el disparador se pueden incorporar a la definición del esquema de la tabla
utilizando el Lenguaje de Definición de Datos (Check,Unique,..). Identifica cuáles son y con qué tipo de restricciones las implementarías.

Se podrian realizar dos restricciones mediante DDL:
La habilidad de un Agente (entre 0 y 9 ambas inclusive) --> alter table agentes add constraint res_habilidad_agentes check(habilidad >= 0)
Y dado que su tipo es number(1,0)  nunca podra ser mayor que 9 al solo poder tener 1 digito
La categoria de un agente (0,1 o 2) --> alter table agentes add constraint res_categoria_agentes check(categoria between 0 and 3);

*/


Create or replace Trigger res_agentes
Before insert or Update ON Agentes
For Each row
declare
leng_clave Exception;
leng_habil Exception;
cat_age Exception;
ex_cat2 Exception;
ex_cat1 Exception;
ex_uniq Exception;

begin
--La longitud de la clave de un agente no puede ser inferior a 6.
    if(LENGTH(:new.clave) < 6)
        then raise leng_clave;
    end if;
--La habilidad de un agente debe estar comprendida entre 0 y 9 (ambos inclusive).
    if(:new.habilidad < 0 AND :new.habilidad > 9)
        then raise leng_habil;
    end if;
--La categoría de un agente sólo puede ser igual a 0, 1 o 2.
    if(:new.categoria < 0 OR :new.categoria > 2)
        then raise cat_age;
    end if;
--Si un agente tiene categoría 2 no puede pertenecer a ninguna familia y debe pertenecer a una oficina.  
    if(:new.categoria = 2 AND (:new.familia is not null OR :new.oficina is null))
        then raise ex_cat2;
    end if;
--Si un agente tiene categoría 1 no puede pertenecer a ninguna oficina y debe pertenecer  a una familia.  
    if(:new.categoria = 1 AND (:new.oficina is not null OR :new.familia is null))
        then raise ex_cat1;
    end if;
--Todos los agentes deben pertenecer  a una oficina o a una familia pero nunca a ambas a la vez.
    if((:new.oficina is not null) AND (:new.familia is not null))
        then raise ex_uniq;
    end if;

exception
    when leng_clave then
    RAISE_APPLICATION_ERROR(-20011, 'La longitud de la clave de un agente no puede ser inferior a 6');
    
    when leng_habil then
    RAISE_APPLICATION_ERROR(-20012, '-La habilidad de un agente debe estar comprendida entre 0 y 9 (ambos inclusive)');  --Tiene una restriccion de un digito
    
    when cat_age then
    RAISE_APPLICATION_ERROR(-20013, 'La categoría de un agente sólo puede ser igual a 0, 1 o 2');
    
    when ex_cat2 then
    RAISE_APPLICATION_ERROR(-20014, 'Si un agente tiene categoría 2 no puede pertenecer a ninguna familia y debe pertenecer a una oficina');

    when ex_cat1 then
    RAISE_APPLICATION_ERROR(-20015, 'Si un agente tiene categoría 1 no puede pertenecer a ninguna oficina y debe pertenecer  a una familia');
    
    when ex_uniq then
    RAISE_APPLICATION_ERROR(-20016, 'Todos los agentes deben pertenecer  a una oficina o a una familia pero nunca a ambas a la vez.');   
       
    when others then
    RAISE_APPLICATION_ERROR(-21000, 'Ha surgido un error desconocido');
end res_agentes;
/

/*
Valores de prueba
INSERT INTO "C##AGENCIA"."AGENTES" (IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA,FAMILIA,oficina) VALUES ('112233', 'Jorge Martin', '111', '123456', '5', '2',null,'3');

DELETE FROM "C##AGENCIA"."AGENTES" WHERE NOMBRE = 'Jorge Martin';
*/











