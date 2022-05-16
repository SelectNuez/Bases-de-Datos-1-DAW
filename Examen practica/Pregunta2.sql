declare
    ant integer;
    porc integer;

    --Inicio el cursor
    cursor emp_cursor is 
    --Pillo los datos del id y la fecha de inicio del contrato de empleado
    select id_emp,f_inicio_contrato
    from empleado;
    --Creo el procedimiento en el que no necesito introducir datos
PROCEDURE subirSalario
IS
begin
    --Con un FOR llamado registro en el cursor de empleado
    for registro in emp_cursor loop
    --Calculo la antiguedad y la almaceno en ant 
    --Al ser integer solo tendre numeros enteros ademas de estar redondeado hacia abajo
    SELECT floor(months_between(SYSDATE, registro.f_inicio_contrato) /12) into ant FROM dual;
    --calculo el porcentaje
    porc := (TRUNC(ant/5)*7) + (TRUNC(ant/15)*10);
    --Ejecuto un update del salario con el porcentaje calculado en los ID del empleado
    --Como en cada vuelta del bucle da un ID, se van cambiando los salarios en los ID segun coincidan
    UPDATE salario set salario = (salario+((salario*porc)/100))where id_emp = registro.id_emp;

    end loop;
END;
begin
subirSalario ();
end;
/

