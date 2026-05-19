import pandas as pd
import numpy as np

def generar_sql():
    # 1. Cargar los CSVs
    df_vab = pd.read_csv("vab_por_provincias_2018_2021_limpio.csv")
    df_infra = pd.read_csv("dataset_limpio_2021_caracteristicas.csv")
    df_evo = pd.read_csv("cant-esteducativos.csv")

    sql_lines = []
    
    # 2. Diccionario Maestro de Provincias (Código INDEC)
    provincias_dict = {
        2: 'Ciudad de Buenos Aires', 6: 'Buenos Aires', 10: 'Catamarca', 14: 'Córdoba',
        18: 'Corrientes', 22: 'Chaco', 26: 'Chubut', 30: 'Entre Ríos', 34: 'Formosa',
        38: 'Jujuy', 42: 'La Pampa', 46: 'La Rioja', 50: 'Mendoza', 54: 'Misiones',
        58: 'Neuquén', 62: 'Río Negro', 66: 'Salta', 70: 'San Juan', 74: 'San Luis',
        78: 'Santa Cruz', 82: 'Santa Fe', 86: 'Santiago del Estero', 90: 'Tucumán', 94: 'Tierra del Fuego'
    }

    # -- INSERTS PARA PROVINCIAS --
    sql_lines.append("-- Insertar Provincias")
    for id_prov, nombre in provincias_dict.items():
        sql_lines.append(f"INSERT INTO provincias (id_provincia, nombre) VALUES ({id_prov}, '{nombre}');")

    # -- INSERTS PARA DEPARTAMENTOS --
    # Extraemos combinaciones únicas de provincia y departamento del dataset de infraestructura
    sql_lines.append("\n-- Insertar Departamentos")
    deptos_unicos = df_infra[['provincia', 'departamento']].drop_duplicates().reset_index(drop=True)
    
    # Mapeo inverso para buscar el ID de la provincia por su nombre
    inv_prov_dict = {v: k for k, v in provincias_dict.items()}
    inv_prov_dict['Capital Federal'] = 2 # Por si viene con ese nombre
    
    depto_id_map = {} # Guardamos el ID generado para usarlo después
    
    for index, row in deptos_unicos.iterrows():
        id_depto = index + 1
        nombre_prov = row['provincia'].strip()
        nombre_depto = str(row['departamento']).replace("'", "''") # Escapar comillas simples
        id_prov = inv_prov_dict.get(nombre_prov)
        
        if id_prov:
            sql_lines.append(f"INSERT INTO departamentos (id_departamento, id_provincia, nombre) VALUES ({id_depto}, {id_prov}, '{nombre_depto}');")
            # Guardamos la tupla (provincia, depto) con su ID para la tabla de infraestructura
            depto_id_map[(nombre_prov, row['departamento'])] = id_depto

    # -- INSERTS PARA VAB PROVINCIAL --
    sql_lines.append("\n-- Insertar VAB")
    for _, row in df_vab.iterrows():
        id_prov = row['alcance_id']
        anio = row['año']
        indicador = str(row['indicador'])
        # Limpiar el valor (sacar puntos de miles)
        valor_str = str(row['valor']).replace('.', '').replace(',', '.')
        
        if id_prov in provincias_dict:
            sql_lines.append(f"INSERT INTO vab_provincial (id_provincia, anio, indicador, valor_miles_pesos) VALUES ({id_prov}, {anio}, '{indicador}', {valor_str});")

    # -- INSERTS PARA ESCUELAS EVOLUCION (Despivotando / Melting) --
    sql_lines.append("\n-- Insertar Evolucion Escuelas")
    # Derretimos el dataset para que las columnas de provincias pasen a filas
    df_evo_melt = df_evo.melt(id_vars=['indice_tiempo'], var_name='col_provincia', value_name='cantidad')
    # Filtramos la columna 'arg' que es el total nacional
    df_evo_melt = df_evo_melt[df_evo_melt['col_provincia'] != 'cant_esteducativos_arg']
    
    for _, row in df_evo_melt.iterrows():
        fecha = row['indice_tiempo']
        cant = row['cantidad']
        # Extraemos el ID de la provincia del nombre de la columna (ej: 'cant_esteducativos_6' -> 6)
        id_prov = int(row['col_provincia'].split('_')[-1])
        
        sql_lines.append(f"INSERT INTO escuelas_evolucion (id_provincia, fecha, cantidad_escuelas) VALUES ({id_prov}, '{fecha}', {cant});")

    # -- INSERTS PARA INFRAESTRUCTURA --
    sql_lines.append("\n-- Insertar Infraestructura")
    df_infra = df_infra.fillna(0) # Reemplazar nulos con 0 para los contadores
    
    for _, row in df_infra.iterrows():
        nombre_prov = row['provincia'].strip()
        nombre_depto = row['departamento']
        id_depto = depto_id_map.get((nombre_prov, nombre_depto))
        
        if id_depto:
            sector = row['sector']
            ambito = row['ambito']
            # Si en el CSV original hay algún nulo en ambito, lo forzamos a Urbano u omitimos
            if sector not in ['Estatal', 'Privado']: sector = 'Estatal'
            if ambito not in ['Rural', 'Urbano']: ambito = 'Urbano'
            
            cant_loc = int(row['Localizacion'])
            int_gratis = int(row['InternetTipodeservicioGratuito'])
            int_pago = int(row['InternetTipodeservicioPago'])
            biblio = int(row['BibliotecaDisponedealmenosunaSi'])
            
            sql_lines.append(f"INSERT INTO escuelas_infraestructura (id_departamento, sector, ambito, cantidad_localizaciones, internet_gratuito, internet_pago, escuelas_con_biblioteca) VALUES ({id_depto}, '{sector}', '{ambito}', {cant_loc}, {int_gratis}, {int_pago}, {biblio});")

    # Guardar todo en un archivo SQL
    with open('02_inserts.sql', 'w', encoding='utf-8') as f:
        f.write('\n'.join(sql_lines))
    
    print("¡Archivo '02_inserts.sql' generado con éxito!")

generar_sql()