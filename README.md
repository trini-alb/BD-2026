# README.md — Trabajo Práctico ETL y Análisis de Datos Públicos (Argentina)

## Ingeniería en Sistemas de Información — Bases de Datos

### Docentes
- Ing. Gabriel Bruno
- Ing. Luciano Paruccia

### Comisión
- Comisión 1

### Integrantes
- Albarracín Trinidad — 15660
- Altamirano Mateo — 17041
- Anselmi Lara — 15746
- Barra Juan Patricio — 16616
- Caullo Mateo — 15747
- Llufriu Juan Ignacio — 16622
- Magallanes Agustin — 16045
- Mansilla Santiago — 15921

### Fecha de entrega
3 de Abril de 2026

---

# Trabajo Práctico: ETL y Análisis de Datos Públicos (Argentina)

## 1. Descripción del Proyecto

Este trabajo práctico tiene como objetivo implementar un flujo completo de procesamiento de datos mediante técnicas ETL (Extract, Transform, Load), utilizando datasets públicos de la República Argentina.

A lo largo del proyecto se desarrolló:

- Extracción de datos desde fuentes oficiales.
- Transformación y limpieza de información.
- Modelado relacional de base de datos.
- Carga automatizada en PostgreSQL.
- Consultas SQL de análisis de datos.
- Orquestación del entorno mediante Docker.

---

# 2. Objetivos

- Aplicar conceptos de modelado de bases de datos.
- Garantizar integridad referencial mediante PK y FK.
- Implementar procesos ETL reales.
- Utilizar tecnologías modernas de contenedorización.
- Generar consultas SQL de valor agregado.
- Construir un entorno replicable y documentado.

---

# 3. Datasets Utilizados

Los datasets fueron obtenidos desde el portal oficial de datos públicos de Argentina:

https://www.datos.gob.ar/dataset

## Categorías seleccionadas

- Ciencia y Tecnología
- Educación
- Economía y Finanzas

## Datasets utilizados

### Educación
- Datos Abiertos de la Secretaría de Educación
- Recursos e instalaciones educativas
- Archivo utilizado: `2021_caracteristicas_agregada.csv`

Fuente oficial:

https://www.argentina.gob.ar/educacion/evaluacion-e-informacion-educativa/datos-abiertos-de-la-secretaria-de-educacion

### Economía y Finanzas
- VAB por Cadenas y Provincias 2018
- VAB por Provincias 2018-2021

Fuente oficial:

https://www.argentina.gob.ar/economia/politicaeconomica/regionalysectorial/informesproductivos/datasets

---

# 4. Tecnologías Utilizadas

## Base de Datos
- PostgreSQL 18

## Administración
- pgAdmin 4

## Lenguaje de Programación
- Python 3

## Librerías
- Pandas

## Contenedorización
- Docker
- Docker Compose

## Herramientas Complementarias
- ChatGPT
- Gemini

---

# 5. Registro Analizado

## Registro temporal
- Cuarto trimestre del año 2021

## Registro geográfico
- República Argentina

---

# 6. Estructura del Proyecto

```bash
tp-etl-datos-publicos/
│
├── datasets/
│   ├── educacion.csv
│   ├── vab_provincias.csv
│   └── vab_cadenas.csv
│
├── scripts/
│   ├── limpieza.py
│   ├── 01_esquema.sql
│   └── 02_inserts.sql
│
├── docker-compose.yml
│
└── README.md
```

---

# 7. Modelado de Base de Datos

## Diseño Entidad-Relación

Se diseñó un esquema relacional normalizado para permitir:

- Integridad referencial.
- Consistencia de datos.
- Consultas eficientes.
- Relación entre datasets.

## Características implementadas

### Claves Primarias (PK)
Identificación única de registros.

### Claves Foráneas (FK)
Relación entre entidades y datasets.

### Tipos de datos
Definidos según:

- Naturaleza del dato.
- Precisión requerida.
- Operaciones posteriores.
- Compatibilidad relacional.

---

# 8. Proceso ETL

# 8.1 Extract (Extracción)

Los datasets fueron descargados manualmente desde los portales oficiales del gobierno argentino en formato CSV.

---

# 8.2 Transform (Transformación)

La etapa de transformación fue realizada con Python y Pandas.

## Tareas realizadas

### Limpieza de datos
- Eliminación de inconsistencias.
- Corrección de caracteres especiales.
- Normalización UTF-8.
- Tratamiento de valores nulos.

### Conversión de formatos
- Normalización de fechas.
- Conversión de tipos numéricos.
- Homogeneización de nombres de provincias.

### Despivotado estructural
Transformación de estructuras horizontales a modelos relacionales verticales.

### Normalización relacional
Separación de entidades para evitar redundancia.

