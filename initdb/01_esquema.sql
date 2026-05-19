-- 1. Creación de los tipos ENUM
CREATE TYPE tipo_sector AS ENUM ('Estatal', 'Privado');
CREATE TYPE tipo_ambito AS ENUM ('Rural', 'Urbano');

-- 2. Tabla Maestra de Provincias
CREATE TABLE provincias (
    id_provincia INT PRIMARY KEY, 
    nombre VARCHAR(100) NOT NULL
);

-- 3. Tabla Nueva: Departamentos (Normalización)
CREATE TABLE departamentos (
    id_departamento SERIAL PRIMARY KEY,
    id_provincia INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    CONSTRAINT fk_prov_depto FOREIGN KEY (id_provincia) REFERENCES provincias(id_provincia)
);

-- 4. Tabla Economía: VAB Provincial
CREATE TABLE vab_provincial (
    id_vab SERIAL PRIMARY KEY,
    id_provincia INT NOT NULL,
    anio INT NOT NULL,
    indicador VARCHAR(50),
    valor_miles_pesos NUMERIC(20, 2), 
    CONSTRAINT fk_prov_vab FOREIGN KEY (id_provincia) REFERENCES provincias(id_provincia)
);

-- 5. Tabla Educación: Cantidad histórica de escuelas
CREATE TABLE escuelas_evolucion (
    id_evolucion SERIAL PRIMARY KEY,
    id_provincia INT NOT NULL,
    fecha DATE NOT NULL,
    cantidad_escuelas INT NOT NULL,
    CONSTRAINT fk_prov_escuelas FOREIGN KEY (id_provincia) REFERENCES provincias(id_provincia)
);

-- 6. Tabla Educación: Infraestructura y Características (Optimizada)
CREATE TABLE escuelas_infraestructura (
    id_infraestructura SERIAL PRIMARY KEY,
    --id_provincia INT NOT NULL,
    id_departamento INT NOT NULL, -- Nueva FK
    sector tipo_sector,           -- Usando el ENUM
    ambito tipo_ambito,           -- Usando el ENUM
    cantidad_localizaciones INT,
    internet_gratuito INT,   
    internet_pago INT,
    escuelas_con_biblioteca INT,  -- Nombre aclarado
    --CONSTRAINT fk_prov_infra FOREIGN KEY (id_provincia) REFERENCES provincias(id_provincia),
    CONSTRAINT fk_depto_infra FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);