import pandas as pd

df_edu = pd.read_csv('dataset_limpio_2021_caracteristicas.csv', encoding='utf-8') 
df_vab = pd.read_csv('vab_por_provincias_2018_2021_limpio.csv', encoding='utf-8')
df_ind = pd.read_csv('indicadores-provinciales.csv', encoding='utf-8')
df_esc = pd.read_csv('cant-esteducativos.csv', encoding='utf-8')

diccionario_provincias = {
    'CABA': 'Ciudad Autónoma de Buenos Aires',
    'Capital Federal': 'Ciudad Autónoma de Buenos Aires',
    'Tierra del Fuego, Antártida e Islas del Atlántico Sur': 'Tierra del Fuego',
    'Tierra del fuego': 'Tierra del Fuego',
    'Córdoba': 'Cordoba', 
    'Tucumán': 'Tucuman'
}


df_edu['nombre_provincia'] = df_edu['nombre_provincia'].str.strip().replace(diccionario_provincias)
df_vab['nombre_provincia'] = df_vab['nombre_provincia'].str.strip().replace(diccionario_provincias)
df_ind['nombre_provincia'] = df_ind['nombre_provincia'].str.strip().replace(diccionario_provincias)
df_esc['nombre_provincia'] = df_esc['nombre_provincia'].str.strip().replace(diccionario_provincias)



print("Limpiando datos de Educación...")

df_edu['tiene_internet'] = df_edu['tiene_internet'].fillna('NO')


df_edu['tiene_internet'] = df_edu['tiene_internet'].apply(lambda x: True if str(x).strip().upper() == 'SI' else False)


print("Limpiando datos de Economía...")

if df_vab['valor_vab'].dtype == 'O':
    df_vab['valor_vab'] = df_vab['valor_vab'].str.replace('.', '', regex=False).str.replace(',', '.', regex=False).astype(float)

df_vab = df_vab.dropna(subset=['valor_vab'])


print("Exportando archivos limpios...")

df_edu.to_csv('educacion_LIMPIO.csv', index=False, encoding='utf-8')
df_vab.to_csv('vab_LIMPIO.csv', index=False, encoding='utf-8')
df_ind.to_csv('indicadores_LIMPIO.csv', index=False, encoding='utf-8')
df_esc.to_csv('establecimientos_LIMPIO.csv', index=False, encoding='utf-8')



todas_las_provincias = pd.concat([
    df_edu['nombre_provincia'], 
    df_vab['nombre_provincia'], 
    df_ind['nombre_provincia'], 
    df_esc['nombre_provincia']
]).dropna().unique()


df_provincias = pd.DataFrame({'nombre': todas_las_provincias})
df_provincias['id_provincia'] = range(1, len(df_provincias) + 1)

print("Reemplazando nombres por IDs en los datasets...")

df_edu = df_edu.merge(df_provincias, left_on='nombre_provincia', right_on='nombre', how='left')

df_edu = df_edu.drop(columns=['nombre_provincia', 'nombre']) 

df_vab = df_vab.merge(df_provincias, left_on='nombre_provincia', right_on='nombre', how='left')
df_vab = df_vab.drop(columns=['nombre_provincia', 'nombre'])

df_ind = df_ind.merge(df_provincias, left_on='nombre_provincia', right_on='nombre', how='left')
df_ind = df_ind.drop(columns=['nombre_provincia', 'nombre'])
df_esc = df_esc.merge(df_provincias, left_on='nombre_provincia', right_on='nombre', how='left')
df_esc = df_esc.drop(columns=['nombre_provincia', 'nombre'])

df_provincias.to_csv('provincias_LIMPIO.csv', index=False, encoding='utf-8')

df_edu.to_csv('educacion_LIMPIO.csv', index=False, encoding='utf-8')
df_vab.to_csv('vab_LIMPIO.csv', index=False, encoding='utf-8')
df_ind.to_csv('indicadores_LIMPIO.csv', index=False, encoding='utf-8')
df_esc.to_csv('establecimientos_LIMPIO.csv', index=False, encoding='utf-8')

print("¡Transformación exitosa! Listos para SQL.")