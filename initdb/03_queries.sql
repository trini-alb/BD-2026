--Query 1: Top 5 de departamentos con mejor conectividad a Internet (Urbano vs Rural)
SELECT 
    p.nombre AS provincia,
    d.nombre AS departamento,
    ei.ambito,
    SUM(ei.internet_gratuito + ei.internet_pago) AS total_escuelas_con_internet,
    SUM(ei.cantidad_localizaciones) AS total_localizaciones
FROM escuelas_infraestructura ei
JOIN departamentos d ON ei.id_departamento = d.id_departamento
JOIN provincias p ON d.id_provincia = p.id_provincia
GROUP BY p.nombre, d.nombre, ei.ambito
ORDER BY total_escuelas_con_internet DESC
LIMIT 5;

--Query 2: Relación entre la Economía (VAB) y la Infraestructura Educativa
SELECT 
    p.nombre AS provincia,
    v.anio,
    v.valor_miles_pesos AS vab_valor,
    COUNT(DISTINCT d.id_departamento) AS cantidad_departamentos,
    SUM(ei.escuelas_con_biblioteca) AS total_bibliotecas,
    SUM(ei.internet_gratuito) AS total_escuelas_internet_gratis
FROM provincias p
JOIN vab_provincial v ON p.id_provincia = v.id_provincia
JOIN departamentos d ON p.id_provincia = d.id_provincia
JOIN escuelas_infraestructura ei ON d.id_departamento = ei.id_departamento
WHERE v.anio = 2024 -- Podés cambiar el año según tus datos
GROUP BY p.nombre, v.anio, v.valor_miles_pesos
ORDER BY v.valor_miles_pesos DESC;

--Query 3: Evolución histórica de escuelas vs. Infraestructura Actual
SELECT 
    p.nombre AS provincia,
    MAX(ee.fecha) AS ultima_fecha_registro,
    MAX(ee.cantidad_escuelas) AS cantidad_escuelas_historico,
    SUM(ei.cantidad_localizaciones) AS localizaciones_actuales_totales,
    SUM(CASE WHEN ei.sector = 'Estatal' THEN ei.cantidad_localizaciones ELSE 0 END) AS localizaciones_estatales,
    SUM(CASE WHEN ei.sector = 'Privado' THEN ei.cantidad_localizaciones ELSE 0 END) AS localizaciones_privadas
FROM provincias p
JOIN escuelas_evolucion ee ON p.id_provincia = ee.id_provincia
JOIN departamentos d ON p.id_provincia = d.id_provincia
JOIN escuelas_infraestructura ei ON d.id_departamento = ei.id_departamento
GROUP BY p.nombre
ORDER BY localizaciones_actuales_totales DESC;