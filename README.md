# Gym Management - CRUD in Java with Oracle and Swing

This project is a desktop application developed in Java, using Swing for the graphical interface, and connected to an Oracle database. The application allows you to perform CRUD (Create, Read, Update, Delete) operations on various tables of a gym management system, such as clients, trainers, classes, memberships, and more.

## Requirements

- Java 8 or higher
- Oracle Database (version 11g or higher)
- Oracle JDBC Driver
- Swing for the graphical interface
- SQL Script: `LenguajesBD_ScriptFinal.sql`

## Configuration

### Step 1: Configure the Database Connection

You need to change the connection credentials to your Oracle database in the corresponding project file. Make sure to update the following values:

```java
private static String jdbcURL = "jdbc:oracle:thin:@localhost:1521:orcl";
private static String username = "PLENGUAJES_FINAL";
private static String password = "PL";
```

- `jdbcURL`: the connection URL of your Oracle database
- `username`: your Oracle username
- `password`: your database password

### Paso 2: Ejecutar el script SQL

Before using the application, you must execute the script `LenguajesBD_ScriptFinal.sql` in your database. To do this:

1. Log in to Oracle with an admin user (e.g., SYS).
2. Execute the following command in your SQL*Plus terminal or SQL client:

   ```sql
   @/path/to/file/LenguajesBD_ScriptFinal.sql
   ```

### Paso 3: Run the Application

Once the database is set up, you can run the application from your development environment. The graphical interface will allow you to perform CRUD operations on all the tables.

## Features

- **Client Management**
- **Trainer Management**
- **Class Management**
- **Membership Management**
- **Inventory Control**
- **Auditing**
- **Client Assessment Control**
- **Order Management**
- **Payment Control**
- **Supplier Control**
- **Class Enrollment Control**

## Technologies Used

- Java Swing
- JDBC (Java Database Connectivity)
- Oracle Database
