-- ¿Cuántos usuarios nuevos hubo en total en el mes de enero de 2023?

SELECT
	SUM(Usuarios_Nuevos) AS Total_Usuarios_Nuevos
FROM dbo.GA_Tabla_Resumen
WHERE
	Fecha_Corta >= '2023-01-01' AND
	Fecha_Corta < '2023-02-01';


-- ¿Cuántos usuarios nuevos por programa hubo en el mes de febrero de 2023?

SELECT
	Id_Programa AS Programa,
	SUM(Usuarios_Nuevos) AS Total_Usuarios_Nuevos
FROM dbo.GA_Tabla_Resumen
WHERE
	Fecha_Corta >= '2023-02-01' AND
	Fecha_Corta < '2023-03-01'
GROUP BY Id_Programa
ORDER BY Total_Usuarios_Nuevos DESC;


-- ¿Cuál fue la página más visitada en el mes de marzo 2023?

SELECT TOP 1
	Página,
	SUM(Número_de_Visitas_a_Páginas) As Número_Visitas
FROM dbo.GA_Visitas_Paginas
WHERE
	Fecha_Corta >= '2023-03-01' AND
	Fecha_Corta < '2023-04-01'
GROUP BY Página
ORDER BY Número_Visitas DESC;


-- Construye una tabla que muestre por programa cuál fue el tiempo promedio de visita
-- a las páginas y cuántos usuarios nuevos hubieron en el mes de febrero 2023.

SELECT
	vp.Programa,
	AVG(vp.Tiempo_Promedio_Página) AS Tiempo_Promedio_Visitas_Paginas,
	SUM(tr.Usuarios_Nuevos) AS Total_Usuarios_Nuevos
FROM dbo.GA_Visitas_Paginas vp
LEFT JOIN dbo.GA_Tabla_Resumen tr
	ON vp.Programa = tr.Id_Programa
	AND vp.Fecha_Corta = tr.Fecha_Corta
WHERE
	vp.Fecha_Corta >= '2023-02-01' AND
	vp.Fecha_Corta < '2023-03-01'
GROUP BY
	vp.Programa;


-- ¿Del programa con mayor tiempo promedio de visita en marzo del 2023,
-- qué navegador se ocupa más para conectarse a él?

WITH Programa_Mayor_Tiempo_Visita AS (
	SELECT TOP 1
		Programa,
		AVG(Tiempo_Promedio_Página) AS Tiempo_Promedio
	FROM dbo.GA_Visitas_Paginas
	WHERE
		Fecha_Corta >= '2023-03-01' AND
		Fecha_Corta < '2023-04-01'
	GROUP BY Programa
	ORDER BY Tiempo_Promedio DESC
)
SELECT
	d.Navegador,
	SUM(d.Sesiones) AS Total_Sesiones
FROM dbo.GA_Tipo_Dispositivo d
INNER JOIN Programa_Mayor_Tiempo_Visita p
	ON d.Programa = p.Programa
WHERE
	Fecha_Corta >= '2023-03-01' AND
	Fecha_Corta < '2023-04-01'
GROUP BY
	d.Navegador
ORDER BY
	Total_Sesiones DESC;