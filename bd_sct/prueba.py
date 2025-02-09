import mysql.connector      #Para conectarse a la base de datos MySQL.
import tkinter as tk
from tkinter import ttk

# ===== CONFIGURACIÓN DE LA BASE DE DATOS =====
# Diccionario que contiene los parámetros de conexión a la base de datos MySQL.
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "Sql789",
    "database": "bd_sct"
}

# ===== FUNCIÓN PARA CARGAR PAISES =====
def obtener_paises():
    conexion = mysql.connector.connect(**DB_CONFIG)
    cursor = conexion.cursor()
    cursor.execute("SELECT id_pais, nombre_pais FROM tbl_paises ORDER BY nombre_pais")
    paises = cursor.fetchall()
    conexion.close()
    return paises

# ===== FUNCIÓN PARA CARGAR REGIONES SEGÚN PAÍS =====
def obtener_regiones(id_pais):
    conexion = mysql.connector.connect(**DB_CONFIG)
    cursor = conexion.cursor()
    cursor.execute("""
        SELECT r.id_region, r.nombre_region FROM tbl_paises_regiones pr
        JOIN tbl_regiones r ON pr.id_region = r.id_region
        WHERE pr.id_pais = %s ORDER BY r.nombre_region
    """, (id_pais,))
    regiones = cursor.fetchall()
    conexion.close()
    return regiones

# ===== FUNCIÓN PARA CARGAR PROVINCIAS SEGÚN REGIÓN =====
def obtener_provincias(id_region):
    conexion = mysql.connector.connect(**DB_CONFIG)
    cursor = conexion.cursor()
    cursor.execute("""
        SELECT id_provincia, nombre_provincia FROM tbl_provincias
        WHERE id_region = %s ORDER BY nombre_provincia
    """, (id_region,))
    provincias = cursor.fetchall()
    conexion.close()
    return provincias

# ===== FUNCIÓN PARA CARGAR CIUDADES SEGÚN PROVINCIA =====
def obtener_ciudades(id_provincia):
    conexion = mysql.connector.connect(**DB_CONFIG)
    cursor = conexion.cursor()
    cursor.execute("""
        SELECT id_ciudad, nombre_ciudad FROM tbl_ciudades
        WHERE id_provincia = %s ORDER BY nombre_ciudad
    """, (id_provincia,))
    ciudades = cursor.fetchall()
    conexion.close()
    return ciudades

# ===== EVENTO PARA ACTUALIZAR REGIONES =====
def actualizar_regiones(event):
    seleccion = combo_paises.current()              #devuelve el índice de la opción seleccionada en el ComboBox de países. Si no hay ninguna selección, devuelve -1.
    if seleccion != -1:                             #Si seleccion es diferente de -1, significa que el usuario ha seleccionado un país. Si seleccion es -1, no se ejecuta el código dentro del if.
        id_pais = lista_paises[seleccion][0]
        global lista_regiones
        lista_regiones = obtener_regiones(id_pais)

        # Limpiar y cargar nuevas regiones
        combo_regiones["values"] = [r[1] for r in lista_regiones]
        combo_regiones.set("")  # Restablecer selección

# ===== EVENTO PARA ACTUALIZAR PROVINCIAS =====
def actualizar_provincias(event):
    seleccion = combo_regiones.current()
    if seleccion != -1:
        id_region = lista_regiones[seleccion][0]
        global lista_provincias
        lista_provincias = obtener_provincias(id_region)

        # Limpiar y cargar nuevas provincias
        combo_provincias["values"] = [p[1] for p in lista_provincias]
        combo_provincias.set("")  # Restablecer selección

# ===== EVENTO PARA ACTUALIZAR CIUDADES =====
def actualizar_ciudades(event):
    seleccion = combo_provincias.current()
    if seleccion != -1:
        id_provincia = lista_provincias[seleccion][0]
        ciudades = obtener_ciudades(id_provincia)

        # Limpiar y cargar nuevas ciudades
        combo_ciudades["values"] = [c[1] for c in ciudades]
        combo_ciudades.set("")  # Restablecer selección

# ===== INTERFAZ GRÁFICA =====
root = tk.Tk()
root.title("Consulta de Países y Regiones")
root.geometry("400x200")

# Obtener lista de países
lista_paises = obtener_paises()

# ComboBox de Países
tk.Label(root, text="Selecciona un País:").pack(pady=5)
combo_paises = ttk.Combobox(root, state="readonly", width=30)
combo_paises["values"] = [p[1] for p in lista_paises]
combo_paises.pack(pady=5)
combo_paises.bind("<<ComboboxSelected>>", actualizar_regiones)

# ComboBox de Regiones
tk.Label(root, text="Regiones:").pack(pady=5)
combo_regiones = ttk.Combobox(root, state="readonly", width=30)
combo_regiones.pack(pady=5)
combo_regiones.bind("<<ComboboxSelected>>", actualizar_provincias)

# ComboBox de Provincias
tk.Label(root, text="Provincias:").pack(pady=5)
combo_provincias = ttk.Combobox(root, state="readonly", width=30)
combo_provincias.pack(pady=5)
combo_provincias.bind("<<ComboboxSelected>>", actualizar_ciudades)

# ComboBox de Ciudades
tk.Label(root, text="Ciudades:").pack(pady=5)
combo_ciudades = ttk.Combobox(root, state="readonly", width=30)
combo_ciudades.pack(pady=5)

# Ejecutar la ventana
root.mainloop()
