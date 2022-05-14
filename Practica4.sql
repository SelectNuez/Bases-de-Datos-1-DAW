SELECT Nombre,Localidad
FROM Empleado
WHERE localidad LIKE (SELECT localidad FROM centro)




    

