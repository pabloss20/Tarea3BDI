
CREATE DATABASE [DB_AsistenciaEmpleados]
GO

CREATE TABLE TiposdeDocumentodeIdentidad (
    Id INT PRIMARY KEY,
    Nombre NVARCHAR(255)
);

CREATE TABLE TiposDeJornadas (
    Id INT PRIMARY KEY
    , Nombre NVARCHAR(255)
    , HoraInicio TIME
    , HoraFin TIME
);

CREATE TABLE Puestos (
    Id INT IDENTITY(1,1) PRIMARY KEY
    , Nombre NVARCHAR(255)
    , SalarioXHora DECIMAL(10, 2)
);

CREATE TABLE Departamentos (
    Id INT PRIMARY KEY
    , Nombre NVARCHAR(255)
);

CREATE TABLE Feriados (
    Id INT PRIMARY KEY
    , Nombre NVARCHAR(255)
    , Fecha DATE
);

CREATE TABLE TiposDeMovimiento (
    Id INT PRIMARY KEY
    , Nombre NVARCHAR(255)
);

CREATE TABLE TiposDeDeduccion (
    Id INT PRIMARY KEY
    , Nombre NVARCHAR(255)
    , Obligatorio NVARCHAR(2)
    , Porcentual NVARCHAR(2)
    , Valor DECIMAL(10, 4)
);

-- Tabla de Usuarios
CREATE TABLE UsuariosAdministradores (
    Id INT IDENTITY(1,1) PRIMARY KEY
    , Username NVARCHAR(255)
    , Password NVARCHAR(255)
    , Tipo INT, -- 1 para administrador o 2 para empleado
);

CREATE TABLE TiposDeEvento (
    Id INT PRIMARY KEY
    , Nombre NVARCHAR(255)
);

----- HASTA AQUI LAS TABLAS QUE NO TIENEN EL PK COMO IDENTITY EXCEPTO PUESTOS-----

-- Tabla de Eventos de Bitácora
CREATE TABLE BitacoraEventos (
    Id INT IDENTITY(1,1) PRIMARY KEY
    , IdUsuario INT
    , IP VARCHAR(50)
    , FechaHora DATETIME
    , IdTipoEvento INT
    , Parametros VARCHAR(MAX)
);

-- Tabla de Empleados
CREATE TABLE Empleados (
    Id INT IDENTITY(1,1) PRIMARY KEY
    , Nombre VARCHAR(255)
    , IdTipoDocIdentidad INT
    , ValorDocIdentidad VARCHAR(50)
    , IdPuesto INT
    , IdDepartamento INT
	, Usuario NVARCHAR(255)
    , Password NVARCHAR(255)
    , Activo BIT
);

-- Tabla de Asistencia de Empleados
CREATE TABLE AsistenciaEmpleados (
    Id INT IDENTITY(1,1) PRIMARY KEY
    , IdEmpleado INT
    , Fecha DATE
    , HoraEntrada TIME
    , HoraSalida TIME
);

-- Tabla de Planilla Semanal
CREATE TABLE PlanillaSemanal (
    Id INT IDENTITY(1,1) PRIMARY KEY
    , IdEmpleado INT
    , SemanaInicio DATE
    , SalarioBruto DECIMAL(10, 2)
    , TotalDeducciones DECIMAL(10, 2)
    , SalarioNeto DECIMAL(10, 2)
);

-- Tabla de Planilla Mensual
CREATE TABLE PlanillaMensual (
    Id INT IDENTITY(1,1) PRIMARY KEY
    , IdEmpleado INT
    , MesInicio DATE
    , SalarioBrutoMensual DECIMAL(10, 2)
    , TotalDeduccionesMensuales DECIMAL(10, 2)
);

-- Tabla de Deducciones Mensuales por Empleado
CREATE TABLE DeduccionesMensuales (
    Id INT IDENTITY(1,1) PRIMARY KEY
    , IdEmpleado INT
    , MesInicio DATE
    , IdTipoDeduccion INT
    , MontoDeduccion DECIMAL(10, 2)
);

CREATE TABLE AsociacionEmpleadoDeducciones (
    IdTipoDeduccion INT
    , ValorTipoDocumento NVARCHAR(255)
    , Monto DECIMAL(10, 2)
);

-- Tabla para Jornadas de Empleados
CREATE TABLE JornadasEmpleados (
	Id INT IDENTITY(1,1) PRIMARY KEY
    , IdEmpleado INT
    , FechaInicio DATE
    , IdTipoJornada INT
);