---

# 8.3 Load (Carga)

La carga fue realizada sobre PostgreSQL utilizando tablas temporales y scripts SQL automatizados.

## Flujo de carga

1. Importación de CSVs.
2. Inserción en tablas temporales.
3. Transformación final.
4. Inserción en tablas definitivas.
5. Eliminación de tablas temporales.

---

# 9. Configuración del Entorno

# 9.1 Requisitos Previos

Instalar:

- Docker Desktop
- Docker Compose

Sitios oficiales:

https://www.docker.com/products/docker-desktop/

https://www.postgresql.org/

https://www.pgadmin.org/

---

# 9.2 Ejecución del Proyecto

## Clonar el repositorio

```bash
git clone https://github.com/usuario/tp-etl-datos-publicos.git
```

## Ingresar al proyecto

```bash
cd tp-etl-datos-publicos
```

## Levantar contenedores

```bash
docker compose down -v
docker compose up -d
```

Docker descargará automáticamente:

- PostgreSQL 18
- pgAdmin 4

Y ejecutará secuencialmente:

- `01_esquema.sql`
- `02_inserts.sql`

---

# 10. Acceso a pgAdmin

Abrir en navegador:

```txt
http://localhost:5050
```

## Credenciales

```txt
Email: grupo@utn.edu.ar
Contraseña: admin
```

## Registro del servidor

1. Click derecho en “Servers”.
2. Seleccionar “Register”.
3. Seleccionar “Server”.
4. Completar:
   - Host
   - Puerto
   - Usuario
   - Contraseña

---

# 11. Transformaciones Implementadas

## Limpieza y Mapeo
Corrección de inconsistencias de nombres de provincias:

Ejemplo:
- “Capital Federal”
- “Ciudad de Buenos Aires”

Ambas vinculadas mediante `id_provincia`.

---

## Despivotado (Melt)
Conversión de datasets horizontales a estructuras verticales relacionales.

---

## Generación automática
Creación dinámica del archivo:

```txt
02_inserts.sql
```

---

# 12. Consultas SQL de Valor Agregado

## Query 1 — Escuelas con internet gratuito o pago

```sql
SELECT provincia,
       COUNT(*) AS cantidad_escuelas
FROM escuelas
WHERE internet = 'SI'
GROUP BY provincia
ORDER BY cantidad_escuelas DESC;
```

---

## Query 2 — Promedio de escuelas con biblioteca e internet por provincia

```sql
SELECT p.nombre_provincia,
       AVG(e.cantidad_escuelas) AS promedio_escuelas,
       SUM(v.vab_total) AS vab_total
FROM escuelas e
JOIN provincias p
    ON e.id_provincia = p.id_provincia
JOIN vab_provincias v
    ON p.id_provincia = v.id_provincia
GROUP BY p.nombre_provincia
ORDER BY vab_total DESC;
```

---

## Query 3 — Cantidad de escuelas vs infraestructura reportada

```sql
SELECT p.nombre_provincia,
       COUNT(DISTINCT e.id_escuela) AS escuelas,
       COUNT(DISTINCT i.id_infraestructura) AS infraestructura
FROM escuelas e
JOIN infraestructura i
    ON e.id_departamento = i.id_departamento
JOIN provincias p
    ON e.id_provincia = p.id_provincia
GROUP BY p.nombre_provincia;
```

---

# 13. Resultados Obtenidos

El proyecto permitió:

- Integrar datasets públicos reales.
- Aplicar procesos ETL completos.
- Implementar un entorno reproducible.
- Utilizar SQL avanzado para análisis de datos.
- Garantizar integridad referencial.
- Automatizar la carga de información.

---

# 14. Competencias y Resultados de Aprendizaje

| Tipo | Código | Competencia / RA |
|---|---|---|
| Específica | CE 1.1 | Especificar, proyectar y desarrollar sistemas de información |
| Genérica | CG 7 | Comunicarse con efectividad |
| Genérica | CG 9 | Aprender en forma continua y autónoma |
| RA | RA 1 | Modelado y almacenamiento de datos |
| RA | RA 5 | Uso de herramientas tecnológicas |

---

# 15. Conclusión

Este trabajo permitió experimentar el ciclo completo de procesamiento de datos mediante técnicas ETL aplicadas a datasets reales del Estado Argentino.

La utilización de PostgreSQL, Docker y Python con Pandas permitió construir un entorno moderno, automatizado y replicable, mientras que el modelado relacional garantizó coherencia e integridad en la información almacenada.

Finalmente, las consultas SQL demostraron cómo transformar datos crudos en información útil para análisis y toma de decisiones.

---

# 16. Autores

Trabajo realizado para la cátedra Bases de Datos — Ingeniería en Sistemas de Información.

