
-- Tabla de Catálogos
CREATE TABLE TipoDocumentoIdentidad (
    Id INT PRIMARY KEY
    , Nombre VARCHAR(255)
);

CREATE TABLE TipoJornada (
    Id INT PRIMARY KEY
    , Nombre VARCHAR(255)
    , HoraInicio TIME
    , HoraFin TIME
);

CREATE TABLE Puestos (
    Id INT IDENTITY(1,1) PRIMARY KEY
    , Nombre VARCHAR(255)
    , SalarioXHora DECIMAL(10, 2)
);

CREATE TABLE Departamentos (
    Id INT PRIMARY KEY
    , Nombre VARCHAR(255)
);

CREATE TABLE Feriados (
    Id INT PRIMARY KEY
    , Nombre VARCHAR(255)
    , Fecha DATE
);

CREATE TABLE TipoMovimientoPlanilla (
    Id INT PRIMARY KEY
    , Nombre VARCHAR(255)
);

CREATE TABLE TipoDeduccion (
    Id INT PRIMARY KEY
    , Nombre VARCHAR(255)
    , Obligatorio BIT -- 1 si es obligatorio lo cual 0 si no
    , Porcentual BIT  -- 1 si es porcentual lo cual 0 si no
    , Valor DECIMAL(10, 2)
);

-- Tabla de Usuarios
CREATE TABLE Usuarios (
    Id INT IDENTITY(1,1) PRIMARY KEY
    , Username VARCHAR(255)
    , Password VARCHAR(255)
    , Tipo INT, -- 1 para administrador o 2 para empleado
);

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
    , FechaNacimiento DATE
    , IdPuesto INT
    , IdDepartamento INT
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

-- Tabla para Asociar Empleados con Deducciones No Obligatorias
CREATE TABLE AsociacionDeducciones (
    Id INT IDENTITY(1,1) PRIMARY KEY
    , IdEmpleado INT
    , IdTipoDeduccion INT
);

-- Tabla para Jornadas de Empleados
CREATE TABLE JornadasEmpleados (
    IdEmpleado INT
    , FechaInicio DATE
    , IdTipoJornada INT
);

-- Tabla para guardar el estado del mes de Planilla
CREATE TABLE MesPlanilla (
    IdEmpleado INT
    , MesInicio DATE
    , SalarioBrutoMensual DECIMAL(10, 2)
    , TotalDeduccionesMensuales DECIMAL(10, 2)
);

-- Tabla para guardar el estado de la semana de Planilla
CREATE TABLE SemanaPlanilla (
    IdEmpleado INT
    , SemanaInicio DATE
    , SalarioBruto DECIMAL(10, 2)
    , TotalDeducciones DECIMAL(10, 2)
    , SalarioNeto DECIMAL(10, 2)
);

-- Tabla para asociar Deducciones por Empleado y Mes
CREATE TABLE DeduccionesXEmpleadoxMes (
    IdEmpleado INT
    , MesInicio DATE
    , IdTipoDeduccion INT
    , MontoDeduccion DECIMAL(10, 2)
);

-- Restricciones y Claves Foráneas
ALTER TABLE Empleados ADD FOREIGN KEY (IdTipoDocIdentidad) REFERENCES TipoDocumentoIdentidad(Id);
ALTER TABLE Empleados ADD FOREIGN KEY (IdPuesto) REFERENCES Puestos(Id);
ALTER TABLE Empleados ADD FOREIGN KEY (IdDepartamento) REFERENCES Departamentos(Id);
ALTER TABLE AsistenciaEmpleados ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE PlanillaSemanal ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE PlanillaMensual ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE DeduccionesMensuales ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE DeduccionesMensuales ADD FOREIGN KEY (IdTipoDeduccion) REFERENCES TipoDeduccion(Id);
ALTER TABLE AsociacionDeducciones ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE AsociacionDeducciones ADD FOREIGN KEY (IdTipoDeduccion) REFERENCES TipoDeduccion(Id);
ALTER TABLE JornadasEmpleados ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE JornadasEmpleados ADD FOREIGN KEY (IdTipoJornada) REFERENCES TipoJornada(Id);
ALTER TABLE MesPlanilla ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE SemanaPlanilla ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE DeduccionesXEmpleadoxMes ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleados(Id);
ALTER TABLE DeduccionesXEmpleadoxMes ADD FOREIGN KEY (IdTipoDeduccion) REFERENCES TipoDeduccion(Id);