CREATE TABLE JornadasProximaSemana (
	Id INT IDENTITY(1,1) PRIMARY KEY
    , ValorTipoDocumento NVARCHAR(255)
    , IdTipoJornada INT
);

-- Tabla para guardar el estado del mes de Planilla
CREATE TABLE MesPlanilla (
	Id INT IDENTITY(1,1) PRIMARY KEY
    , IdEmpleado INT
    , MesInicio DATE
    , SalarioBrutoMensual DECIMAL(10, 2)
    , TotalDeduccionesMensuales DECIMAL(10, 2)
);

-- Tabla para guardar el estado de la semana de Planilla
CREATE TABLE SemanaPlanilla (
	Id INT IDENTITY(1,1) PRIMARY KEY
    , IdEmpleado INT
    , SemanaInicio DATE
    , SalarioBruto DECIMAL(10, 2)
    , TotalDeducciones DECIMAL(10, 2)
    , SalarioNeto DECIMAL(10, 2)
);

-- Tabla para asociar Deducciones por Empleado y Mes
CREATE TABLE DeduccionesXEmpleadoxMes (
	Id INT IDENTITY(1,1) PRIMARY KEY
    , IdEmpleado INT
    , MesInicio DATE
    , IdTipoDeduccion INT
    , MontoDeduccion DECIMAL(10, 2)
);

-- Tabla para el manejo de excepciones
CREATE TABLE [dbo].[DBErrors](
	[ErrorID] [int] IDENTITY(1,1) NOT NULL
	, [UserName] [varchar](100) NULL
	, [ErrorNumber] [int] NULL
	, [ErrorState] [int] NULL
	, [ErrorSeverity] [int] NULL
	, [ErrorLine] [int] NULL
	, [ErrorProcedure] [varchar](max) NULL
	, [ErrorMessage] [varchar](max) NULL
	, [ErrorDateTime] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

-- Restricciones y Claves Foráneas
ALTER TABLE Empleados ADD FOREIGN KEY (IdTipoDocIdentidad) REFERENCES TiposdeDocumentodeIdentidad(Id);
ALTER TABLE Empleados ADD FOREIGN KEY (IdPuesto) REFERENCES Puestos(Id);
ALTER TABLE Empleados ADD FOREIGN KEY (IdDepartamento) REFERENCES Departamentos(Id);
ALTER TABLE AsistenciaEmpleados ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE PlanillaSemanal ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE PlanillaMensual ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE DeduccionesMensuales ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE DeduccionesMensuales ADD FOREIGN KEY (IdTipoDeduccion) REFERENCES TiposDeDeduccion(Id);
--ALTER TABLE AsociacionDeducciones ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
--ALTER TABLE AsociacionDeducciones ADD FOREIGN KEY (IdTipoDeduccion) REFERENCES TipoDeduccion(Id);
ALTER TABLE AsociacionEmpleadoDeducciones ADD FOREIGN KEY (IdTipoDeduccion) REFERENCES TiposDeDeduccion(Id);
ALTER TABLE JornadasEmpleados ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE JornadasEmpleados ADD FOREIGN KEY (IdTipoJornada) REFERENCES TiposDeJornadas(Id);
ALTER TABLE MesPlanilla ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE SemanaPlanilla ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE DeduccionesXEmpleadoxMes ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE DeduccionesXEmpleadoxMes ADD FOREIGN KEY (IdTipoDeduccion) REFERENCES TiposDeDeduccion(Id);

------ Se agregaron después, en el archivo de tablas nuevo ------
-- Relación entre Empleados y TiposdeDocumentodeIdentidad
ALTER TABLE Empleados
ADD FOREIGN KEY (IdTipoDocIdentidad) REFERENCES TiposdeDocumentodeIdentidad(Id);

-- Relación entre Empleados y Departamentos
ALTER TABLE Empleados
ADD FOREIGN KEY (IdDepartamento) REFERENCES Departamentos(Id);

-- Relación entre Empleados y Puestos
ALTER TABLE Empleados
ADD FOREIGN KEY (IdPuesto) REFERENCES Puestos(Id);

-- Relación entre AsociacionEmpleadoDeducciones y TiposDeDeduccion
ALTER TABLE AsociacionEmpleadoDeducciones
ADD FOREIGN KEY (IdTipoDeduccion) REFERENCES TiposDeDeduccion(Id);

-- Relación entre JornadasProximaSemana y TiposDeJornadas
ALTER TABLE JornadasProximaSemana
ADD FOREIGN KEY (IdTipoJornada) REFERENCES TiposDeJornadas(Id);

-- Índices únicos
CREATE UNIQUE INDEX idxValorDocumentoIdentidadUnico
ON Empleados (ValorDocIdentidad);