import mysql.connector
from datetime import datetime
import re  # Para buscar el nombre de la tabla en el error

# Configuración de la conexión a la base de datos
config = {
    "host": "localhost",
    "user": "root",
    "password": "Sql789",
    "database": "bd_sct"
}

try:
    # Usar 'with' para manejar la conexión automáticamente
    with mysql.connector.connect(**config) as conn:
        with conn.cursor() as cursor:
            # Consulta SQL para insertar un usuario con error en la cédula (por ejemplo, letras en lugar de números)
            sql = """
            INSERT INTO tbl_usuarios (id_empresa, cedula, nombre_uno, nombre_dos, apellido_uno, apellido_dos, id_genero, e_mail, telefono, usuario, password_hash)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            valores = (1, "1234567890", "Juan", "Carlos", "Pérez", "Mora", "1", "juan@example.com", "0939023239", "juanjuan", "hashed_password")

            cursor.execute(sql, valores)
            conn.commit()
            print("Usuario insertado correctamente.")

except mysql.connector.Error as err:

    # Obtener información sobre la fecha y hora actual y el usuario actual
    fecha_actual = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    usuario_actual = config["user"]
    # Inicializamos la variable para almacenar el nombre de la tabla afectada
    tabla_encontrada = None

    # Intentar extraer el nombre de la tabla desde el mensaje de error (para errores comunes)
    # Se usa una expresión regular para buscar un patrón del tipo: "Table 'nombre_base_datos.nombre_tabla'"
    match = re.search(r"Table '.*\.(\w+)'", str(err.msg))
    if match:
        # Si se encuentra el nombre de la tabla, lo almacenamos en la variable
        tabla_encontrada = match.group(1)

    # Verificar si el error es un CHECK constraint (3819)
    if err.errno == 3819:
        restriccion_match = re.search(r"Check constraint '(\w+)'", str(err.msg))
        if restriccion_match:
            nombre_restriccion = restriccion_match.group(1) # Guardamos el nombre de la restricción
            try:
                # Consultar la tabla asociada a la restricción en INFORMATION_SCHEMA
                # Realizamos una nueva conexión a la base de datos para buscar la tabla asociada a la restricción
                with mysql.connector.connect(**config) as conn2:
                    with conn2.cursor() as cursor2:
                        # Consultamos en INFORMATION_SCHEMA.TABLE_CONSTRAINTS para obtener la tabla afectada
                        cursor2.execute("""
                            SELECT TABLE_NAME 
                            FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
                            WHERE CONSTRAINT_NAME = %s AND TABLE_SCHEMA = %s
                        """, (nombre_restriccion, config["database"]))
                        # Obtenemos el resultado de la consulta
                        resultado = cursor2.fetchone()
                        if resultado:
                            tabla_encontrada = resultado[0] # Guardamos el nombre de la tabla
            except mysql.connector.Error as sub_err:
                # Si ocurre un error al consultar INFORMATION_SCHEMA, lo mostramos en consola
                print(f"⚠️ Error al buscar la tabla asociada a la restricción: {sub_err}")

    # Construimos el mensaje indicando la tabla afectada o mostrando un mensaje de error si no se pudo determinar
    tabla_msg = f"Tabla afectada: {tabla_encontrada}" if tabla_encontrada else "No se pudo determinar la tabla."

    print(f'''
        Fecha y Hora: {fecha_actual}
        Usuario: {usuario_actual}
        {tabla_msg}
        Error: {err}''')
