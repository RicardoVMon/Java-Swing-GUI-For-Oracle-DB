# Gestión de Gimnasio - CRUD en Java con Oracle y Swing

Este proyecto es una aplicación de escritorio desarrollada en Java, utilizando **Swing** para la interfaz gráfica, y conectada a una base de datos Oracle. La aplicación permite realizar operaciones CRUD (Crear, Leer, Actualizar, Eliminar) sobre las distintas tablas de un sistema de gestión de gimnasio, como clientes, entrenadores, clases, membresías, y más.

## Requisitos

- Java 8 o superior
- Oracle Database (versión 11g o superior)
- Oracle JDBC Driver
- Swing para la interfaz gráfica
- Script SQL: `LenguajesBD_ScriptFinal.sql`

## Configuración

### Paso 1: Configurar la conexión a la base de datos

Debes cambiar las credenciales de conexión a tu base de datos Oracle en el archivo del proyecto correspondiente. Asegúrate de actualizar los siguientes valores:

```java
private static String jdbcURL = "jdbc:oracle:thin:@localhost:1521:orcl";
private static String username = "PLENGUAJES_FINAL";
private static String password = "PL";
```

- `jdbcURL`: la URL de conexión de tu base de datos Oracle
- `username`: tu nombre de usuario de Oracle
- `password`: la contraseña de tu base de datos

### Paso 2: Ejecutar el script SQL

Antes de utilizar la aplicación, debes ejecutar el script `LenguajesBD_ScriptFinal.sql` en tu base de datos. Para esto:

1. Inicia sesión en Oracle con un usuario administrador (por ejemplo, **SYS**).
2. Ejecuta el siguiente comando en tu terminal de SQL*Plus o cliente SQL:

   ```sql
   @/ruta/al/archivo/LenguajesBD_ScriptFinal.sql
   ```

### Paso 3: Ejecutar la aplicación

Una vez que la base de datos esté configurada, puedes ejecutar la aplicación desde tu entorno de desarrollo. La interfaz gráfica te permitirá realizar operaciones CRUD en todas las tablas.

## Funcionalidades

- **Gestión de Clientes**
- **Gestión de Entrenadores**
- **Gestión de Clases**
- **Gestión de Membresías**
- **Control de Inventario**
- **Auditoría**
- **Control de Evaluaciones de Clientes**
- **Gestión de Pedidos**
- **Control de Pagos**
- **Control de Proveedores**
- **Control de Inscripciones a Clases**

## Tecnologías utilizadas

- Java Swing
- JDBC (Java Database Connectivity)
- Oracle Database
