-- Eliminacion de Secuencias
DROP SEQUENCE S_CODIGO_AREA;
DROP SEQUENCE S_COD_UNIVERSIDAD;
DROP SEQUENCE S_CODIGO_PRY;
DROP SEQUENCE S_CODIGO_BEN;

-- Eliminacion de tablas para que se puedan volver a crear
DROP TABLE BENEFICIARIOS;
DROP TABLE PARENTESCO;
DROP TABLE PROYECTOS_EMPLEADOS;
DROP TABLE PROYECTOS;
DROP TABLE AREAS_MUN;
DROP TABLE UNIVERSIDAD;
DROP TABLE MUNICIPIOS;
DROP TABLE DEPARTAMENTOS;
ALTER TABLE EMPLEADOS_FAB DROP CONSTRAINT EMP_AREAS_FK;
ALTER TABLE AREAS DROP CONSTRAINT AREAS_EMP_FK;
DROP TABLE AREAS;
DROP TABLE EMPLEADOS_FAB;

-- Creacion tablas Empleados
CREATE TABLE EMPLEADOS_FAB(
CODIGO_EMP   NUMBER(8),
NOMBRE_EMP   VARCHAR2(40),
DIRECCION    VARCHAR2(100),
SALARIO      NUMBER(8),
SEXO         VARCHAR2(1),
FECHA_NAC    DATE,
CODIGO_AREA  NUMBER(4),
CONSTRAINT EMPLEADOS_FAB_PK PRIMARY KEY (CODIGO_EMP));

ALTER TABLE EMPLEADOS_FAB ADD CONSTRAINT C_EMPLEADOS_FAB_SEXO_CH check (SEXO IN ('M','F'));

COMMENT ON TABLE EMPLEADOS_FAB is 'Maestro de Empleados';
COMMENT ON COLUMN EMPLEADOS_FAB.CODIGO_EMP is 'Codigo del empleado';
COMMENT ON COLUMN EMPLEADOS_FAB.NOMBRE_EMP is 'Nombre completo del empleado';
COMMENT ON COLUMN EMPLEADOS_FAB.DIRECCION  is 'Dirección del empleado';
COMMENT ON COLUMN EMPLEADOS_FAB.SALARIO    is 'Salario del empleado';
COMMENT ON COLUMN EMPLEADOS_FAB.SALARIO    is 'SEXO del empleado, F - Femenino, M - Masculino';
COMMENT ON COLUMN EMPLEADOS_FAB.FECHA_NAC  is 'Fecha de Nacimiento del empleado';
COMMENT ON COLUMN EMPLEADOS_FAB.CODIGO_AREA is 'Codigo del area al cual pertenece el empleado';

-- Creacion tablas AREAS
CREATE TABLE AREAS
( CODIGO_AREA  NUMBER(4),
  NOMBRE_AREA  VARCHAR2(40),
  CODIGO_JEFE  NUMBER(8),
  FECHA_JEFE DATE,
CONSTRAINT AREAS_PK PRIMARY KEY (CODIGO_AREA),
CONSTRAINT AREAS_EMP_FK FOREIGN KEY (CODIGO_JEFE) REFERENCES EMPLEADOS_FAB(CODIGO_EMP)) ;

COMMENT ON TABLE AREAS is 'Maestro de Areas de la empresa';
COMMENT ON COLUMN AREAS.CODIGO_AREA is 'Codigo del area';
COMMENT ON COLUMN AREAS.NOMBRE_AREA is 'Nombre del area de trabajo';
COMMENT ON COLUMN AREAS.CODIGO_JEFE is 'Codigo del jefe del area';
COMMENT ON COLUMN AREAS.FECHA_JEFE is 'Fecha del jefe de area';

--  LLave foranea entre Empleados y Areas
ALTER TABLE EMPLEADOS_FAB
ADD CONSTRAINT EMP_AREAS_FK FOREIGN KEY(CODIGO_AREA ) REFERENCES AREAS (CODIGO_AREA);


-- Creacion tablas DEPARTAMENTOS
CREATE TABLE DEPARTAMENTOS
( CODIGO_DEPTO VARCHAR(2),
  NOMBRE_DEPTO VARCHAR2(40),
CONSTRAINT DEPARTAMENTOS_PK PRIMARY KEY (CODIGO_DEPTO)
) ;

-- Creacion tablas Municipios
CREATE TABLE MUNICIPIOS
( CODIGO_MUN VARCHAR(5),
  NOMBRE_MUN VARCHAR2(40),
  CODIGO_DEPTO VARCHAR(2),
CONSTRAINT MUNICIPIOS_PK PRIMARY KEY (CODIGO_MUN),
CONSTRAINT MUN_DEPTOS_FK FOREIGN KEY (CODIGO_DEPTO) REFERENCES 
DEPARTAMENTOS (CODIGO_DEPTO) 
) ;

-- Creacion tablas AREAS_MUN
CREATE TABLE AREAS_MUN
( CODIGO_AREA  NUMBER(4),
  CODIGO_MUN   VARCHAR(5),
CONSTRAINT AREAS_MUN_PK PRIMARY KEY (CODIGO_AREA, CODIGO_MUN),
CONSTRAINT AREAS_MUN_AREAS_FK FOREIGN KEY (CODIGO_AREA) REFERENCES AREAS (CODIGO_AREA) ,
CONSTRAINT AREAS_MUN_MUN_FK FOREIGN KEY (CODIGO_MUN) REFERENCES MUNICIPIOS (CODIGO_MUN) 
);

-- Creacion tablas PARENTESCO
CREATE TABLE PARENTESCO
( COD_PARENTESCO VARCHAR2(2),
  NOM_PARENTESCO VARCHAR2(25),
CONSTRAINT PARENTESCO_PK PRIMARY KEY (COD_PARENTESCO)
);

-- Creacion tablas BENEFICIARIOS
CREATE TABLE BENEFICIARIOS
(CODIGO_EMP   NUMBER(8),
CODIGO_BEN    NUMBER(8),
NOMBRE_BEN    VARCHAR2(40),
SEXO          VARCHAR2(1),
FECHA_NAC     DATE,
COD_PARENTESCO  VARCHAR2(2),
CONSTRAINT BENEFICIARIOS_PK PRIMARY KEY (CODIGO_EMP, CODIGO_BEN),
CONSTRAINT BEN_PARENTESCO_FK FOREIGN KEY (COD_PARENTESCO) REFERENCES PARENTESCO(COD_PARENTESCO),
CONSTRAINT BEN_EMP_FK FOREIGN KEY (CODIGO_EMP) REFERENCES 
EMPLEADOS_FAB(CODIGO_EMP)
);


-- Creacion tablas UNIVERSIDAD
CREATE TABLE UNIVERSIDAD(
COD_UNIVERSIDAD NUMBER(4),
NOM_UNIVERSIDAD VARCHAR2(40),
CONSTRAINT UNIVERSIDAD PRIMARY KEY (COD_UNIVERSIDAD)
);

-- Creacion tablas PROYECTOS
CREATE TABLE PROYECTOS(
CODIGO_PRY            NUMBER(6),
NOMBRE_PRY            VARCHAR2(40),
CODIGO_AREA           NUMBER(4),
CODIGO_MUN            VARCHAR(5),
CODIGO_SUPERVISOR     NUMBER(8),
TIPO_PRY              VARCHAR2(1),
PRESUPUESTO           NUMBER(10),
COD_UNIVERSIDAD       NUMBER(4),
PROD_MINIMA           NUMBER(5),
FECHA_INICIAL         DATE,
FECHA_FINAL	      DATE,    
CONSTRAINT PROYECTOS_PK PRIMARY KEY (CODIGO_PRY),
CONSTRAINT PROY_EMP_FK  FOREIGN KEY (CODIGO_SUPERVISOR) REFERENCES EMPLEADOS_FAB(CODIGO_EMP),
CONSTRAINT PROY_AREASMUN_FK  FOREIGN KEY (CODIGO_AREA, CODIGO_MUN) REFERENCES AREAS_MUN(CODIGO_AREA, CODIGO_MUN),
CONSTRAINT PROY_UNIV_FK FOREIGN KEY (COD_UNIVERSIDAD) REFERENCES UNIVERSIDAD (COD_UNIVERSIDAD)    
);

ALTER TABLE PROYECTOS ADD CONSTRAINT C_PROYECTOS_TIPO_CH check (TIPO_PRY IN ('I','D'));

-- Creacion tablas PROYECTOS_EMPLEADOS
CREATE TABLE PROYECTOS_EMPLEADOS(
CODIGO_PRY   NUMBER(6),
CODIGO_EMP   NUMBER(8),
HORAS        NUMBER(3),    
CONSTRAINT PROYECTOS_EMPLEADOS_PK PRIMARY KEY (CODIGO_PRY,CODIGO_EMP),
CONSTRAINT PROY_EMP_EMP_FK  FOREIGN KEY (CODIGO_EMP) REFERENCES EMPLEADOS_FAB(CODIGO_EMP),
CONSTRAINT PROY_EMP_PRY_FK  FOREIGN KEY (CODIGO_PRY) REFERENCES PROYECTOS(CODIGO_PRY)
 );


--------------------------------------------------------------------------------
---- 3. Creación de Secuencias y Triggers para campos que pueden ser asignados por la BD 
--------------------------------------------------------------------------------
-- Creacion de secuencias tabla AREAS
CREATE SEQUENCE S_CODIGO_AREA
 MINVALUE 1 
 MAXVALUE 9999
INCREMENT BY 1 
START WITH 1 
/ 

-- Creacion de Triggers tabla AREAS
CREATE OR REPLACE TRIGGER T_AREAS_BI 
BEFORE INSERT ON AREAS
FOR EACH ROW 
BEGIN 

:new.CODIGO_AREA := S_CODIGO_AREA.NEXTVAL;

END T_AREAS_BI; 
/

-- Creacion de secuencias tabla UNIVERSIDADES
CREATE SEQUENCE S_COD_UNIVERSIDAD
 MINVALUE 1 
 MAXVALUE 9999
INCREMENT BY 1 
START WITH 1 
/ 

-- Creacion de Triggers tabla UNIVERSIDADES
CREATE OR REPLACE TRIGGER T_UNIVERSIDAD_BI 
BEFORE INSERT ON UNIVERSIDAD
FOR EACH ROW 
BEGIN 

:new.COD_UNIVERSIDAD := S_COD_UNIVERSIDAD.NEXTVAL;

END T_UNIVERSIDAD_BI ; 
/

-- Creacion de secuencias tabla PROYECTOS
CREATE SEQUENCE S_CODIGO_PRY
 MINVALUE 1 
 MAXVALUE 999999
INCREMENT BY 1 
START WITH 1 
/ 

-- Creacion de Triggers tabla PROYECTOS
CREATE OR REPLACE TRIGGER T_PROYECTOS_BI 
BEFORE INSERT ON PROYECTOS
FOR EACH ROW 
BEGIN 

:new.CODIGO_PRY := S_CODIGO_PRY.NEXTVAL;

END T_PROYECTOS_BI; 
/


-- Creacion de secuencias tabla BENEFICIARIOS
CREATE SEQUENCE S_CODIGO_BEN
 MINVALUE 1 
 MAXVALUE 99999999
INCREMENT BY 1 
START WITH 1 
/ 

-- Creacion de Triggers tabla BENEFICIARIOS
CREATE OR REPLACE TRIGGER T_BENEFICIARIOS_BI 
BEFORE INSERT ON BENEFICIARIOS
FOR EACH ROW 
BEGIN 

:new.CODIGO_BEN := S_CODIGO_BEN.NEXTVAL;

END T_BENEFICIARIOS_BI; 
/

insert into PARENTESCO (COD_PARENTESCO, NOM_PARENTESCO)
values ('E', 'Esposo(a)');

insert into PARENTESCO (COD_PARENTESCO, NOM_PARENTESCO)
values ('H', 'Hijo(a)');

insert into PARENTESCO (COD_PARENTESCO, NOM_PARENTESCO)
values ('P', 'Padres');

insert into PARENTESCO (COD_PARENTESCO, NOM_PARENTESCO)
values ('T', 'Tio(a)');

insert into PARENTESCO (COD_PARENTESCO, NOM_PARENTESCO)
values ('C', 'Compañera');

insert into PARENTESCO (COD_PARENTESCO, NOM_PARENTESCO)
values ('M', 'Hermano(a)');

insert into PARENTESCO (COD_PARENTESCO, NOM_PARENTESCO)
values ('N', 'No definido');

insert into PARENTESCO(COD_PARENTESCO, NOM_PARENTESCO)
values ('D', 'Hijo(a) Discapacitado');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('05', 'Antioquia');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('08', 'Atlantico');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('11', 'Bogota');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('13', 'Bolivar');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('15', 'Boyaca');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('17', 'Caldas');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('18', 'Caqueta');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('19', 'Cauca');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('20', 'Cesar');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('23', 'Cordoba');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('25', 'Cundinamarca');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('27', 'Choco');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('41', 'Huila');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('44', 'La Guajira');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('47', 'Magdalena');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('50', 'Meta');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('52', 'Nariño');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('54', 'N. De Santander');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('63', 'Quindio');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('66', 'Risaralda');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('68', 'Santander');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('70', 'Sucre');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('73', 'Tolima');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('76', 'Valle Del Cauca');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('81', 'Arauca');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('85', 'Casanare');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('86', 'Putumayo');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('88', 'San Andres');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('91', 'Amazonas');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('94', 'Guainia');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('95', 'Guaviare');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('97', 'Vaupes');

insert into DEPARTAMENTOS (CODIGO_DEPTO, NOMBRE_DEPTO)
values ('99', 'Vichada');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54003', 'Abrego', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('50006', 'Acacias', '50');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('25001', 'Agua De Dios', '25');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20011', 'Aguachica', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20013', 'Agustin Codazzi', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('25019', 'Alban', '25');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('76041', 'Ansermanuevo', '76');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('05045', 'Apartado', '05');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('47053', 'Aracataca', '47');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('17050', 'Aranzazu', '17');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('81001', 'Arauca', '81');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('81065', 'Arauquita', '81');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54051', 'Arboledas', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('13042', 'Arenal', '13');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('63001', 'Armenia', '63');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('23068', 'Ayapel', '23');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68077', 'Barbosa', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68079', 'Barichara', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68081', 'Barrancabermeja', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('13074', 'Barranco De Loba', '13');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('08001', 'Barranquilla', '08');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20045', 'Becerril', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68092', 'Betulia', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15097', 'Boavita', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54099', 'Bochalema', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('11001', 'Bogota, D.C.', '11');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20060', 'Bosconia', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68001', 'Bucaramanga', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54109', 'Bucarasica', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('76109', 'Buenaventura', '76');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68121', 'Cabrera', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('76001', 'Cali', '76');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('13160', 'Cantagallo', '13');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68147', 'Capitanejo', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68152', 'Carcasi', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('13001', 'Cartagena', '13');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('76147', 'Cartago', '76');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('05154', 'Caucasia', '05');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15162', 'Cerinza', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68167', 'Charala', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('25175', 'Chia', '25');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('23182', 'Chinu', '23');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54172', 'Chinácota', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20178', 'Chiriguana', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54174', 'Chitagá', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68190', 'Cimitarra', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('13222', 'Clemencia', '13');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68207', 'Concepcion', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54206', 'Convención', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('70215', 'Corozal', '70');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15223', 'Cubara', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54223', 'Cucutilla', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20228', 'Curumani', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54128', 'Cáchira', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54125', 'Cácota', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54001', 'Cúcuta', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15238', 'Duitama', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54239', 'Durania', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('47245', 'El Banco', '47');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54245', 'El Carmen', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('13244', 'El Carmen De Bolivar', '13');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68235', 'El Carmen De Chucuri', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20238', 'El Copey', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68255', 'El Playon', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54250', 'El Tarra', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54261', 'El Zulia', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68266', 'Enciso', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('05266', 'Envigado', '05');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('73268', 'Espinal', '73');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('18001', 'Florencia', '18');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68271', 'Florian', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68276', 'Floridablanca', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('44279', 'Fonseca', '44');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('81300', 'Fortul', '81');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('47288', 'Fundacion', '47');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('25286', 'Funza', '25');


insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('25290', 'Fusagasuga', '25');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20295', 'Gamarra', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15299', 'Garagoa', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('25307', 'Girardot', '25');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68307', 'Giron', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20310', 'Gonzalez', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54313', 'Gramalote', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('76111', 'Guadalajara De Buga', '76');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('25320', 'Guaduas', '25');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('47318', 'Guamal', '47');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('73319', 'Guamo', '73');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68322', 'Guapota', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54344', 'Hacarí', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54347', 'Herrán', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('73001', 'Ibague', '73');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('94001', 'Inirida', '94');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('05360', 'Itagüí ', '05');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68370', 'Jordan', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54385', 'La Esperanza', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20383', 'La Gloria', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20400', 'La Jagua De Ibirico', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('25386', 'La Mesa', '25');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54398', 'La Playa', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54377', 'Labateca', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68406', 'Lebrija', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('91001', 'Leticia', '91');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('73411', 'Libano', '73');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54405', 'Los Patios', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54418', 'Lourdes', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('13430', 'Magangue', '13');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('44430', 'Maicao', '44');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68432', 'Malaga', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20443', 'Manaure', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('44560', 'Manaure', '44');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('17001', 'Manizales', '17');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('13442', 'Maria La Baja', '13');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('73443', 'Mariquita', '73');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('17444', 'Marquetalia', '17');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68444', 'Matanza', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('05001', 'Medellín', '05');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('97001', 'Mitu', '97');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('86001', 'Mocoa', '86');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68464', 'Mogotes', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('13468', 'Mompos', '13');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('23466', 'Montelibano', '23');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('23001', 'Monteria', '23');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('85162', 'Monterrey', '85');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('13473', 'Morales', '13');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54480', 'Mutiscua', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('41001', 'Neiva', '41');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15491', 'Nobsa', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('76497', 'Obando', '76');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54498', 'Ocaña', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68500', 'Oiba', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68502', 'Onzaga', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20517', 'Pailitas', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15516', 'Paipa', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68522', 'Palmar', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54518', 'Pamplona', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54520', 'Pamplonita', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('52001', 'Pasto', '52');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15537', 'Paz De Rio', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20550', 'Pelaya', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('66001', 'Pereira', '66');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68547', 'Piedecuesta', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68549', 'Pinchote', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('19001', 'Popayan', '19');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68572', 'Puente Nacional', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('86568', 'Puerto Asis', '86');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15572', 'Puerto Boyaca', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('99001', 'Puerto Carreño', '99');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('08573', 'Puerto Colombia', '08');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68573', 'Puerto Parra', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('81591', 'Puerto Rondon', '81');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54553', 'Puerto Santander', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68575', 'Puerto Wilches', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('27001', 'Quibdo', '27');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('25596', 'Quipile', '25');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54599', 'Ragonvalia', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15600', 'Raquira', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('50606', 'Restrepo', '50');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20614', 'Rio De Oro', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('44001', 'Riohacha', '44');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68615', 'Rionegro', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54660', 'Salazar', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20710', 'San Alberto', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68669', 'San Andres', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('88001', 'San Andres', '88');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54670', 'San Calixto', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54673', 'San Cayetano', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68679', 'San Gil', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('13654', 'San Jacinto', '13');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68684', 'San Jose De Miranda', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('95001', 'San Jose Del Guaviare', '95');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('44650', 'San Juan Del Cesar', '44');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('70708', 'San Marcos', '70');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20770', 'San Martin', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('13670', 'San Pablo', '13');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68689', 'San Vicente De Chucuri', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('47001', 'Santa Marta', '47');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15693', 'Santa Rosa De Viterbo', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('13688', 'Santa Rosa Del Sur', '13');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15696', 'Santa Sofia', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54680', 'Santiago', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('81736', 'Saravena', '81');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54720', 'Sardinata', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54743', 'Silos', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('13744', 'Simiti', '13');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('70001', 'Sincelejo', '70');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68755', 'Socorro', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15759', 'Sogamoso', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('08758', 'Soledad', '08');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('81794', 'Tame', '81');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54800', 'Teorama', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15806', 'Tibasosa', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54810', 'Tibú', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54820', 'Toledo', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('70823', 'Tolu Viejo', '70');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('76834', 'Tulua', '76');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15001', 'Tunja', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15837', 'Tuta', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('44847', 'Uribia', '44');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('20001', 'Valledupar', '20');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('18860', 'Valparaiso', '18');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68861', 'Velez', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54871', 'Villa Caro', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15407', 'Villa De Leyva', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('54874', 'Villa Del Rosario', '54');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('25871', 'Villagomez', '25');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('44874', 'Villanueva', '44');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('85440', 'Villanueva', '85');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('50001', 'Villavicencio', '50');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('05887', 'Yarumal', '05');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('05893', 'Yondo', '05');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('85001', 'Yopal', '85');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('68895', 'Zapatoca', '68');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('15897', 'Zetaquira', '15');

insert into municipios (CODIGO_MUN, NOMBRE_MUN, CODIGO_DEPTO)
values ('25899', 'Zipaquira', '25');

ALTER TRIGGER T_AREAS_BI DISABLE;

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (299, 'PRODUCCION');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (640, 'COMERCIALIZACION');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (131, 'OFICINA DE CONTROL INTERNO');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (362, 'CONTROL Y REDUCCION DE PERDIDA');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (1100, 'Secretaria general');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (6200, 'Área Finanzas');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (134, 'OFICINA JURIDICA');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (460, 'DEPARTAMENTO DE FACTURACION');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (300, 'DISTRIBUCION');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (130, 'GERENCIA');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (7100, 'Unidad Gestión Operativa');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (2100, 'Gestión humana y  organizacion');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (1400, 'Comunicaciones');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (220, 'SERVICIOS GENERALES');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (6400, 'Área Servicios Corporativos');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (135, 'SECRETARIA GENERAL');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (2420, 'Almacenes ');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (234, 'APREDICES ');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (210, 'SALUD OCUPACIONAL');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (400, 'SUBERENCIA DE COMERCIALIZACION');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (240, 'DEPARTAMENTO DE CONTABILIDAD');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (133, 'DEPARTAMENTO DE ORGANIZACION');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (4330, 'Facturación ');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (132, 'OFICINA DE PLANEACION');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (230, 'TALENTO HUMANO');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (7300, 'Unidad Proyectos');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (260, 'SECCION DE SUMINISTROS');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (2310, 'Planeación financiera ');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (333, 'CONEXION AL USUARIO');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (4000, 'Subgerencia comercial');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (7700, 'Subgerencia Distribución');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (200, 'SUB-GERENCIA ADMINISTRATIVA');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (334, 'TRANSPORTE ');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (290, 'SECCION DE CONTROL PRESUPUESTA');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (410, 'MERCADO MAYORISTA');

insert into AREAS (CODIGO_AREA, NOMBRE_AREA)
values (7200, 'Área Gestión Comercial');

COMMIT;

ALTER TRIGGER T_AREAS_BI ENABLE;

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (32763390, 'KATERINE LOBO CASTRO', 'CLL 6N#6E-84 QUINTA ORIENTAL', 398400, 'F', to_date('15-04-1989', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (96039940, 'ALEXANDRA EMILIA PAZ CUMBE', 'CRA 5AN 66E-36 CASA 4B CONJ.HACARITAMA', 429600, 'F', to_date('11-04-1988', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (36026320, 'AMPARO RITA MENDOZA PARADA', 'CRA 6 #2-08 B.CARIONGO', 584009, 'F', to_date('27-01-1988', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (81343840, 'JORGE LUIS TARAZONA CASTELLANOS', 'BLOQUE 3 LOTE 6 BARRIO CLARET', 5676066, 'M', to_date('16-02-1967', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (68824680, 'ALFONSO CIRO PEÑARANDA MANTILLA', 'CRA 3 #65-25 B.SAN LUIS', 691571, 'M', to_date('12-12-1988', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (48824450, 'ELIAS HAROLD MORA MALDONADO', 'CLL 62 #63-76 B.EL CONTENTO 722549', 52020, 'M', to_date('30-09-1988', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (58823550, 'BELISARIO BLANCO GELVEZ', 'CRA 3E  2AN-29  LA CAPILLANA', 489600, 'M', to_date('28-03-1987', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8911020, 'ARMANDO DIEGO CONTRERAS PEREZ', 'CRA 5  62-63  URB SAN MARTIN', 520440, 'M', to_date('19-01-1998', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (61092640, 'AUGUSTO CESAR SUAREZ MALDONADO', 'CRA 7  67-66  LA CABRERA', 553800, 'M', to_date('29-05-1996', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (16029160, 'OLIVA GLADIS VILLAMIZAR ALBARRACIN', 'CRA 7N  3E-680  CEDRO II', 4221334, 'F', to_date('18-12-1968', 'dd-mm-yyyy'), 260);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (21339210, 'ALEXANDER CASTAÑEDA SUAREZ', 'CRA 3 MAZ 6  LOTE6 EL ZULIA URB AZUBULEVARIS', 737906, 'M', to_date('24-02-1990', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (13729100, 'ESPERANZA MARIA GRANDAS ACHURE', 'CRA 6  3-09  LA VICTORIA', 737906, 'F', to_date('27-10-1991', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (2783040, 'YADIRA BELKYS RODRIGUEZ PEÑARANDA', 'CRA 5  68-58  ANIVERSARIO II', 789486, 'F', to_date('25-08-1990', 'dd-mm-yyyy'), 210);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (96036920, 'RUBIELA AMANDA CARDENAS DUQUE', 'CALL 60 #65-44 URB/ANIVERSARIO I', 789486, 'F', to_date('13-11-1983', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (81316860, 'LEONARDO FABIO DODINO SALAZAR', 'CRA 63BN 66-40 LAS AMERICAS B/OLGA TER', 789486, 'M', to_date('30-03-1985', 'dd-mm-yyyy'), 210);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (94971920, 'JOHANA KELLY SANCHEZ MUÑOZ', 'CRA 7 #65-93 AGUACHICA', 737906, 'F', to_date('13-10-1991', 'dd-mm-yyyy'), 640);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (26026270, 'MARICELA RICO REAL', 'CRA 3 N? 8-623 INTERIOR 2 PASAJE DIVIN', 457800, 'F', to_date('13-11-1985', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (21337260, 'DEL CARMEN LUIS MANOSALVA ROPERO', 'CRA 2F # 28D-05', 7825356, 'M', to_date('10-03-1968', 'dd-mm-yyyy'), 7700);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (56026540, 'LORENA ANA ARANGO GONZALEZ', 'CRA 8 Nº 2-67 ', 489600, 'F', to_date('27-12-1990', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (23739230, 'LISBETH JENNY PABON CONTRERAS', 'BULEVAR 5 Nº 6A-34 BARRIO LA MERCED', 489600, 'F', to_date('19-05-1992', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (22760210, 'LILIANA ERIKA JURGENSEN SILVA', 'CRA 6BN #7AE-606 B/CEDRO II', 398400, 'F', to_date('03-07-1990', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (16037130, 'ELVIA AURA AMAYA CARRILLO', 'CRA 3 60-74 EL ROSAL DEL NORTE ATALAYA', 457800, 'F', to_date('31-01-1984', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (61344680, 'VIDAL RAMON BARBOSA VILLAMIZAR', 'Cra.  2  5-43  Mz 6  Lote 7  Barrio La Aurora', 2486585, 'M', to_date('03-01-1967', 'dd-mm-yyyy'), 7700);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (98823990, 'FABIO BECERRA BELTRAN', 'CRA 2N #64E-66  URBANIZACION VILL PRAD', 691571, 'M', to_date('24-12-1987', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (88815820, 'ROLANDO JULIO CACUA VALENCIA', 'CALLE 7  #7-94 BARRIO CHAPINERO', 635927, 'M', to_date('10-10-1981', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (68827630, 'DE JESUS LEONEL QUINTERO QUINTERO', 'CALLE 63C Nº 63-04', 520440, 'M', to_date('28-08-1979', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8809010, 'NATTALY JULIETH GARCIA SUAREZ', 'EL DIAMANTE, PAMPLONITA', 489600, 'F', to_date('18-11-1996', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (83774840, 'ANDREA PAOLA ZAMBRANO ARIZA', 'CRA 9A  67B-35 ANIVERSARIO II', 979200, 'F', to_date('09-12-1987', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (35471330, 'ARTURO MARVIS MANZANO CLARO', 'CRA 5 Nº 62-25 LA TORCORAMA', 489600, 'M', to_date('23-12-1989', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (78823750, 'FERNEI EDWIN RINCON MILLAN', 'CRA 2 4E-26 LA CEDRO', 457800, 'M', to_date('29-06-1987', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (56330540, 'ANGEL SOL TOBON GAMBOA', 'CRA 2N  65E-20 APTO 202C TORRES DEL PA', 5228083, 'F', to_date('13-03-1972', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (53731530, 'ESPERANZA CRISTINA VEGA FUENTES', 'CALLE 63 # 63-644 BARRIO TACALOA', 2399716, 'F', to_date('07-06-1970', 'dd-mm-yyyy'), 7700);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (6026070, 'YADIRA RUTH ORTIZ BUITRAGO', 'CRA 8 #8-648 B/CHAPINERO', 584009, 'F', to_date('08-05-1983', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (68824600, 'SANTIAGO EDGAR PEREZ CARDENAS', 'CRA 60AN  #4A-98 URB.EL BOSQUE', 584009, 'M', to_date('01-01-1989', 'dd-mm-yyyy'), 200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38822350, 'ALIM FUAD MESA ASSAF', 'CRA 26N  #66BE-20  URBANIZACION NIZA', 584009, 'M', to_date('01-05-1985', 'dd-mm-yyyy'), 200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (24972290, 'MARINA LUZ JACOME OSPINA', '0', 876935, 'F', to_date('24-02-1992', 'dd-mm-yyyy'), 640);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (46470490, 'DEL CARMEN KELLY RODRIGUEZ VITOLA', 'CRA 40A  64D-43  BARRIO VILLA MADY', 520440, 'F', to_date('02-07-1991', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (18602160, 'SIRLEY ANGELICA CHACON MARQUEZ', 'CRA 8CN #3A-28 URBANIZACIÓN EL BOSQUE ', 429600, 'F', to_date('05-05-1994', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (36034360, 'RUTH EDY ROJAS MOLINA', 'BULEVAR. 6 #3-43 B/COMUNEROS', 429600, 'F', to_date('09-02-1979', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8506040, 'ANGELICA ASCANIO ZAFRA', 'MZ F6 LOTE 60 B/ATALAYA', 457800, 'F', to_date('21-08-1993', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (58826560, 'PAUL JEAN MANRIQUE SERRANO', 'CRA 66  65-20', 520440, 'M', to_date('01-07-1990', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (63727640, 'LORENA PIEDAD PORTILLO PEREZ', 'CRA 5A  9-07  DANIEL JORDAN', 489600, 'F', to_date('03-02-1988', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (56044500, 'MILENA ANA BARBOSA BARBOSA', 'CRA 60 N? 66-67 BARRIO MONTEBELLO 6', 457800, 'F', to_date('18-01-1993', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (51091590, 'ARMANDO BELSAID NAVARRO PACHECO', 'LA HERMITA', 489600, 'M', to_date('17-08-1994', 'dd-mm-yyyy'), 640);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (18904160, 'FERNANDO WILLIAM AYALA SUAREZ', 'CRA 3 Nº 27A-60', 520440, 'F', to_date('03-07-1997', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28612240, 'YISETH YURLY SALAS GALVAN', 'CRA 6 26-30 AGUACHICA', 457800, 'F', to_date('12-03-1995', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (83733820, 'SANDRA AREVALO GALVIS', 'CRA66 7-627 EL FLORIAM ', 457800, 'F', to_date('31-08-1990', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28827220, 'ARMANDO OSCAR RINCON SANCHEZ', 'CRA 7N 2E-656 CEDRO II', 457800, 'M', to_date('20-07-1992', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (81936840, 'ORLANDO RAUL DUARTE MARTINEZ', 'CRA 7AN  3E-627  CEDRO II', 6654569, 'M', to_date('03-09-1967', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (95609930, 'JOSELIN JOHENNY RODRIGUEZ DANGOND', 'CRA 3 Nº 3-40 SAN IGNACIO', 489600, 'F', to_date('05-09-1993', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (6356050, 'AUDREY DOLLY VELASQUEZ BOCANEGRA', 'CRA 2A Nº 6-66 PASAJE EL HUMILLADERO', 489600, 'F', to_date('04-07-1993', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (6026040, 'CECILIA ANA VARGAS GUTIERRES', 'CRA 5 N 60-635 B. CRISTO REY ', 520440, 'F', to_date('09-03-1988', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (58822510, 'REYNALDO QUERO GONZALEZ', 'CRA 25 Nº 0B-07 INTERIOR 5, CONJUNTO ORO PURO', 520440, 'M', to_date('26-07-1984', 'dd-mm-yyyy'), 400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8911050, 'PEDRO GUSTAVO HERNANDEZ PEREZ', 'BULEVAR 6 CRA 20 Nº 6B-55 B. CABRERA', 553800, 'M', to_date('22-01-1998', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (78819740, 'JORGE CARLOS SANCLEMENTE ESTRADA', 'CRA 64  4E-23 APTO 702 CAOBOS', 6480000, 'M', to_date('15-09-1980', 'dd-mm-yyyy'), 134);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38824320, 'GUSTAVO RIVERA OBREGON', 'CRA. 26 #9-40 Barrio Libertad Bellavista', 2144279, 'M', to_date('29-04-1988', 'dd-mm-yyyy'), 7300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (98825970, 'ANGEL MIGUEL SILVA CALDERON', 'CRA 68E  20AN-63 URB. NIZA', 457800, 'M', to_date('30-10-1990', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (62760620, 'ZULAY JENNY FONCE LAMUS', 'CRA 66  7-36  TORCOROMA', 457800, 'F', to_date('19-11-1990', 'dd-mm-yyyy'), 260);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (23727250, 'MARIA CAROLINA GOMEZ PALENCIA', 'CRA 6AN  0E-62 FLORIDIANA II', 457800, 'F', to_date('06-02-1990', 'dd-mm-yyyy'), 260);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (89151860, 'PEDRO RAFAEL ZULUAGA BACCA', 'CRA 2E  0N-42 QUINTA BOSCH', 457800, 'M', to_date('18-07-1991', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (62760610, 'MILENA SANDRA ROJAS BUITRAGO', 'CRA 67  7-23  CAMILO TORRES', 457800, 'F', to_date('14-09-1990', 'dd-mm-yyyy'), 131);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (12760180, 'YANETH CARMEN  GARCIA', 'CRA 6B  6-62  PRADOS DEL ESTE', 457800, 'F', to_date('04-05-1989', 'dd-mm-yyyy'), 132);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (3739020, 'JOHANNA MARIA GUZMAN RAMIREZ', 'CRA 20N  65BE-37  SANTA ELENA', 457800, 'F', to_date('17-11-1991', 'dd-mm-yyyy'), 210);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (43739480, 'MILENA SANDRA SANDOVAL ANDRADE', 'CRA 3  CRA 63A  3-68  CARORA', 457800, 'F', to_date('17-05-1992', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (88822800, 'JAIRO JHON GARCIA HURTADO', 'BULEVAR.66 #65-29 ANIVERSARIO 6ETAPA', 904618, 'M', to_date('01-08-1985', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (46026460, 'CARIME DEISY FERNANDEZ GELVEZ', 'CALLE 3 3-674 SAN IGNACIO', 457800, 'F', to_date('19-12-1989', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (78821780, 'YORMANN SALCEDO GOMEZ', 'CRA 0A # 60-76 B/PUEBLO NUEVO', 498301, 'M', to_date('02-04-1984', 'dd-mm-yyyy'), 260);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (16026170, 'MILENA SANDRA OSPINA PEÑA', 'CALLE 8B # 2-46 PASAJE PINZON', 1498301, 'F', to_date('11-07-1985', 'dd-mm-yyyy'), 299);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (76039710, 'CAROLINA JUANA MERCADO FUENTES', 'CLL 0BN 58 TRANS.67', 498301, 'F', to_date('29-11-1987', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (36038390, 'KATHERINE BOADA RINCON', 'CRA 20AN # 4-607 URB/PRADOS DEL NORTE', 498301, 'F', to_date('22-12-1985', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (44966430, 'SENITH SERNA BARRIGA', 'MZ C CASA 66 AGUACHI', 316717, 'F', to_date('15-05-1985', 'dd-mm-yyyy'), 640);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (48822460, 'JAVIER FRANCISCO CASTRO PUERTO', 'CALL 26 68B-68', 498301, 'M', to_date('19-06-1984', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28800220, 'RENE ANGEL PARADA EUGENIO', 'CRA 60A # 65-29 ANIVERSARIO I', 498301, 'M', to_date('25-04-1985', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (78821760, 'EDGAR ARMESTO URQUIJO', 'BULEVAR.60 2-36 ALTO PAMP', 498301, 'M', to_date('07-08-1983', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (53981510, 'RAFAEL GUZMAN VERGARA', 'CALLE 64 # 60-27', 2486585, 'M', to_date('23-12-1966', 'dd-mm-yyyy'), 7700);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8831020, 'ERNESTO JAVIER ARROYO PEREZ', 'CRA 22N #4A-53 PRADOS NORTE', 737906, 'M', to_date('15-04-1990', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8009020, 'YOJANA KELLY OJEDA CONSUEGRA', 'CALLE 64 6-606 AGUACHICA', 584009, 'F', to_date('19-11-1988', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (88815880, 'GREGORIO JOSE CARRILLO LEAL', 'BULEVAR. 66  N?63-40 B/SAN AGUSTIN  (', 691571, 'M', to_date('22-05-1982', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (58825530, 'DAVID VICTOR  VERA', 'BLOQUE R6 #27 ATALAYA 6? ETAPA', 1691571, 'M', to_date('18-04-1990', 'dd-mm-yyyy'), 299);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (46038470, 'CAROLINA MARIA RANGEL VARGAS', 'CRA 63 #62-26 B. EL CONTENTO', 691571, 'F', to_date('20-08-1985', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (66038670, 'PILAR FRANCY LAGUADO GELVEZ', 'CRA 2 CRA 6 K-486', 635927, 'F', to_date('25-12-1985', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38828380, 'CARLOS JOSE  CONTRERAS', 'CRA 4 24B-63 MARABEL OCA#A', 584009, 'M', to_date('10-04-1986', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (96039960, 'KATERINE SHIRLEY RANGEL ARENAS', 'CRA 65AN #67E-63 URBANIZACION NIZA', 691571, 'F', to_date('27-07-1987', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (16038140, 'SULAY NANCY  CANO', 'CRA 23 65 78', 498301, 'F', to_date('20-03-1986', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (26039230, 'MARISELA RINCON MENDOZA', 'CRA 5 #3-53 LA PLAYA SAN CAYETANO', 1691571, 'F', to_date('01-01-1987', 'dd-mm-yyyy'), 299);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8803050, 'ENRIQUE MIGUEL LA TORRE SALAS DE', 'CALLE 5 #8-30 VILLA DEL ROSARIO', 1691571, 'M', to_date('16-04-1988', 'dd-mm-yyyy'), 299);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (88821840, 'ARMANDO JAHEL NIETO DAVILA', 'BULEVAR. 65 #8-65 SAN MIGUEL', 691571, 'M', to_date('05-08-1982', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (83772880, 'MILENA NIDIA PENAGOS LOPEZ', 'CRA 8CN  22-56  BARRIO EL BOSQUE', 553800, 'F', to_date('14-11-1987', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28803230, 'FABIAN NESTOR BERMUDEZ ROMERO', 'CRA 6 N? 7A-59 BARRIO GALAN', 1457800, 'M', to_date('12-07-1990', 'dd-mm-yyyy'), 299);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (68828640, 'AUGUSTO CARLOS GAONA ROPERO', 'CRA 64  26-60KDX 360-620 BARRIO COMUNEROS', 4037080, 'M', to_date('23-10-1979', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (31387390, 'FARID YECID FORERO BERMUDEZ', 'CRA 66AN  66AE-68 Apto. 6202 Edif. Santander Conj. Torres del Centenario - Guaimaral', 10547935, 'M', to_date('24-11-1989', 'dd-mm-yyyy'), 135);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (18811130, 'CAROLINA ABRIL JAIMES', 'CRA 26A   7-96  SAN MATEO', 5200440, 'F', to_date('30-01-1997', 'dd-mm-yyyy'), 299);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8811050, 'ALEXIS WILLIAM PEREZ HERNANDEZ', 'CRA 63E  8AN-24  B.  CIUDAD JARDIN', 520440, 'M', to_date('22-01-1997', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (76353710, 'CAROLINA JENNY NUÑEZ RICO', 'CRA 9 Nº 8-09 LA FERIA', 489600, 'F', to_date('21-04-1991', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (98827960, 'ALEXANDER JAIME JAIME', 'CRA 4A Nª 66-76', 489600, 'M', to_date('11-09-1982', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (11386190, 'PEDRO PABLO JIMENEZ COTE', 'CRA SANTANDER 62-874 ', 457800, 'M', to_date('24-04-1989', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (35531320, 'MIGUEL EDGAR PINZON VALENZUELA', 'CRA 22AN  4-46 URB/TASAJERO', 2526370, 'M', to_date('17-05-1967', 'dd-mm-yyyy'), 7300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (66333670, 'LUCY OSORIO ARDILA', 'CASA 25A  URBANIZACION TAMACOA', 5587986, 'F', to_date('04-02-1972', 'dd-mm-yyyy'), 7100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (64966650, 'FERNANDA ANDREA MURCIA ROJAS', 'CRA 3 #20-36 AGUACHICA', 691571, 'F', to_date('17-09-1986', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (3732080, 'LAUDIT QUINTERO AREVALO', 'CALLE 26 Nº 63-06', 520440, 'F', to_date('22-05-1976', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (36037370, 'LILIANA BERTHA LOPEZ CONTRERAS', 'CRA 23N #3-72 URB.TASAJERO', 457800, 'F', to_date('26-04-1981', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28506200, 'CAROLINA YELITZA VILLAMIZAR PABON', 'CRA 47 60B-42 CASA B-5 EL LIMONAR. PAT', 457800, 'F', to_date('06-09-1993', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (16028170, 'HELENA JANETH COLOBON GUERRERO', 'CRA 66E # 2N-609 L-6 PARQUES RESIDEN', 4002252, 'F', to_date('05-01-1968', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (71101750, 'DEL CARMEN MARIA GONZALEZ DUARTE', 'CRA 3 #2-39', 642720, 'F', to_date('06-04-1994', 'dd-mm-yyyy'), 240);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (51317510, 'ALEXANDER JOSE FARFAN MANZANO', 'CALLE 28 #8B-09', 596280, 'M', to_date('23-09-1990', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (48823420, 'JOHANY HERNANDO FLOREZ PARADA', 'CRA 63A #26-03 BARRIO LOPEZ', 618000, 'M', to_date('30-10-1986', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8827030, 'PEDRO JAIME OVALLOS NIÑO', 'CRA 6 #0N-60 LA MERCED', 596280, 'M', to_date('19-02-1992', 'dd-mm-yyyy'), 240);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (51094500, 'YERITZA NEYLA MEJIA DUQUE', 'CRA GUAIMARAL 6N #0-26 QUINTA ORIENTAL', 596280, 'F', to_date('19-06-1994', 'dd-mm-yyyy'), 460);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (23733220, 'YADIRA OBREGON SANCHEZ', 'CALLE 35 6-40 MARIA EUGENIA (AGUACHICA', 691571, 'F', to_date('18-02-1986', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (3005010, 'MELISA CHERYL PINZON RAMIREZ', 'BULEVAR. LIBERTADORES 9BN-96 CONJ. RES LINARE', 789486, 'F', to_date('19-05-1989', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (59692510, 'FERNANDO JOSE RIZZO QUIÑONES', 'CRA 7 9-62 AGUACHICA CESAR', 691571, 'M', to_date('28-10-1990', 'dd-mm-yyyy'), 640);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (53727580, 'STELLA LUZ MEZA PAEZ', 'CRA 8 #3-69 CRAJON-CUCUTA', 691571, 'F', to_date('06-06-1988', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (56039590, 'PATRICIA YENNI MORANTES GONZALEZ', 'CRA 8 #68A-26 SANTA TERESITA', 737906, 'F', to_date('27-08-1987', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38825300, 'FERNANDO DIEGO BLANCO RANGEL', 'CRA 6AN  0E-06  QUINTA BOSCH', 457800, 'M', to_date('19-08-1989', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (88824890, 'DAVID CRISTIAN VILLAMIZAR AFANADOR', 'CRA 4  67-62  LA PLAYA', 979200, 'M', to_date('06-05-1989', 'dd-mm-yyyy'), 135);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (81327830, 'OSWALDO JOAN RODRIGUEZ CARDENAS', 'CRA  9  5-65  BARRIO PANAMERICANA', 489600, 'M', to_date('19-03-1993', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38814380, 'CEDIEL PEREZ MARTINEZ', 'CRA 66N 66E - 35 VILLAS DE ALCALA A INT 6', 4227732, 'M', to_date('23-08-1978', 'dd-mm-yyyy'), 260);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (74966780, 'MARISOL LIMA ARCINIEGAS DE', 'CRA 9 #64-52  AGUACHICA', 789486, 'F', to_date('10-08-1988', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (68821680, 'MARTIN WILLIAM HERNANDEZ RAMIREZ', 'CRA 63 # 6-26 B/CARORA', 498301, 'M', to_date('20-08-1983', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (57950530, 'GREGORIO HERNANDEZ VILLAMIZAR', 'K 69 2-6 EL PORTICO', 498301, 'M', to_date('14-06-1977', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (1350000, 'ERNESTO FONTECHA CUBIDES', 'CRA 7BN # 65AE-68 B/SAN EDUARDO 6A ETAPA', 498301, 'M', to_date('11-05-1978', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (1979030, 'JAIRO JHON TORO AMAYA', 'CALLE 66A N? 7-22 URBANIZACION CENTRAL', 457800, 'M', to_date('11-06-1988', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (91348940, 'OMAR PUERTO MANRIQUE', 'CRA 66  #6-43  TORCOROMA', 1840151, 'M', to_date('26-08-1974', 'dd-mm-yyyy'), 7700);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (86044830, 'ANDREA PAEZ SANTOS', 'CRA 7E #4N-68 BARRIO LOS PINOS', 596280, 'F', to_date('18-05-1993', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (61098610, 'XIOMARA YURLEY CONTRERAS BOHORQUEZ', 'CRA 7 #6-22 CENTRO APTO 202', 596280, 'F', to_date('12-09-1994', 'dd-mm-yyyy'), 130);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (11327120, 'EDUARDO EDGAR PABON ALVAREZ', 'CRA 4 #7E-606 QUINTA ORIENTAL', 596280, 'M', to_date('27-03-1994', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (66353650, 'VIVIANA ANDREA MORA SARMIENTO', 'URBANIZACIÓN MANOLO LEMUS INT. 49', 618000, 'F', to_date('04-05-1991', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (91327900, 'GUILLERMO EDWARD PATIÑO YAÑEZ', 'CRA 65B #8-03 TIERRA LINDA', 618000, 'M', to_date('20-08-1993', 'dd-mm-yyyy'), 400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (78826730, 'SANTIAGO DIEGO TORRADO MARTINEZ', 'CRA 3 #9-53 BARRIO EL PARAMO', 618000, 'M', to_date('09-12-1991', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (71327750, 'IVAN SERGIO MURILLO RIVERA', 'CRA LIBERTADORES PRADOS II, CASA 76', 618000, 'M', to_date('27-05-1993', 'dd-mm-yyyy'), 290);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (13733180, 'SAMARA YUDDY SOLANO PINO', 'CRA 66  67-43  BARRIO MARTINETE', 553800, 'F', to_date('19-06-1986', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (9004090, 'DAVID SAMUEL CORREA VALENCIA', 'CRA 67 6E-75 BARRIO LA LAGUNA', 553800, 'M', to_date('26-06-1998', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (12762110, 'OMAIRA DIAZ GELVES', 'CRA 69A 7-05 BARRIO LA CABRERA', 553800, 'F', to_date('25-11-1978', 'dd-mm-yyyy'), 132);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (73727720, 'MARITZA CLAUDIA CARDENAS DUQUE', 'CRA 60 65-44 ANIVERSARIO I', 553800, 'F', to_date('06-06-1988', 'dd-mm-yyyy'), 410);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8827040, 'ENRIQUE RONALD GARCIA ZERPA', 'CRA 6 #6-40 BARRIO JUANA PAULA', 680040, 'M', to_date('09-12-1991', 'dd-mm-yyyy'), 2310);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (48803430, 'ARMANDO JESUS DELGADO PORTILLA', 'CRA 3 #3AN-60', 618000, 'M', to_date('12-03-1993', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (83732850, 'ESTELA SUGEINE RODRIGUEZ GAONA', 'CRA CIRCUNVALAR #39-365', 618000, 'F', to_date('20-07-1983', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (82773820, 'LORENA JAIMES PEREZ', 'CALLE 4 #2B-69 BARRIO SANTA MARTA', 618000, 'F', to_date('05-12-1991', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (71327760, 'ALEXIS FRANCISCO CARDENAS CAMARGO', 'CRA 7 #7-25 VILLA VERDE', 642720, 'M', to_date('07-04-1993', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28822230, 'ALEXANDER JORGE SAYAGO BLANCO', 'BLOQUE 22 #68AN-83 LOTE 60 ZULIMA II ETAPA', 642720, 'M', to_date('18-02-1985', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (81004840, 'EFRAIN BRYAN ARENAS MURILLO', 'CRA 68 #7A-89 BARRIO SAN MIGUEL', 642720, 'M', to_date('03-05-2000', 'dd-mm-yyyy'), 362);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (98830980, 'EDINSON OJEDA VARGAS', 'CRA 32 #0E-08 LA CORDIALIDAD', 642720, 'M', to_date('20-10-1989', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (1327040, 'JAVIER FRANCISCO CLAVIJO SANTOS', 'CRA 3E  6BN-69 APTO 206 CEDRO II', 642720, 'M', to_date('17-03-1994', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (39201300, 'STELLA LAURA ARCHILA MARTINEZ', 'CALLE 68 #7-94', 618000, 'F', to_date('17-04-2000', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (66026600, 'ALEYDA TAILIN FLOREZ JAIMES', 'CLL 9 N?  66-460  BARRIO UNIDOS   PAMPLO', 457800, 'F', to_date('05-08-1990', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (13744130, 'MARIA LILIANA ORTIZ GALVAN', 'CRA 6  CRA 4   63A-47 CHAPINERO', 489600, 'F', to_date('01-04-1991', 'dd-mm-yyyy'), 460);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (61076640, 'ALFONSO LUIS LAMBERTINEZ MARTINEZ', 'CRA 63 #68-60B CUNDINAMARCA', 707400, 'M', to_date('25-01-1988', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (21339290, 'LEONEL LOPEZ PABUENA', 'CRA 9 #6N-68 ALFONSO LOPEZ', 707400, 'M', to_date('14-01-1992', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (49252490, 'JULIO CARLOS PADILLA RAMIREZ', 'CRA 26 #8-640 ARNULFO BRICEÑO', 707400, 'M', to_date('10-11-1983', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28831220, 'JACOBO IVAN RODRIGUEZ GELVEZ', 'BLOQUE A LOTE 2 CARMEN DE TONCHALA', 707400, 'M', to_date('08-05-1993', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (46043470, 'ALEYDA MARIA PAEZ GOMEZ', 'BLOQUE 0 LOTE 69-2 BARRIO TUCUNARE', 6007462, 'F', to_date('10-10-1984', 'dd-mm-yyyy'), 7700);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (47227430, 'FABIO LEONARDO MERCADO ALBA', 'BLOQUE 26  LOTE 66 BARRIO CIUDAD JARDIN', 553800, 'M', to_date('01-08-1990', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (23739250, 'VIVIANA ANDREA ROJAS CONTRERAS', 'TAMARINDO CLUB CASA P-5  - VILLA DEL ROSARIO', 520440, 'F', to_date('26-06-1992', 'dd-mm-yyyy'), 132);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (86044860, 'CAROLINA PAEZ SANTOS', 'CRA 7E #4N-68 BARRIO LOS PATIOS', 520440, 'F', to_date('18-05-1993', 'dd-mm-yyyy'), 133);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (3718040, 'FERNANDA LINA RODRIGUEZ GARRIDO', 'CALLE 60B #65-46', 520440, 'F', to_date('06-12-1991', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (11014190, 'LICETH MAGDA MALDONADO OSPINA', '0', 1914499, 'F', to_date('04-01-1997', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (21376220, 'JAIRO JOHN DELGADILLO SAENZ', 'CALLE 66  60-65  BARRIO TESORO', 520440, 'M', to_date('19-04-1992', 'dd-mm-yyyy'), 640);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28831280, 'ENRIQUE JOSE CABALLERO CASTILLO', 'CRA 36 6-92', 19553800, 'M', to_date('30-11-1993', 'dd-mm-yyyy'), 130);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (9008050, 'PATRICIA NUBIA GELVES CARREÑO', 'CALLE 65 5N-25 ', 596280, 'F', to_date('22-10-1998', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (13718180, 'LICETH ANA AREVALO QUINTERO', 'CALLE 66  65-243 LA PIÑUELA', 553800, 'F', to_date('28-01-1996', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38827370, 'JORGE JULIAN CHAPARRO TORRES', 'CRA 66C  66-35 URBANIZACIÓN SAN JOSÉ DE TORCOROMA', 2961281, 'M', to_date('04-11-1992', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (61345690, 'HERNANDO EDGAR VASQUEZ RUIZ', 'CRA 4N # 9E - 83 Apartamento 206', 12086036, 'M', to_date('12-10-1969', 'dd-mm-yyyy'), 7100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (61098690, 'LORENA KAREN LAGOS ALFONSO', 'CRA 2 #32-40 AGUACHICA (CESAR)', 596280, 'F', to_date('24-10-1998', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (48031470, 'MARIO JULIO RIVERA ESCOBAR', 'CRA 63 #2E-95 LOS CAOBOS', 618000, 'M', to_date('22-08-1993', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (41350470, 'RICARDO GERSON USECHE JAIMES', 'CRA 22AN # 2 - 58 Prados Norte', 2076760, 'M', to_date('09-10-1978', 'dd-mm-yyyy'), 7700);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (16026160, 'DORA LIGIA VERA VILLAMIZAR', 'TRAS #66A-03 BARRIO EL PROGRESO', 680040, 'F', to_date('07-02-1983', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (61094660, 'PEDRO CARLOS CONTRERAS VELAZCO', 'BLOQUE D65, LOTE 4, TORCOROMA II', 596280, 'M', to_date('14-01-1995', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (68830640, 'ALEXANDER MARIO GARCIA MORA', 'CRA 5 N° 65-39 TOLEDO- NORTE STDER', 642720, 'M', to_date('07-04-1990', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28081240, 'MELVIN MICHAEL FUENTES RODRIGUEZ', 'CRA 62E #6-34 EDIFICIO FENIX APTO 306', 596280, 'M', to_date('10-04-1993', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28813250, 'ALEXIS JONATHAN CAMACHO SEPULVEDA', 'CRA 6 #5-30 BARRIO SANTANDER', 596280, 'M', to_date('01-03-1994', 'dd-mm-yyyy'), 260);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (93739930, 'BIBIANA LEIDY QUINTERO SUAREZ', 'CRA 63AN #9AE-65 BARRIO GUAIMARAL', 596280, 'F', to_date('23-02-1993', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (49135490, 'ORLANDO JULIAN SEPULVEDA TOLOZA', 'CRA 4A #66A-46 APTO 206 SAN CRISTOBAL, MONTEVERDE', 642720, 'M', to_date('25-08-1991', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (9102040, 'TATIANA MERLY SERNA ANGARITA', 'CRA 3 #67-48 AGUACHICA', 596280, 'F', to_date('23-04-1999', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (76038730, 'SOFIA MAYRA RAMIREZ NIÑO', 'BLOQUE 3 CRA 2A #60A-32 LOS PATIOS', 596280, 'F', to_date('02-07-1986', 'dd-mm-yyyy'), 460);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (53282570, 'DEL CARMEN LILIBETH HERNANDEZ MONTIEL', 'CONJUNTO RESIDENCIAL BOLIVAR APTO 6602', 596280, 'F', to_date('01-07-1986', 'dd-mm-yyyy'), 200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (1005050, 'SOLANGY ANDREA CALDERON ROMERO', 'CRA 66 N°4-74 BARRIO VISTA HERMOSO', 596280, 'F', to_date('04-07-1994', 'dd-mm-yyyy'), 240);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (81095800, 'FERNEY CARLOS PEREZ CARRILLO', 'CRA 6 #64-88 URB. CAÑO FISTOLE - SAN MARTIN', 707400, 'M', to_date('06-02-1999', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (61098680, 'DEL MAR ELINOR SALAZAR PINO', 'CALLE 60 #66E-600 APTO 206, EDIFICIO MONSERRATE', 680040, 'F', to_date('05-03-1998', 'dd-mm-yyyy'), 1100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (19206140, 'STEFANIA YOLANY RODRIGUEZ VEGA', 'CALLE 44 #7C-26 BARRIO VILLA MAR', 618000, 'F', to_date('31-08-2000', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (29153230, 'FERNEY RICHARD SANDOVAL MORA', 'CALLE 9W #64-42 MONTERREDONDO', 642720, 'M', to_date('04-11-1992', 'dd-mm-yyyy'), 135);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (71970790, 'LEONARDO AGUDELO SANCHEZ', 'CALLE 36 #49-66 CENTRO', 707400, 'M', to_date('25-07-2000', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (75401750, 'CAMILO JUAN JARAMILLO ROSALES', 'CALLE 53 #636A-60 SULTANA B APTO 202 - BOGOTA', 596280, 'M', to_date('16-12-1993', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (73739790, 'YESENIA ANGELA VALENCIA BERMUDEZ', 'CRA 9 #67A-36 BARRIO ANIVERSARIO II', 520440, 'F', to_date('16-12-1992', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (18826160, 'JORGE MAX GONZALEZ RINCON', 'CRA 60 AN #66AE-62 BARRIO GUAIMARAL', 520440, 'M', to_date('03-04-1991', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (63734670, 'ANGELICA LUZ CACERES ROJAS', 'CRA 8 #63-02 BARRIO CORNEJO', 520440, 'F', to_date('03-08-1993', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (13739140, 'BELEN NYDIA CONTRERAS GELVEZ', 'CRA 7 #6-47 LOS TRECES', 553800, 'F', to_date('20-05-1992', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (29007270, 'ARLEY JHON PEÑARANDA CARVAJALINO', 'CALLE 64 #67-63 BARRIO 9 DE OCTUBRE', 553800, 'M', to_date('13-10-1998', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (19004120, 'ESTHER MARIA MORA RINCON', 'CRA 3 #32-35 AGUACHICA', 553800, 'F', to_date('29-06-1998', 'dd-mm-yyyy'), 640);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28803200, 'DAVID JESUS CRUZ CARRILLO', 'CRA 5 #3-27 BARRIO NUEVO PAMPLONITA', 596280, 'M', to_date('29-09-1990', 'dd-mm-yyyy'), 131);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (63739620, 'AMPARO JUDITH SILVA NORIEGA', 'CRA 65 #0-52 COMUNEROS', 707400, 'F', to_date('30-03-1992', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (13727190, 'ELIZABETH FLOREZ CONTRERAS', 'CALLE 6 #63-36 BARRIO BARCO', 707400, 'F', to_date('20-02-1988', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (6042080, 'GUADALUPE ZULAY MONTAÑEZ MARIÑO', 'BULEVAR 3 #2-73 CENTRO CHINACOTA', 707400, 'F', to_date('06-10-1986', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (24967280, 'MERCEDES MARIA MEJIA VALLEJO', 'CALLE 9, #2-603 BARRIO EL BOSQUE (AGUACHICA)', 618000, 'F', to_date('24-03-1993', 'dd-mm-yyyy'), 640);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (63739630, 'CAROLINA BARONA ACEVEDO', 'CRA 8A #68A-70 BARRIO LA CABRERA', 618000, 'F', to_date('18-03-1992', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (9101020, 'LIZETH VILLEGAS ROSSO', 'CALLE 22 #3-56 AGUACHICA (CESAR)', 553800, 'F', to_date('21-03-1999', 'dd-mm-yyyy'), 640);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (48822430, 'LEONARDO EDGAR RODRIGUEZ LOPEZ', 'CRA 8 62-40 BARRIO LOMA DE BOLIVAR', 596280, 'M', to_date('12-03-1984', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (61327640, 'RICARDO JOSE PRADO MALAGON', 'CRA 6 #6-70 BARRIO TRIGAL DEL NORTE', 596280, 'M', to_date('21-03-1993', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (29012280, 'PEDRO MARIO PEREZ ACERO', 'CRA 62 #9E-45 BARRIO GUAIMARAL', 596280, 'M', to_date('16-03-1999', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (13733120, 'AMPARO TORRES BACCA', 'CRA 66 #26-604 URB. ACACIAS (AGUACHICA', 584009, 'F', to_date('20-07-1984', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (58823540, 'ESTEBAN MANUEL OSORIO SUAREZ', 'CRA 23B 6B-36 B/VIRGILIO BARCO', 635927, 'M', to_date('15-03-1987', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (39147350, 'ERNESTO FREDDY VARGAS DITTA', 'CRA 2 NORTE 37-66 B/VILLAMARE', 584009, 'M', to_date('05-03-1983', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (55313590, 'ALEXANDRA JESSICA LINARES BEJARANO', 'CRA 3 #9E-29 QUINTA ORIENTAL', 642720, 'F', to_date('31-03-1994', 'dd-mm-yyyy'), 290);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (18826110, 'HUMBERTO ALVARO SARMIENTO TORRES', 'Torre B  Margaritas Apto 606 B  Barrio Natura ', 4227732, 'M', to_date('22-12-1990', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (6045050, 'ESPERANZA NHORA BOTELLO GONZALEZ', 'CRA 6E #6-38 BARRIO CEDRO', 642720, 'F', to_date('02-03-1994', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (19152150, 'ALFONSO FREDDY RUEDA MONTAGUT', 'CRA 3N #67-55 QUINTA GRANADA (MONTEVERDE)', 642720, 'M', to_date('07-11-1991', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8813090, 'CARLOS LUIS RINCON ZUÑIGA', 'CRA 6 #6-260 BARRIO MOTILONES', 680040, 'M', to_date('13-06-1990', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (29206230, 'KATHERINE LIZETH ROCA MARTINEZ', 'CRA 2 #8-05 ALTO PAMPLONITA', 618000, 'F', to_date('09-09-2000', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38007380, 'IVAN SERGIO IBARRA ROJAS', 'CRA 4 62E-58 BARRIO COLSAG', 596280, 'M', to_date('11-02-1993', 'dd-mm-yyyy'), 135);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (71053760, 'ROSA LORENA ROCHA BAÑOS', 'CRA 6 69-46 AGUACHICA', 596280, 'F', to_date('20-06-1994', 'dd-mm-yyyy'), 640);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (71095790, 'ALEXANDER WILMER GOMEZ JAIMES', 'CRA 0E #6-67 BARRIO BOGOTA', 618000, 'M', to_date('07-05-1996', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (26044200, 'JOHANA ANGARITA CONTRERAS', 'BLOQUE 64 LOTE 7 COLINAS', 707400, 'F', to_date('19-04-1988', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (48825410, 'ALEXANDER JOSE RUEDA MEDINA', 'CRA 8AN 3E-67 CEDRO II', 553800, 'M', to_date('13-01-1990', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (96044910, 'PAOLA ELIANA ALVAREZ MENDOZA', 'CRA 2 30A-60 SAN RAFAEL', 553800, 'F', to_date('02-02-1994', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8827020, 'JORGE WILSON BARRERA JAIMES', 'CRA 66EN 64-52 CRA LAS AMERICAS', 553800, 'M', to_date('10-03-1992', 'dd-mm-yyyy'), 131);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (33739360, 'JUDIT ERIKA ESPITIA DELGADO', 'CRA 2 64-72 BARRIO SAN LUIS', 553800, 'F', to_date('19-10-1992', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (78822720, 'JORGE CARLOS CASTAÑEDA SANABRIA', 'CRA  63AN  #4-77 URB.GARCIA HERREROS', 691571, 'M', to_date('10-09-1985', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (93727990, 'JOHANNA NINI DUARTE ARIAS', 'CRA 9BN #7AE-86 B/GUAIMARAL', 584009, 'F', to_date('23-04-1989', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8827070, 'JORGE JAIME VILLAMIZAR GENE', 'CRA 7 NORTE #3E-30 CEDRO II', 707400, 'M', to_date('31-05-1992', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (41090470, 'TERESA MARIA OMAÑA ACEVEDO', 'CRA 9 #5-49 MOTILONES', 707400, 'F', to_date('25-07-2000', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (11085160, 'SUJEY LEIDY OLANO RINALDI', 'CRA 7 #2-77 BARRIO LOS TRECES', 553800, 'F', to_date('14-08-1994', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (51317550, 'ALEXANDER FABIAN ANGARITA VERGEL', 'CALLE 27 N° 65-03 BARRIO COMUNEROS', 596280, 'M', to_date('16-10-1991', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (19105100, 'LORENA SINDY AFANADOR CRIADO', 'KDX 676 BARRIO LA PERLA', 596280, 'F', to_date('27-06-1999', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (34967330, 'PATRICIA SANDRA CORRALES VILLALBA', 'CRA 6 N? 3-64', 457800, 'F', to_date('11-09-1993', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28704230, 'RUBIELA EILYN AFANADOR LOBO', 'CRA 6N 29-23 AGUACHICA', 457800, 'F', to_date('10-07-1995', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (91349920, 'GUILLERMO LUIS VILLAMIZAR QUINTERO', 'CRA 68N 2-67  LOS ANGELES', 457800, 'M', to_date('11-02-1978', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (22759290, 'JOHANA BERTHA IBARRA ORTEGA', 'CRA 6N #4-60 BARRIO LA MERCED', 642720, 'F', to_date('30-08-1989', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (2760080, 'PATRICIA YENNY MENDEZ HIGUERA', 'CRA 8BN 62E-606 CIUDAD JARDIN', 553800, 'F', to_date('24-09-1989', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (12760190, 'MAGRED INGRID BOADA MORINELLY', 'CRA 26 AN 66BE-63 URBANIZACION NIZA', 553800, 'F', to_date('03-12-1989', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38824340, 'ALEXANDER WILLIAM RANGEL PEDRAZA', 'CRA 66E 5AN-604 SANTA LUCIA', 553800, 'M', to_date('26-07-1988', 'dd-mm-yyyy'), 260);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (6045040, 'ESPERANZA NIDIA MORA MORALES', 'CRA 66, CRA 62B 66-63 BARRIO TORCOROMA', 553800, 'F', to_date('11-01-1994', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (88825860, 'MANUEL JOSE GAMBOA MORA', 'CRA 0B 22-44 URBANIZACION EL ROSAL', 553800, 'M', to_date('17-06-1990', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (36039340, 'MILENA ZULAY VILLAMIZAR OVIEDO', 'CRA 66 #8-43 MONTEBELLO 6', 642720, 'F', to_date('05-07-1987', 'dd-mm-yyyy'), 362);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (86044810, 'YASMIN LEIDY BARRERA NAVARRO', 'CRA 2 N° 4-02 BARRIO COMUNEROS', 680040, 'F', to_date('14-08-1993', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (21090220, 'BERNANDO RAFAEL LIZARAZO SIERRA', 'CRA 7 CRA 26B N° 6-52 BARRIO SANTA BARBARA', 680040, 'M', to_date('12-08-2000', 'dd-mm-yyyy'), 4330);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (96044930, 'CAROLINA DIANA VERGEL TRIANA', 'CRA 2E #62A-62 BARRIO CAOBOS', 520440, 'F', to_date('27-10-1993', 'dd-mm-yyyy'), 200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (58827510, 'SANTIAGO MARCO VALERO CUELLAR', 'CRA 4N #66E-602 BARRIO QUINTA ORIENTAL', 520440, 'M', to_date('07-09-1992', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (61098650, 'JORGE MIGUEL ROJAS ALVAREZ', 'CALLE 60 #66-70 BARRIO EL CARRETERO', 680040, 'M', to_date('25-09-1996', 'dd-mm-yyyy'), 1400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (69151680, 'EDINSON PINTO DUARTE', 'BLOQUE B LOTE 6 AZUBULEVARIZ 2 ETAPA - EL ZULIA', 707400, 'M', to_date('15-04-1991', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (43560470, 'MARIA YULY PINO UNFRIED', 'BLOQUE F67 CASA 8 TORCOROMA III', 739200, 'F', to_date('17-08-1986', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (1114090, 'PEDRO OSCAR RESTREPO CARDENAS', 'CRA 5 NORTE #5E-69 LOS PINOS', 530550, 'M', to_date('23-01-2000', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (68821650, 'JORGE CARLOS DIAZ PORRAS', 'CRA 66 68-66 ANIVERSARIO II', 423092, 'M', to_date('18-03-1983', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (34966380, 'HELENA VELEZ CARDENAS', 'CRA 6 #25-47', 635927, 'F', to_date('30-08-1984', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (74966790, 'JULIETA GUEVARA CASTRO', 'CRA 9N  40-65', 635927, 'F', to_date('14-10-1988', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (68822620, 'MARIA TERESA QUIROZ IBARRA', 'CRA 28 3-95', 691571, 'M', to_date('24-06-1985', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38822370, 'ANTONIO SANDRO ARMESTO URQUIJO', 'BULEVAR.60 #2-36', 691571, 'M', to_date('13-03-1985', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (18820110, 'ALEXANDER ROBERTO GARCIA BECERRA', 'CRA 65A  8-69  Tierra Linda', 2184300, 'M', to_date('06-02-1981', 'dd-mm-yyyy'), 7700);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (25471280, 'LUIS JAIME RODRIGUEZ LAZARO', 'CALLE 64 Nº 2-53 B. JUAN XXIII', 520440, 'M', to_date('26-08-1990', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (73220730, 'CAROLINA LEDDI MANTILLA CORZO', 'CRA 4  62-59  APTO 206 CENTRO', 489600, 'F', to_date('15-05-1991', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28800260, 'ENRIQUE JAVIER GARCIA SOTO', 'CRA 9N  62E-35  CIUDAD JARDIN', 737906, 'M', to_date('25-12-1987', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (68824670, 'HUGO VICTOR GALEANO LEAL', 'CRA 5A  66A-26 URB. SAN MARTIN', 737906, 'M', to_date('10-08-1988', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (98823910, 'JORGE JORGE JORDAN CASTIBLANCO', 'CRA 6 AN Nº 2E-44 BARRIO QUINTA', 489600, 'M', to_date('10-11-1987', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (66044690, 'CAROLINA SUSANA FIGUEROA MOLINA', 'DIAGONAL 64E Nº 65N-30 ZULIMA III ETAPA', 489600, 'F', to_date('20-07-1993', 'dd-mm-yyyy'), 240);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (32715330, 'JORGE CARLOS VILLAMIZAR ABREO', 'CRA 6AN Nº 6E-65 BARRIO QUINTA ORIENTAL', 489600, 'F', to_date('20-01-1993', 'dd-mm-yyyy'), 210);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38826380, 'JORGE FRANCISCO MONCADA RAMIREZ', 'CRA 26AN Nº 3-76', 489600, 'M', to_date('13-06-1991', 'dd-mm-yyyy'), 210);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (13744180, 'DARY LUZ PABON VILLAMIZAR', 'CRA 9E Nº 9N -87 GUAIMARAL', 489600, 'F', to_date('25-03-1991', 'dd-mm-yyyy'), 133);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (53727570, 'JUANITA CARDENAS CARRIZOSA', 'BULEVAR O Nº 20-25 BARRIO BLANCO', 1040880, 'F', to_date('07-03-1988', 'dd-mm-yyyy'), 135);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (16356190, 'ELEONORA BAUTISTA GARCIA', 'CALLE 23 Nº 36-63', 489600, 'F', to_date('19-03-1993', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38826390, 'PEDRO JULIAN FUENTES RAMIREZ', 'CRA 4BN Nº 65E-05 II ETAPA', 489600, 'M', to_date('24-06-1991', 'dd-mm-yyyy'), 210);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (73739770, 'CAROLINA DIANA ZANNA MALDONADO', 'BULEVAR 7 Nº 66-74 PRIMERA ETAPA URB TIERA LINDA', 489600, 'F', to_date('01-04-1993', 'dd-mm-yyyy'), 400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (26029240, 'STELLA BERMUDEZ HERRERA', 'BULEVAR. DEL RIO 5AN-90  CASA C-65 CONDOMINIO', 5587986, 'F', to_date('07-01-1971', 'dd-mm-yyyy'), 260);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (88827840, 'JESUS HENRY BAYONA CAICEDO', 'CRA 62 Nº 7-32 ', 520440, 'M', to_date('27-07-1981', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (93732950, 'GEYNNIS LINA PINEDA CABRALES', 'CRA 7Nº 25-46 EL TOPE', 520440, 'F', to_date('04-08-1983', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (83733870, 'JOHANA NINI ACOSTA BARBOSA', 'CALLE 7 Nº 67-63', 520440, 'F', to_date('09-10-1990', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28827280, 'WILMER LUNA BOADA', 'CRA 2   9-66 INT 26 COND LA RIVERA', 489600, 'M', to_date('27-08-1992', 'dd-mm-yyyy'), 132);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8825050, 'WILFRIDO ATUESTA CONTRERAS', 'BLOQUE 68  LOTE 67 PALMERAS ATALAYA', 489600, 'M', to_date('04-07-1989', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (77572710, 'HUMBERTO JAVIER PICON CUADROS', 'CRA 4AN  7E-62 LOS PATIOS', 489600, 'M', to_date('23-07-1991', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (62760600, 'LORENA SANDY CARVAJAL GALVIS', 'BLOQUE 57  LOTE 2', 489600, 'F', to_date('14-12-1990', 'dd-mm-yyyy'), 132);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (58827580, 'JULIAN PEDRO NIÑO GARCIA', 'CRA 23N  3-602 URB. TASAJERO', 489600, 'M', to_date('08-01-1993', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38826340, 'CARLOS JUAN ROJAS GOMEZ', 'BULEVAR. KENNEDY MZ 4 LT 6 3RA ETAPA ATALAYA', 489600, 'M', to_date('02-06-1991', 'dd-mm-yyyy'), 210);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (33729360, 'MARIA ANGELICA PINTO CAMACHO', 'CRA 22N  5-89  PRADOS NORTE', 429600, 'F', to_date('20-10-1991', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (93727970, 'PAOLA FERREIRA SERRANO', 'CRA 8 N? 66-48  CENTRO', 429600, 'F', to_date('08-04-1989', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (3744060, 'MARGARITA MARIA ROLON SANCHEZ', 'BLOQUE 69 LOTE 29 CIUDAD JARDIN', 457800, 'F', to_date('02-09-1990', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (4965020, 'DEL SOCORRO YANETH GUZMAN VARGAS', 'CRA 6  7-69', 2156764, 'F', to_date('09-12-1966', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (41344420, 'BARMORE ELISEO NEMOJON DURAN', 'Manzana H Lote 62 Urbanización Sierra', 1032457, 'M', to_date('30-09-1967', 'dd-mm-yyyy'), 7700);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8826080, 'ZE-SERGIO ALBER JIMENEZ MARQUEZ', 'BULEVAR. 3A 2N-65 PESCADERO', 904618, 'M', to_date('22-12-1990', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8803060, 'MAURICIO JUAN NAVARRO JULIO', 'CRA 3 N? 27-04 BARRIO CAMILO TORRES', 489600, 'M', to_date('23-05-1996', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (33744350, 'JOHANNA ANGELICA OSORIO ROJAS', 'CRA 6BM  3E-89 CEDRO II', 2038703, 'F', to_date('18-06-1991', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (78824700, 'JAVIER RAFAEL OSORIO ROJAS', 'CRA 6BM  3E-89 CEDRO II', 586944, 'M', to_date('22-01-1989', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (2759090, 'ANDREA TATIANA AMAYA RODRIGUEZ', 'MZ 39 66E-67 II ETEPA', 429600, 'F', to_date('15-04-1988', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (26038290, 'ALEXANDRA CLAUDIA ESPINEL GARCIA', 'CLL 5 6-68 ', 429600, 'F', to_date('08-01-1986', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (15471180, 'FERNANDO ERWIN GAONA QUINTERO', 'CRA 63B #26-62 OCA?A', 429600, 'M', to_date('28-05-1990', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (12759180, 'PIERINA AMBAR RIVERA SANCHEZ', 'CRA 20 64-25 ALFONSO LOPEZ', 429600, 'F', to_date('26-04-1989', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (21372230, 'JORGE CARLOS NARANJO PALACIO', 'BULEVAR. 4E 0-26 QUINTA BOCH', 429600, 'M', to_date('30-10-1987', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (23729200, 'VIVIANA ARLEN HERNANDEZ CHARRIA', 'CRA 6BN 64E-63 PRADOS II', 429600, 'F', to_date('05-07-1991', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (16033170, 'SULAY MYRIAM ARCHILA ESCOBAR', 'CRA 6N 64E-56 PRADOS II', 429600, 'F', to_date('29-08-1977', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (46044460, 'JOHANA DEISY RESTREPO BALAGUERA', 'CRA 6  K-626 D-23  LLANITOS', 489600, 'F', to_date('24-04-1992', 'dd-mm-yyyy'), 133);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28826290, 'NORIEL HOLGER REYES CAMARGO', 'CRA 5AN #5-20 COLPET', 789486, 'M', to_date('26-04-1991', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (78824790, 'CARLOS JEAN RODRIGUEZ FOLIACO', 'BULEVAR 9E #8AN--30', 789486, 'M', to_date('24-03-1989', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (48824490, 'PEDRO EDUARDO GRANADOS CHACON', 'CRA 66A #6E-60 CAOBOS', 398400, 'M', to_date('21-10-1988', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (43744460, 'DIANA CAÑAS PATIÑO', 'CRA 2 8-77 BARRIO NIÑA CECI', 520440, 'F', to_date('02-09-1990', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (1347000, 'WALDO DUARTE GOMEZ', 'Av. 26  66A-66  Barrio Gaitán', 2243858, 'M', to_date('25-05-1972', 'dd-mm-yyyy'), 7200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (96662980, 'HERNAN JESUS MARTINEZ LLANES', 'CRA 60E  4N-40', 489600, 'M', to_date('16-07-1993', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (68824640, 'SANTIAGO DIEGO BAUTISTA MALDONADO', 'CRA 8  65-22 BARRIO EL PARAMO', 489600, 'M', to_date('03-12-1988', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (59691540, 'JORGE MAURICIO SANCHEZ OROZCO', 'CRA 66E  6-23  QUINTA ORIENTAL', 489600, 'M', to_date('07-01-1990', 'dd-mm-yyyy'), 131);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (63732620, 'MILADY LLAIN PACHECO', 'PRADOS CLUB INT 6  6-97', 489600, 'F', to_date('20-07-1981', 'dd-mm-yyyy'), 131);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38826310, 'PIERO JEAN NUÑEZ RESTREPO', 'CRA 9AN  3E-07 CEDRO II', 489600, 'M', to_date('02-05-1991', 'dd-mm-yyyy'), 400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (18827130, 'ALONSO JAIRO DIAZ QUINTERO', 'CRA 6N  4-60  LA MERCED', 489600, 'M', to_date('17-06-1992', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8831000, 'JAIME JHON ZULUAGA RAMIREZ', 'BULEVAR. 6 20-48', 904618, 'M', to_date('20-05-1989', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (33729370, 'XIMENA LUCY ASCANIO GOMEZ', 'CRA 60 35-68', 520440, 'F', to_date('17-11-1991', 'dd-mm-yyyy'), 400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (86354880, 'ANGELICA JOICE HERNANDEZ SANDOVAL', 'CRA 64 Nº 32C-32 BARRIO SAN ALONSO', 1107600, 'M', to_date('09-01-1992', 'dd-mm-yyyy'), 640);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (99150950, 'SANTIAGO BECERRA ARDILA', 'CALLE 63 Nº 7-06 LOS ALTILLOS', 1040880, 'F', to_date('06-09-1990', 'dd-mm-yyyy'), 131);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (1393060, 'PEDRO JAIME VELASCO FONSECA', 'CALLE 66 Nº 60-65 BARRIO EL PARAISO', 520440, 'M', to_date('12-03-1993', 'dd-mm-yyyy'), 640);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (46030420, 'ELENA MARTHA QUINTERO PULIDO', 'BULEVARv. 67E  3N-45 CASA A64  CONDOMINIO EL TESORO', 6526390, 'F', to_date('30-04-1971', 'dd-mm-yyyy'), 260);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (62687620, 'ISABEL ANA GUARNIZO PEREZ', 'Km 2 Conjunto Campestre Sierra Nevada Casa F-89', 3043951, 'F', to_date('06-03-1971', 'dd-mm-yyyy'), 130);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (83723870, 'CLAUDIA FLOREZ OSPINA', 'CRA 3 #22-655 MARABELITO', 429600, 'F', to_date('15-12-1983', 'dd-mm-yyyy'), 260);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28606250, 'GUILLERMO JESUS CLARO TRIANA', 'CRR 60B #66-09', 429600, 'M', to_date('11-09-1994', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (41387460, 'PEDRO RICARDO PEÑARANDA PINZON', 'CRA 26N #66BE-86 URB NIZA', 398400, 'M', to_date('13-10-1989', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (78822790, 'DARIO HERNAN MUÑOZ RAMIREZ', 'BULEVAR 66AE 65N-54 VILLA DEL RIO NIZA', 429600, 'M', to_date('27-10-1985', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (33739300, 'SHEILA ARIAS ZAFRA', 'CRA 4  66A-76 MONTE BELLO I', 520440, 'F', to_date('04-10-1992', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (23739260, 'MARCELA JESSIKA SANDOVAL JAIMES', 'MZ Nº4 Nº 24 ATALAYA PRIMERA ETAPA', 520440, 'F', to_date('22-08-1992', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (3729000, 'JOHANNA LIZBETH ROJAS PEREZ', 'CLL 26N Nº 6-53 PRADOS DEL NORTE', 520440, 'F', to_date('06-08-1991', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (3739030, 'NURIELA MANTILLA VILLLAMIZAR', 'CLL 60E Nº 5-76 BARRIO QUINTA ORIENTAL', 520440, 'F', to_date('16-04-1992', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (2760060, 'TATICUAN QUELI  MOSQUERA', 'BULEVAR 5 Nº 4-664 LA VICTORIA', 520440, 'F', to_date('12-09-1989', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (76663730, 'JACINTO ANTONIO DUARTE CARVAJALINO', 'CRA 60 Nº 4-46 URB NUEVO ESCOBAL', 520440, 'M', to_date('26-10-1993', 'dd-mm-yyyy'), 132);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28812270, 'LISETH CLAUDED CLAVIJO JAIMES', 'CRA 6 NORTE Nº 34-59, BARRIO MARIA EUGENIA', 520440, 'F', to_date('15-03-1997', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (66760610, 'AUGUSTO CESAR ESTEBAN MUÑOZ', 'CRA 3N No. 2E-26 Barrio Castellana', 5677393, 'M', to_date('07-03-1967', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (51345550, 'MISAEL SILVA RUBIO', 'CRA 5N # 7E-69 BARRIO CEDRO II', 8098658, 'M', to_date('30-03-1969', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (91327920, 'EMMANUEL JUAN JAIMES RANGEL', 'BULEVAR 6E Nº 3N-64 VILLANUEVA', 520440, 'M', to_date('05-07-1993', 'dd-mm-yyyy'), 400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (86044850, 'KATHERINE JESSICA GUTIERREZ RINCON', 'BULEVAR 66E Nº 66N-80', 520440, 'F', to_date('27-10-1993', 'dd-mm-yyyy'), 460);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (58827520, 'ENRIQUE JAVIER FLOREZ HORMIZDA', 'BULEVAR 6 66BE Nº 8N-32 BARRIO GUAIMARAL', 520440, 'M', to_date('16-08-1992', 'dd-mm-yyyy'), 132);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (88825810, 'EDUARDO CARLOS CUELLAR BUITRAGO', 'CRA 8 Nº 9-43 BARRIO EL LLANO', 553800, 'F', to_date('28-06-1990', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (13729130, 'CAROLINA YENNY GARAY RODRIGUEZ', 'DIAGONAL 62AE  68AN-67 ZULIMA 2 ETAPA', 489600, 'F', to_date('28-10-1991', 'dd-mm-yyyy'), 200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (15290140, 'MAGALI GOMEZ CELIS', 'CRA  69 Nº 3-06 BARRRIO SIGLO XXI', 489600, 'F', to_date('06-06-1990', 'dd-mm-yyyy'), 200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (49254430, 'JAVIER GUILLERMO CALDERON SERRANO', 'CRA 4A N 2E-22 CEDRO', 489600, 'M', to_date('16-11-1990', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (81345840, 'EMEL LEON RAMIREZ', 'CRA 6CN # 7E-637 B/CEDRO II', 3174900, 'M', to_date('30-12-1969', 'dd-mm-yyyy'), 1100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (66029630, 'YANETH ALICIA RIVERA CONTRERAS', 'CRA 9AE  2N-46  GOVIKA', 5587986, 'F', to_date('10-06-1970', 'dd-mm-yyyy'), 260);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (34965360, 'LUCILA MARTHA  CONTRERAS', 'CRA. 6 #34-36 Barrio Alto Prado', 5677393, 'F', to_date('09-01-1973', 'dd-mm-yyyy'), 7200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (61348690, 'CARLOS JUAN VILLAMIZAR CORNEJO', 'CRA 67AN No. 66B-48 Urbanización Niza', 2080309, 'M', to_date('27-06-1975', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (63727690, 'YANETH SANDRA RINCON VELASCO', 'CRA 64 #67-35 CRA LAS AMERICAS', 737906, 'F', to_date('23-07-1988', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8828010, 'ANTONIO JOSE ALVAREZ OSORIO', 'CRR.64 2-53 B. JUAN XIII', 737906, 'M', to_date('05-03-1983', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (13744150, 'MARIA KELLIN MARTINEZ GUILLEN', 'CRA24#68-03   BARRIO GALAN', 737906, 'F', to_date('18-04-1991', 'dd-mm-yyyy'), 210);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (53739500, 'FABIOLA MARIA BASTO ROZO', 'CRA 9AE  2N-66 GOVIKA', 520440, 'F', to_date('28-11-1992', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (88826840, 'CARLOS GUEVARA SANTAELLA', 'BULEVAR  LIBERTADORES  4N-69 CONJ RES BRISAS', 489600, 'M', to_date('25-11-1991', 'dd-mm-yyyy'), 210);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28902270, 'ORLANDO EMMANUEL PRIETO SILVA', 'CRA 7  20-44', 520440, 'M', to_date('16-05-1997', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (46026410, 'INES CLAUDIA CARDENAS VILLAMIZAR', 'CLL 7 6A-48 B. HUMILLADERO ', 789486, 'F', to_date('18-09-1988', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38826360, 'ELIECER ALVARO RAMIREZ DURAN', 'CRA 9N #4-82 URB. EL BOSQUE', 789486, 'M', to_date('03-06-1991', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (43739460, 'TRINIDAD LAURA CACERES ZAPATA', 'CLL 64 6-62 LA ALAMEDA', 789486, 'F', to_date('25-11-1992', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (83739880, 'VANESSA DEL PILAR MONICA PINEDA LOPEZ', 'CLL 66AN 67E-630 URB. NIZA', 904618, 'F', to_date('27-05-1993', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (43744410, 'KARINA RODRIGUEZ MACHADO', 'MZ 3 LOTE 4 URB.LAS AMERICAS', 904618, 'F', to_date('13-07-1991', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (94966900, 'MARCELA VALENCIA GALVEZ', 'CRR 28 7-43 BARRIO LA UNION', 789486, 'F', to_date('20-10-1989', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (78827790, 'AUGUSTO ELIECER SOTO SANCHEZ', 'CALLE 5 9A-93', 789486, 'M', to_date('06-03-1981', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (3727040, 'KARINA ANA VERA CARVAJAL', 'CRA 5E Nº 7-39 BARRIO POPULAR', 489600, 'F', to_date('24-04-1989', 'dd-mm-yyyy'), 200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (48803410, 'FABIAN HERNANDEZ LEON', 'CRA 66 Nº 8C-62, BARRIO AFANADOR Y CADENA', 489600, 'M', to_date('28-12-1992', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28604250, 'EMERSON PINZON RAMIREZ', 'BULEVAR. LIBERTADORES 9BN-96 CONJ. RES LINARE', 429600, 'M', to_date('12-07-1994', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (53739570, 'MILENA NHORA RIOS SANCHEZ', 'CRA 66AN Nº 67E-603 URB NIZA', 520440, 'F', to_date('16-10-1992', 'dd-mm-yyyy'), 131);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (78824760, 'SANTIAGO JOSE ORTIZ MARTINEZ', 'CRA 27 Nº 0-69 SEGUNDO PISO BARRIO SAN RAFAEL', 520440, 'M', to_date('03-03-1989', 'dd-mm-yyyy'), 200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (63750680, 'YAQUELINE LEIDI PRIETO GARCIA', 'BULEVAR 7N Nº 7N-89 SANTANDER VILLA ROSARIO', 520440, 'F', to_date('21-12-1992', 'dd-mm-yyyy'), 133);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (88826830, 'SANTIAGO JIMMY MATEUS CARDENAS', 'CL 63 Nº 6E-662 BARRIO CAOBOS', 520440, 'M', to_date('22-12-1991', 'dd-mm-yyyy'), 260);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (56026500, 'MATILDE GOMEZ RAMIREZ', 'CALLE 2 65-33 BARRIO MOLINOS', 520440, 'F', to_date('19-02-1990', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (63739670, 'PAULINE JULIE DUSSAN VASQUEZ', 'CRA 7  5E-64 URB. SOTO', 489600, 'F', to_date('04-12-1992', 'dd-mm-yyyy'), 200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (68825660, 'FRANCISCO JUAN IBARRA VERA', 'CRA 66  66-63 B. SAN JOSE DE TORCOROMA', 489600, 'M', to_date('07-01-1990', 'dd-mm-yyyy'), 260);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (33729350, 'ANDREA CARMEN BOHORQUEZ VERGARA', 'CRA 30  62-03  URB LAS MARGARITAS', 489600, 'F', to_date('31-12-1991', 'dd-mm-yyyy'), 133);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (73739710, 'JOHANA GONZALEZ VERGEL', 'BLOQUE F2  LOTE 62 6RA ETAPA ATALAYA', 489600, 'F', to_date('12-02-1993', 'dd-mm-yyyy'), 240);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8903030, 'LEON GUILLERMO BAUTISTA TRIANA', 'CRRA 60B Nº 66B-09  TIBU', 489600, 'M', to_date('20-05-1997', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8806090, 'CAROLINA JENNY MELENDEZ GARCIA', 'MZ K-3 LOTE 3 ATALAYA 6RA ETAPA', 520440, 'F', to_date('26-08-1996', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (53750580, 'CAROLINA DIANA RAMON PRADA', 'CALLE 6  66-83 LA PALMITA', 520440, 'F', to_date('19-09-1991', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (36351370, 'YOLIMA ALBA GELVEZ OSORIO', 'CLL 6CN #2E-98 CEDRO II', 398400, 'F', to_date('06-04-1984', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (36044310, 'ISABEL MARITZA ROA HERNANDEZ', 'BULEVAR 60 CALL 24 #60-92', 398400, 'F', to_date('17-02-1990', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (32760340, 'SOFIA NURY BUITRAGO MESA', 'DIAGONAL 62 #68N-09', 398400, 'F', to_date('25-07-1990', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (33744390, 'MELISA ALVAREZ CASTELLANOS', 'CRA 2A N?62-65 BARRIO CAROTA', 429600, 'F', to_date('18-04-1991', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (53739510, 'DEL PILAR ANDREA SAENZ CONDE', 'CLLE 20 BN Nº 3-62', 553800, 'F', to_date('17-07-1992', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (98821970, 'EDUARDO CARLOS SOTO MALDONADO', 'CRA 0A #6E-64 QUINTA', 65881, 'M', to_date('03-04-1984', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (46037460, 'ALEXANDRA INGRID GUERRERO PARADA', 'TRANSVERSAL 67 CRA 00 #0BN-58 B.PUEBLO', 498301, 'F', to_date('24-05-1984', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (31350310, 'ENRIQUE ADOLFO GOMEZ GALLARDO', 'CRA 68 #60-36 B.CUNDINAMARCA', 584009, 'M', to_date('10-01-1978', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8822090, 'CESAR TORRES BARRIENTOS', 'BULEVARE 66A #8-50 B. TORCOROMA', 584009, 'M', to_date('19-11-1984', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (74966760, 'GUISELA IBETH PALLARES MORENO', 'CALLE 64 #2-20', 498301, 'F', to_date('05-05-1988', 'dd-mm-yyyy'), 640);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (52760580, 'CANDELARIA YANETH SAMPAYO RANGEL', 'BULEVAR. 3 #3N-30 PISO 2 PESCADERO', 429600, 'F', to_date('14-10-1990', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (46039480, 'MARIA LINA RAMIREZ ENTRENA', 'CRA 4AN 9E-54 GOVITA', 429600, 'F', to_date('31-07-1987', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (88822860, 'FERNANDO DIEGO ECHEVERRI SANGUINO', 'CRA 66 9E-75 APTO 606 LA RIVIERA', 429600, 'M', to_date('26-01-1986', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (53750510, 'DEL ROCIO ANGELA CASTAÑEDA GUERRERO', 'CRA  69B   6-26   BOSQUES DEL PAMPLONI', 1977242, 'F', to_date('09-03-1990', 'dd-mm-yyyy'), 7700);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (18825170, 'JONATHAN SANMIGUEL SANCHEZ', 'CLLE 62 Nº 9-78 BARRIO EL LLANO', 520440, 'M', to_date('16-08-1989', 'dd-mm-yyyy'), 240);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (68823690, 'EDUARDO RAUL NUÑEZ QUINTERO', 'CRA 4N Nº 0AE-33 APTO 606 EDIF MARABELL, BARR LA PIÑUELA', 520440, 'M', to_date('21-04-1987', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (22759230, 'MILENA FANNY PAEZ MORANTES', 'CLLE 6AN Nº 2E-95 BARRION QUINTA', 520440, 'F', to_date('09-07-1989', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (25470210, 'ALEXANDER HUGO IBAÑEZ PEREZ', 'CRA.  27C  62-66', 457800, 'M', to_date('26-12-1989', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (21387210, 'ALFONSO AYALA PEÑUELA', 'BULEVAR. 9E  60-69  APTO. 806  EDF. TERRAZAS DE LA RIVIERA', 6549773, 'M', to_date('17-10-1989', 'dd-mm-yyyy'), 7700);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (36028390, 'CECILIA BETSY BARRETO MATAMOROS', 'CRA 0A  20-47 B/BLANCO', 1965354, 'F', to_date('02-06-1968', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (6038090, 'ARELIS JUDITH OLIVARES SOLANO', 'CLL 8AN 62E-74 C.JAR', 422290, 'F', to_date('02-10-1985', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (6037000, 'MERCEDES SANDRA BARRERA NAVARRO', 'BULEVAR. 67 69A-20 CIRCUN', 498301, 'F', to_date('27-07-1982', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (76036750, 'DANELLY OLIN JAIMES LEAL', 'CRA 4AN # 3-36 B/COLPET', 498301, 'F', to_date('23-04-1983', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8822010, 'FERNANDO LUIS CASTAÑEDA SANABRIA', 'CRA 8CN # 2-02', 498301, 'M', to_date('05-07-1984', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (95469980, 'ANTONIO EDWIN MEJIA SARABIA', 'VEREDA EL LIMON-VIA AEROPUERTO', 457800, 'M', to_date('29-11-1989', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (41374490, 'ALEXANDER FELIX ORTIZ RAMIREZ', 'CRA 65  6-64  TIERRA LINDA 8 ETAPA', 915600, 'M', to_date('05-12-1988', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (88825880, 'EMIRO WALTER RIVIERA VILLAMIZAR', 'BULEVAR 60KJ-76 PIZARREAL', 429600, 'M', to_date('10-09-1990', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (61098600, 'HERMELINA QUINTERO BARBOSA', 'CALLE 28 N4-04', 429600, 'F', to_date('12-03-1993', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (13727170, 'YURLEY ERIKA PEREZ RIAÑO', 'CRA 9N  2-39  URB. EL BOSQUE', 429600, 'F', to_date('16-03-1990', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (76039730, 'KATHERINE JOHANA OMAÑA MENDEZ', 'BULEVAR 66AE N? 9N-80 BARRIO GUAIMARAL', 457800, 'F', to_date('13-05-1987', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (26026200, 'CAROLINA MARIA BAUTISTA GOMEZ', 'CRA 5 8-82  B. SANTO DOMINGO', 429600, 'F', to_date('12-09-1984', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (53727510, 'YANETH MARY CARVAJALINO DUARTE', 'CALLE 4  2-75 APTO. 402', 429600, 'F', to_date('06-06-1988', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (86039860, 'MERCEDES XIOMARA CONTRERAS SEPULVEDA', 'CRA 6N #3E-48 QUINTA BOSCH', 457800, 'F', to_date('26-01-1988', 'dd-mm-yyyy'), 400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (23744200, 'GELIXA ROMMY ALVAREZ JACOME', 'CRA 6N  2E-35 B. QUINTA', 457800, 'F', to_date('20-09-1990', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (68825670, 'FERNANDO DIEGO GALVIS TORRADO', 'CRA 3  6-23  LLERAS', 429600, 'M', to_date('14-05-1990', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (62760630, 'LILIANA MAIRA MATAGIRA BLANCO', 'CRA 4AN  3-07', 457800, 'F', to_date('22-12-1990', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28608220, 'MILEIDY YORLENY HERNANDEZ FERNANDEZ', 'CRA 9 # 66-366 BARRIO EL ESCORIAL', 457800, 'F', to_date('08-11-1994', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (18826100, 'PEDRO JAIRO ABREO TORRADO', 'CRA 22AN  4-665 PRADOS NORTE', 489600, 'M', to_date('14-02-1991', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (83739890, 'ELENA CARMEN LAGUADO JAGEMBERG', 'CRA 66B  66AN-48  LAS AMERICAS', 1040880, 'F', to_date('04-11-1995', 'dd-mm-yyyy'), 133);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (13729150, 'PATRICIA CLAUDIA PEREZ FERNANDEZ', 'CRA 6N 7E-42 QUINTA ORIENTAL', 457800, 'F', to_date('28-10-1991', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (48823410, 'WILFREDO LUIS RIVERA RINCON', 'CRA 2N 5A-52 PESCADERO', 457800, 'F', to_date('15-01-1987', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8825090, 'EDUARDO CARLOS USCATEGUI RIVERA', 'CLL 6BN #7AE-33 CEDRO II', 398400, 'M', to_date('27-09-1989', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8823080, 'JORGE FERNANDO BERMUDEZ HERNANDEZ', 'BULEVAR 65#65-603 BARRIO CONTENTO', 398400, 'M', to_date('19-06-1986', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (51371570, 'PEDRO EDINSON GARCIA BADILLO', 'CRA 5A N° 66-06 TURBAY AYALA', 739200, 'M', to_date('07-02-1987', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (85418810, 'ALONSO JAVIER RODRIGUEZ FLOREZ', 'CRA 3 #3-42 SAN IGNACIO', 773220, 'M', to_date('15-12-1992', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (16039100, 'ELENA BEATRIZ ACEVEDO SUAREZ', 'FINCA LA CAPILLA', 773220, 'F', to_date('03-01-1987', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (75471720, 'ARMANDO YEISON CARDENAS QUINTERO', 'CRA 2 #6-30 EL CARMEN', 827346, 'M', to_date('22-11-1990', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (81317820, 'PEDRO RODRIGO VERGEL MARCONI', 'CALLE 6 #62-668 BARRIO JESUS CAUTIVO', 739200, 'M', to_date('12-08-1993', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (33335310, 'MARIA LELLANIS ALVARADO PALENCIA', 'CRA 60 #4-66 EL OLIVO', 773220, 'F', to_date('19-03-1992', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (93733990, 'YAMILE SANCHEZ FRANCO', 'CALLE 60B #67-68 EL BOSQUE', 773220, 'F', to_date('29-03-1988', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (24967250, 'LORENA MAGDA ROJAS NUÑEZ', 'Carrera 35 No. 4-09 Barrio María Eugenia Bajo.', 817673, 'F', to_date('28-12-1992', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (51127580, 'SALVADOR CHARBEL MENESES PINTO', 'Kilómetro 9, Barrio Pisarreal casa K64-3C.', 817673, 'M', to_date('22-02-2000', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (76044790, 'JACKELINE DIAZ AMEZQUITA', 'CRA 62 No. 6-80 Barrio San Luis.', 1090231, 'F', to_date('31-07-1993', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8828020, 'ALEXANDER ANGARITA HERRERA', 'Carrera 67A No. 3 – 32 Barrio La Modelo', 817673, 'M', to_date('30-05-1981', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (81118820, 'YAMIT KEITH MEZA BALLESTEROS', 'CRA 64A #9-62', 827346, 'M', to_date('21-01-1998', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (1069090, 'PEDRO OSWALDO CARRILLO CHAUTA', 'CRA 5 #5-57 PESCADERO', 827346, 'M', to_date('12-07-1997', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (7718020, 'MERBIS PEÑARANDA FLOREZ', 'CRA 62 # 3-40 Barrio Doce de Octubre ', 993739, 'M', to_date('08-01-1988', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (14967130, 'SOLEINE DONADO RODRIGUEZ', 'CRA 2 # 26-04 Barrio Sabanita ', 993739, 'F', to_date('08-11-1991', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (81004850, 'HERLINDA QUINTERO HERNANDEZ', 'MZ 64 LOTE 353', 739200, 'F', to_date('25-08-1999', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (95302960, 'MERCEDES BERCI CARDOZO GAMARRA', 'CRA 68 N° 6-49 EL SALADO', 739200, 'F', to_date('25-04-1993', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (3005040, 'JOHANNA MARILYN GARCIA CASTILLO', 'BULEVAR 3 CRA 6K N° 460-649 BARRIO LA VICTORIA', 739200, 'F', to_date('05-03-1989', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (71095700, 'MICHELY QUIÑONEZ DUARTE', 'CRA. 6E #2-30 Barrio Villas de Santander', 993739, 'M', to_date('24-05-2000', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (86044890, 'KATHERINE LEIDY ROVIRA RAMIREZ', 'Av 7 N. 5-69 Barrio Aeropuerto ', 993739, 'F', to_date('16-01-1994', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (66043640, 'YULENIS  JAIMES', 'Cra. 60A #60-37 Barrio Divino Niño', 993739, 'F', to_date('25-07-1988', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (73746750, 'SANTIAGO DANIEL REQUEJO HUERTAS', 'CRA 63 #6A-66 CONJUNTO MIRADORES DE LOS PATIOS ', 773220, 'M', to_date('11-07-1990', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (1005020, 'CARLOS LUIS GONZALEZ FIGUEROA', 'CALLE 7 #452 BARRIO BAROHOJA', 773220, 'M', to_date('21-08-1996', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (91096950, 'MAURICIO EDGAR PEREZ DELGADO', 'CRA 64 AN N° 4A-76 PORTACHUELO', 773220, 'M', to_date('22-08-1998', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (41090490, 'VALERIO ALEX NIÑO CARDENAS', 'TRASVERSAL 67-KDX 204 BARRIO PUEBLO NUEVO.', 827346, 'M', to_date('16-03-2000', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (89616880, 'EDUARDO LUIS NAVARRO SUELTA', 'CRA. 5 #47-03 Barrio Santa Clara', 937490, 'M', to_date('16-06-1990', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (41126420, 'ANGEL MIGUEL THERAN LOPEZ', 'CRA. 6 #4-66 Apto 206 ', 937490, 'M', to_date('01-09-1995', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (73322750, 'PAOLA LICETH FERNANDEZ TAPIA', 'CRA. 20AN #3-662 Urbanización Tasajero', 937490, 'F', to_date('21-02-1993', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28831200, 'HENRY LLANES DUARTE', 'Av 6 # 36-95 Barrio Doce de Octubre', 993739, 'M', to_date('18-11-1992', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (4979010, 'CAROLINA NEIDIS RIVERA PORTILLA', 'CRA. 67 KDX #274-63A Barrio Gaitan', 937490, 'F', to_date('09-07-1987', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (41346440, 'VIANEY JUAN LOBO AYALA', 'CRA 66 MN #7-68 BARRIO CECILIA CASTRO', 739200, 'M', to_date('05-09-1970', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (33322300, 'DE JESUS MARJORIS CASTRILLO CABRALES', 'CALLE 3 N° 8A - 606', 739200, 'M', to_date('27-04-1991', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (33733380, 'ESMIR FRANCO MACHADO', 'BULEVAR 63 N° 0-50 BARRIO CARORA.', 827346, 'F', to_date('23-06-1987', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (81049820, 'CECILIA YERLIS RUIZ AYOLA', 'Mz. 4-J lt 5-A Apto 202 Barrio Tucunare', 993739, 'F', to_date('22-02-1999', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (36041350, 'DEL CARMEN MAILY  PANQUEVA', 'CRA. 6 #8-53 Barrio Gramalote', 993739, 'F', to_date('18-08-1989', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (46039430, 'HIRLEY RIVERA GALVIS', 'CRA. 22 #69-26 Barrio Aguas Calientes', 993739, 'F', to_date('04-03-1987', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (11104120, 'CELINA LUZ CARDENAS ROA', 'KILOMETRO 452 VEREDA LOS LIRIOS ', 773220, 'F', to_date('11-09-1991', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (57709500, 'FERNANDO LUIS MANZANO VERGEL', 'CRA 26 #3-28 SAN MATEO', 773220, 'M', to_date('13-03-1993', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (99693950, 'RICHARD GALVIS GUEVARA', 'Cra 29-63 Norte 68 Barrio Cordillera', 885260, 'M', to_date('14-02-1992', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (1193030, 'YENSYN CHACON BALAGUER', 'CRA 36 N° 6-80 BARRIO LA HERMITA', 827346, 'M', to_date('27-12-1999', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (52780520, 'LEONOR MARIA ESPINEL GELVES', 'CRA 64 No. 67-79 Barrio San José de Cúcuta', 138202, 'F', to_date('14-06-1974', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (92801960, 'MILADYS CADENA RANGEL', 'KDX 406-460 Barrio Libardo Alonso', 790022, 'F', to_date('03-11-1987', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (36041330, 'MARITZA LIBIA FLOREZ RIVERA', 'CRA 9 #8-35 Barrio La Feria', 790022, 'F', to_date('22-01-1989', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38823370, 'JESUS VILLARRUEL PEREZ', 'CRA 23 #2-66 PRADOS NORTE', 827346, 'M', to_date('08-01-1987', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (91095920, 'PAOLA INGRY CELIS ARENAS', 'CRA 4N #8-64 PESCADERO', 773220, 'F', to_date('29-08-2000', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (42789470, 'MARITZA DALIS DUEÑEZ CASTRO', 'Cra. 66 # 4 - 50 Turbay Ayala', 1053364, 'F', to_date('18-08-1990', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (35472330, 'WILMER OVALLES ANGARITA', 'KDX 0684 Barrio La Quinta', 937490, 'M', to_date('06-06-1991', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (42760460, 'FABIOLA LADY RUIZ MENDOZA', 'CRA. 66 #8-27 Barrio Tierra Linda', 937490, 'F', to_date('26-07-1990', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (3744030, 'DIANA URBINA ALBARRACIN', 'CRA 4N N° 6AE-22 BARRIO CAMBULOS', 773220, 'F', to_date('06-01-1991', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (71098720, 'DANIELA LIZETH CHAUSTRE JAIMES', 'CRA 3N 2E-05 BARRIO LA CASTELLANA', 739200, 'F', to_date('15-09-2000', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8826030, 'WUILMER CARLOS HERNANDEZ GARCIA', 'CRA 4  0-93  BARRIO MOTILONES', 4227732, 'M', to_date('30-01-1991', 'dd-mm-yyyy'), 7700);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (73733720, 'YUDITH MAUREYO SANGUINO', 'CRA 4 #27-38 MARABEL (SAN PEDRO)', 596280, 'F', to_date('17-11-1988', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (66041680, 'MILENA YESSICA JAIME BAYONA', 'CRA 67 #6-73, ABREGO', 618000, 'F', to_date('24-02-1989', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (3718010, 'VERONICA AREVALO ARENIZ', 'CRA 26A #9-04 EL BAMBO (SAN PEDRO)', 596280, 'F', to_date('14-10-1991', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (29011270, 'DIDIER JOHAN PARRA UREÑA', 'CRA 66 #6-02 BARRIO COMUNEROS', 596280, 'M', to_date('13-02-1999', 'dd-mm-yyyy'), 220);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (71347710, 'IVAN CESAR ARCHILA ALDANA', 'CRA 32 #5-49 CENTRO', 618000, 'M', to_date('21-06-1971', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (44966460, 'INDIRA OJEDA SOLANO', 'CRA REAL #6-74, TORRE 2, APTO 406', 618000, 'F', to_date('29-03-1985', 'dd-mm-yyyy'), 640);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (46044450, 'NELLY PEÑA SANCHEZ', 'Av. 5 #26-66 Barrio Patio Centro', 937490, 'F', to_date('05-05-1992', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (95469930, 'ELIAS GONZALEZ BARBOSA', 'CRA. 2 #666-230 Aguas Claras', 937490, 'M', to_date('14-12-1989', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (43729470, 'PAOLA JENNIFER MORENO CHONA', 'CRA 60 No. 09-92  Barrio Motilones, Cúcuta', 1053364, 'F', to_date('14-03-1992', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (36037380, 'FARID YAZMIN PEÑARANDA GORY', 'Manzana 33 Lote 495B Barrio Videlso', 817673, 'F', to_date('08-01-1983', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (91007990, 'ALEXIS MICHAEL BAUTISTA MARTINEZ', 'Carrera 5 No. 5-50 Barrio Piedecuesta', 817673, 'M', to_date('06-02-1998', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (1005040, 'ABEBRAVI FABIAN UNDACHIRA ANOCHE', 'Carrera 6 #6-34 Barrio El Carmen', 885260, 'M', to_date('08-02-1996', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (41110450, 'TATIANA JEIMMY VELA RODRIGUEZ', 'Cra. 64 #66N-05 Barrio 20 de Julio', 885260, 'F', to_date('15-04-1995', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (3729080, 'OLIVA BLANCA PEREZ ASCANIO', 'Av. 8A #67-64 Barrio El Paramo', 885260, 'F', to_date('05-05-1991', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (81023890, 'OSCAR JACKSON SOTO SARABIA', 'CRA 7 N° 7A -65 BARRIO SEVILLA', 827346, 'M', to_date('08-05-1998', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38826300, 'LEON WILMAR GOMEZ BERRIO', 'CRA 67 N° 7-49 BARRIO EL PARAMO', 885260, 'M', to_date('08-02-1990', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (91127940, 'CATHERINE LUDY GARCIA CRISTANCHO', 'Carrera 60 No. 2-45 Barrio Bellavista', 1053364, 'F', to_date('16-02-1999', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (34967310, 'MILENA SIRLEY VILLAMIZAR SUAREZ', 'Carrera 22 ·8-64 Barrio SOTO', 900000, 'F', to_date('07-06-1993', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (97227950, 'DE JESUS RONALD MERCADO ORELLANO', 'CRA 0 #3-76 BARRIO LA CEDRO', 739200, 'M', to_date('07-03-1991', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (73750760, 'FERNANDA MARIA CONTRERAS ESPITIA', 'CALLE 60 #8-63 BARRIO GRAMALOTE', 827346, 'F', to_date('19-12-1993', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (18813160, 'HUMBERTO RAFAEL USECHE CALDERON', 'CRA 6 #60-46 Barrio Gramalote', 885260, 'M', to_date('23-11-1992', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (21085260, 'FELIPE DANIEL CAICEDO GRACIA', 'CRA 5AN #6AE-42 CEDRO II', 827346, 'M', to_date('08-08-1996', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38803380, 'ORLANDO MANUEL PEÑALOZA DIAZ', 'CRA. 66 #5-66 segundo piso Barrio Luz Polar', 937490, 'M', to_date('01-08-1992', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (34061390, 'CESAR PAULO GAYON BAEZ', 'CALLE 6 N° 65-56 BARRIO OLAYA HERRERA', 739200, 'M', to_date('24-09-1991', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (53733540, 'LILIANA ALVAREZ CLARO', 'Carrera 22 #2A-24 Barrio Marabelito', 885260, 'F', to_date('22-01-1989', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (33732380, 'MARLENE VERJEL SALAZAR', 'CRA 6BN #67E-608 URB. TORREMOLINOS', 827346, 'F', to_date('12-10-1979', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (18821110, 'ANCISAR HERNAN ALVAREZ SOTO', 'Cra. 62B #69N-82 Barrio La Esperanza', 937490, 'M', to_date('11-12-1982', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (56026590, 'EDILSA MARIA ESCALANTE SERRANO', 'Carrera 65 #4N-62 Barrio Simón Bolivar', 885260, 'F', to_date('01-05-1991', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (86026820, 'MARCELA LEIDY MOGOLLON GONZALEZ', 'Cra. 6 CRA. 66 No. 8-47 Barrio Santa Cruz.', 885260, 'F', to_date('12-08-1993', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (81134850, 'ARIANA SHIRLEY DUARTE MANTILLA', 'Av. 26 #26-20 Barrio Belen', 937490, 'F', to_date('20-11-1996', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (41143420, 'DANILO ALEX VELASQUEZ MALDONADO', 'Cra. 66 #66-28 Barrio San Pedro', 937490, 'M', to_date('08-06-1997', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (41015410, 'ANDREA BARRETO RIOS', 'Transversal 4 No. 4E-65 Barrio La Ceiba.', 885260, 'F', to_date('21-12-1996', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (71033730, 'YAMID KLEIDER PACHECO NIÑO', 'CRA 6N-30 COLPET', 827346, 'M', to_date('11-02-2000', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (86026810, 'JOHANA LADY RIVERA CASTELLANOS', 'BLOQUE 60 CASA 6 URBANIZACIÓN LA CAMPIÑA', 827346, 'F', to_date('18-11-1993', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (36041320, 'HELENA ROSA CARRILLO MARIÑO', 'Cra. 5 #6N-50 Barrio Santander', 937490, 'F', to_date('29-04-1989', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (71020740, 'PEDRO RAUL ALBARRACIN CONTRERAS', 'CRA 66 N° 66A-25 BARRIO SAN JOSÉ DE TORCOROMA', 827346, 'M', to_date('10-06-1997', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (48803490, 'CARLOS JUAN SIERRA GONZALEZ', 'Av. 4 #3-83 Interior 6-2 Condominio Prados del Este', 937490, 'M', to_date('29-10-1993', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (81100830, 'SERGIO VILLAMIL SANTOS', 'CRA. 6N #3-03 Barrio Colpet', 993739, 'M', to_date('18-04-1998', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (41020440, 'ALEXANDER EDWIN MONTOYA BUITRAGO', 'CRA 4 AN #5-629 Barrio Pescadero', 885260, 'M', to_date('14-12-1999', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (42760470, 'NEREYDA GRISEL RAMIREZ RODRIGUEZ', 'CRA 66N N. 6-44 Barrio Corral de Piedra ', 993739, 'F', to_date('18-09-1990', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (65401650, 'HUMBERTO JAIME SOLANO OSORIO', 'CRA 65 N° 23-42 LA LIBERTAD', 707400, 'M', to_date('09-08-1993', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (76663760, 'PABLO JUAN CHAUSTRE LOPEZ', 'CRA 6N #7AE-07 QUINTA ORIENTAL', 707400, 'M', to_date('12-06-1993', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (73750700, 'PATRICIA YURANI PEREZ SANCHEZ', 'CRA 4A #65-72 BARRIO LOMA DE BOLIVAR', 642720, 'F', to_date('26-12-1992', 'dd-mm-yyyy'), 134);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (91346980, 'EDUARDO RAUL HERNANDEZ AREVALO', 'CRA 7N # 2E-73  CEDRO II', 4823938, 'M', to_date('14-03-1972', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (42760420, 'CRISTINA CAROLINA TORRES GONZALEZ', 'CRA 6B #4-637 PRADOS DEL ESTE', 618000, 'F', to_date('29-09-1990', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (66044610, 'CAROLINA DIANA CUELLAR GUAQUETA', 'CRA 26N #4-55 APTO 206 PRADOS NORTE', 618000, 'F', to_date('29-07-1992', 'dd-mm-yyyy'), 133);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (12882130, 'TERESA PAOLA CAMARGO RODRIGUEZ', 'CRA 7 #60-34 SAN MARTIN', 530550, 'F', to_date('22-05-1989', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (59153520, 'PEDRO CARLOS GAMBOA CARVAJAL', 'CRA 36 #29-68, APTO 304 - BUCARAMANGA', 553800, 'M', to_date('09-03-1993', 'dd-mm-yyyy'), 131);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (18826120, 'ARMANDO CARLOS INFANTE SALGUERO', 'CRA CERO A #5-20 BARRIO LLERAS', 618000, 'M', to_date('11-02-1991', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (58009570, 'ALEXANDER GEOVANNY BOTELLO NUÑEZ', 'CRA 62BN #62CE-43 BARRIO ZULIMA', 618000, 'M', to_date('01-10-1990', 'dd-mm-yyyy'), 230);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (88819830, 'JORGE MANUEL WILCHES QUIROGA', 'CRA 66N #64AE-54 URBANIZACIÓN LA MAR', 4027174, 'M', to_date('16-02-1980', 'dd-mm-yyyy'), 7200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (76035790, 'YANETH VARGAS CASTELLANOS', 'BULEVAR 9E N° 6N-27 BARRIO QUINTA ORIENTAL', 739200, 'F', to_date('01-01-1982', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (16044110, 'OMAIRA ZULUAGA RAMIREZ', 'BULEVAR.6 #20-48 B.ONCE DE NOVIEMBRE PATIOS', 584009, 'F', to_date('17-04-1986', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (23729290, 'CAROLINA HEIDY LEON BASTIDAS', 'CRA 66 #60A-70 SAN JOSÉ DE TORCOROMA', 618000, 'F', to_date('15-08-1992', 'dd-mm-yyyy'), 410);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (31002370, 'WILLIAM TORRES MARTINEZ', 'CRA 2 #62-38 MOTILONES', 707400, 'M', to_date('29-11-1994', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (52760590, 'LORENA ANGELICA RAMIREZ ESPINOSA', 'Av.  4E  62-85  Torre 2  Int 2 Apto. 703 Caobos', 3576834, 'F', to_date('16-11-1990', 'dd-mm-yyyy'), 7200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (56026570, 'YULEY ANA CARDENAS VILLAMIZAR', 'CRA 3A 8-65 INT 60 PASAJE ROSA MERCEDES', 520440, 'F', to_date('17-03-1991', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (66026640, 'VIVIANA MONICA MENESES CARREÑO', 'CRA 63 66E-644 BARRIO ALCALA', 520440, 'F', to_date('26-01-1992', 'dd-mm-yyyy'), 200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (78827760, 'DARWIN ANGARITA OJEDA', 'KDX 426 - 330 Altos Santa Ana', 1840151, 'M', to_date('18-07-1980', 'dd-mm-yyyy'), 7700);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (48826400, 'MARCIANO JHONATAN LOMBANA ACEVEDO', 'CRA 68 62-55 VILLA DEL ROSARIO', 2566508, 'M', to_date('29-06-1991', 'dd-mm-yyyy'), 7200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (71115720, 'JHOVANA SOLANO ESTEBAN', 'BULEVAR 63E N° 4-33 APTO 6 BARRIO EL COLSAG', 707400, 'F', to_date('10-12-1997', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (13718150, 'TATIANA AREVALO AREVALO', 'CRA 65 #60A-82 BARRIO LA PALMITA', 680040, 'F', to_date('17-07-1992', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (85401820, 'MAURICIO ERICK PARDO GALVIS', 'CRA 63 #24-68', 618000, 'M', to_date('17-02-1994', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (41110490, 'ANYELO REYES ORTEGA', 'CALLE 62 #7-66 GRAMALOTE', 618000, 'M', to_date('01-05-1998', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (1016020, 'MAURICIO CRISTIAN ORTIZ CARDENAS', 'BLOQUE R2 LOTE 64 BARRIO ATALAYA PRIMERA ETAPA', 642720, 'M', to_date('07-08-1998', 'dd-mm-yyyy'), 362);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (1016030, 'ADELAIDA DURAN DURAN', 'CRA 68 #2-73 DESIERTO', 707400, 'F', to_date('04-06-1999', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (6042060, 'DEL CARMEN MARIA TORRES OCHOA', 'CRA 3 #3-38 BARRIO EL CENTRO', 707400, 'F', to_date('02-10-1984', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (96044970, 'YURLEY DEISY PEREZ RAMOS', 'CRA 67 #6N-46 BARRIO SAN MARTIN', 618000, 'F', to_date('25-01-1994', 'dd-mm-yyyy'), 333);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (43733410, 'DEYANIRA PEREZ CAÑIZAREZ', 'CRA 27A N° 2B-30 BARRIO IV CENTENARIO - SAN PEDRO', 554400, 'F', to_date('06-05-1987', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (1066060, 'JARETH YECXO CASTRO CASTILLA', 'CA KDX 398 340 BARRIO VILLA PARAISO -SAN PEDRO', 554400, 'M', to_date('19-09-1997', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (14966150, 'DEL ROSARIO NANCY SANTIAGO TORRADO', 'CALLE 65 #65-669', 642720, 'F', to_date('08-04-1982', 'dd-mm-yyyy'), 640);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (85274870, 'ELIZABETH SUAREZ CLAVIJO', 'CRA 6N #7C-25', 680040, 'F', to_date('25-06-1992', 'dd-mm-yyyy'), 4000);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (33739340, 'KATHERINE DIANA RINCON CORREA', 'CRA 64B #7-76 URBANIZACION TIERRA LINDA', 520440, 'F', to_date('25-01-1992', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (78820720, 'CESAR JULIO MARTINEZ LEAL', 'BLOQUE N4, N.6 ATALAYA PRIMERA ETAPA', 553800, 'M', to_date('06-04-1982', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (58822550, 'LUIS JOSE PLATA FLOREZ', 'CRA 9 N OA-22 BARRIO TRIGAL', 553800, 'M', to_date('31-12-1984', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (68830660, 'MAURICIO RICHARD CACERES GONZALEZ', 'Mz. 24  Lote 66-40  Barrio Videlso', 2145839, 'M', to_date('02-03-1991', 'dd-mm-yyyy'), 7700);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (38826370, 'JORGE CARLOS ORTEGA CONTRERAS', 'BLOQUE 40, LOTE 5 BARRIO CLARET', 553800, 'M', to_date('14-06-1991', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (95497930, 'HUGO VICTOR RODRIGUEZ ORTEGA', 'CRA 6 2-42 SANTIAGO', 553800, 'M', to_date('16-03-1993', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (28820220, 'JORGE CARLOS NIETO DAVILA', 'CRA 62 6-64 BARRIO LOMA DE BOLIVAR', 553800, 'M', to_date('31-03-1981', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (86036890, 'CLAUDIA ORTEGA GARCIA', 'CRA 5 N° 2N-66 TRIGAL DEL NORTE', 707400, 'F', to_date('31-07-1983', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (29001260, 'KATHERINE LIZETH SILVA GAFARO', 'CALLE 65  5N-602 BARRIO SIMON BOLIVAR', 596280, 'F', to_date('14-04-1998', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (1128050, 'DEL CRISTO BORIS DÍAZ JAIMES', 'CRA 3 #6-04 SANTA MARTA', 642720, 'M', to_date('03-01-1996', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (18825100, 'ALEXIS CARLOS CARVAJAL CARRILLO', 'CRA 6 #22-80, PATIOS', 596280, 'M', to_date('17-01-1989', 'dd-mm-yyyy'), 334);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (13718170, 'LORENA MELISSA AREVALO AVILA', 'CRA 62 #64-652 CRA LA LUZ', 642720, 'F', to_date('13-01-1993', 'dd-mm-yyyy'), 135);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (58825560, 'ENRIQUE RAFAEL SALCEDO MONTAÑO', 'CRA 6AN Nº 3E-08 EDIF SANTA MARTHA APTO 606 QUINTA BOSH', 520440, 'M', to_date('27-03-1990', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (22773260, 'LISBETH ROA LARGO', 'CRA 65 AN N° 67E-82 BARRIO NIZA', 680040, 'F', to_date('21-06-1989', 'dd-mm-yyyy'), 1100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (22785290, 'TORCOROMA EDDY SANTANA PALLARES', 'K DX #66-E BARRIO NUEVO HORIZONTE', 642720, 'F', to_date('21-12-1987', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (36026390, 'YARELIS MILBA  VERA', 'CRA 34N #5E-04 LOS PATIOS', 680040, 'F', to_date('17-11-1988', 'dd-mm-yyyy'), 2420);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (71033700, 'SOFIA LAURA LAGOS REINA', 'CALLE 8A #9-76 APTO 606', 680040, 'F', to_date('27-12-1996', 'dd-mm-yyyy'), 1400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (11003120, 'EFRAIN PEREZ RODRIGUEZ', 'DIAGONAL 2 #49-64 SANTA CLARA', 680040, 'M', to_date('26-03-2000', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (31127340, 'YORLED INGRID ROBLEDO CASTELLANOS', 'BULEVAR 60 N° 68-26 BARRIO 66 DE NOVIEMBRE', 739200, 'F', to_date('05-09-1999', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (9104090, 'HERNAN HUBER GARCIA VELANDRIA', 'CRA 6 #4-86 LA UNION', 596280, 'M', to_date('26-06-1999', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (58824550, 'MILLER NELSON OVALLE CAICEDO', 'CRA 20N #2-47 BARRIO PRADOS NORTE', 596280, 'M', to_date('30-11-1988', 'dd-mm-yyyy'), 234);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (41148440, 'MARIA ANA QUINTERO SANJUAN', 'CRA 60 N° 2-46 SAN PEDRO- NORTE DE SANTANDER', 739200, 'F', to_date('27-11-1999', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (71098700, 'ALEXANDRA CHAVELLY SALAS MARTINEZ', 'CALLE 20 N° 4-9 SABANITA', 739200, 'F', to_date('16-09-1999', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (86043860, 'SOLANYI YANSY PEÑARANDA ORTIZ', 'CALLE 63 #6A-22 BARRIO DIOCESANO', 707400, 'F', to_date('20-02-1992', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (8825030, 'CARLOS JUAN GARCIA CRISTANCHO', 'BLOQUE 6 CRA 64 #66B-56 TORCOROMA I', 707400, 'M', to_date('24-08-1989', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (73750750, 'NEIRA LUZ SUAREZ PALENCIA', 'CALLE 8 #67-86 BARRIO LA PALMITA', 680040, 'F', to_date('26-01-1993', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (91532900, 'JORGE DAIRO RESTREPO ROJAS', 'CRA 68N # 4- 36 Apartamento 703 Edificio Tulipanes Barrio los Ángeles', 5016541, 'M', to_date('16-11-1983', 'dd-mm-yyyy'), 6200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (46026450, 'YOJANA NINY FIGUEROA SUAREZ', 'CALLE 8 N° 8A-26 CHAPINERO - ', 707400, 'F', to_date('08-04-1989', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (91027940, 'MARLES ACOSTA BEDOYA', 'CRA 3 N° 2-24 URBANIZACION HELIÓPOLIS', 707400, 'F', to_date('22-06-1994', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (43739440, 'VIVIANA LESLYE BOTIA BELEN', 'CRA 66AN #3A-35 BOSQUE PARAISO', 773220, 'F', to_date('27-10-1992', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (52760570, 'CAROLINA GIRALDO PINEDA', 'CRA 23AN  5-90  Apto. 608  Conjunto Ibiza  Prados Norte', 2743188, 'F', to_date('26-10-1990', 'dd-mm-yyyy'), 7200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (53734580, 'TATIANA ERIKA IBARRA RAMIREZ', 'CRA 22 AN  4-68 Urbanización Tasajero', 2178587, 'F', to_date('05-03-1990', 'dd-mm-yyyy'), 7200);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (46030490, 'JANETH PAREDES ZAMUDIO', 'CALLE 2 #6-56 BARRIO LAS COLINAS', 773220, 'F', to_date('24-08-1970', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (35470360, 'FERNANDO NELSON DIAZ GAONA', 'CRA 2 #29-09 BARRIO EL LAGO, SEGUNDA ETAPA', 680040, 'M', to_date('03-12-1989', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (13718100, 'ZARELA DIANA CASTILLA GAONA', 'CALLE 35 #8-03', 642720, 'F', to_date('16-04-1992', 'dd-mm-yyyy'), 300);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (23428210, 'CHRISTOFHER VALLADARES MARTINEZ', 'CRA 6AN 6AE-620 CEDRO II', 739200, 'M', to_date('13-11-1999', 'dd-mm-yyyy'), 2100);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (37233350, 'ARMANDO HUGO OROZCO ANAYA', 'CRA 7 #8-54 SANTA CRUZ', 827346, 'M', to_date('24-12-1990', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (21026270, 'PABLO JUAN CAMARGO MARTINEZ', 'CALLE 60A #60-94 DIVINO NIÑO', 773220, 'M', to_date('17-11-1998', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (93733920, 'FERNANDA ANDREA RIZZO TRILLOS', 'KDX 266-260 BARRIO FUNDADORES', 773220, 'F', to_date('02-02-1991', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (79145740, 'PEDRO IVAN NUÑEZ MENDOZA', 'CRA 2 #4-70 BULEVAR. CELESTINO VILLAMIZAR', 773220, 'M', to_date('27-02-1989', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (99267910, 'JESUS ALEXANDER GUTIERREZ ALCOCER', 'CRA 6B #23-636 EL LLANO', 773220, 'M', to_date('11-07-1977', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (98072980, 'ANDRE HAROLD IBARRA AMAYA', 'CRA 6 #4N-26 LA MARIA CASA 5 PESCADERO', 773220, 'M', to_date('23-02-1991', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (33902300, 'PAOLA NATALIA RANGEL ANAYA', 'CRA 68 #68N-640 MOLINOS DEL NORTE', 773220, 'F', to_date('12-07-1991', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (1094040, 'CAROLINA MARIA ANAYA CONTRERAS', 'CRA 65 #69-07 LA LIBERTAD', 773220, 'F', to_date('22-01-2000', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (36042330, 'ADELA BECERRA PALENCIA', 'CRA 5 #60-E', 773220, 'F', to_date('07-02-1983', 'dd-mm-yyyy'), 6400);

insert into EMPLEADOS_FAB (CODIGO_EMP, NOMBRE_EMP, DIRECCION, SALARIO, SEXO, FECHA_NAC, CODIGO_AREA)
values (71116780, 'VIDAL JUAN HERNANDEZ LOPEZ', 'CRA 60 BN #3-26 BARRIO PARAISO', 773220, 'M', to_date('01-05-1999', 'dd-mm-yyyy'), 6400);

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (34966380, 3, 'VELEZ RODRIGUEZ DARIO', 'N', null, 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (34966380, 4, 'VELEZ CARDENAS DARIO JUNIOR', 'N', null, 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (34966380, 5, 'VELEZ CARDENAS KENDY LORENA', 'N', null, 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (18820110, 6, 'GARCIA CARDENAS LUISA FERNANDA', 'F', to_date('14-12-2015', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (18820110, 7, 'GARCIA BUITRAGO PEDRO FELIPE', 'M', to_date('22-09-2024', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (18820110, 8, 'GARCIA CARDENAS CARMEN SOFIA', 'F', to_date('05-08-2007', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (26029240, 9, 'BERMUDEZ HERRERA JULIANA CAMILA', 'F', to_date('07-07-2007', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (26029240, 10, 'BERMUDEZ HERRERA CARLOS JAVIER', 'M', to_date('25-02-2010', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (26029240, 11, 'BERMUDEZ MENDOZA CARLOS JAVIER', 'M', to_date('08-02-1981', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (4965020, 12, 'GUZMAN ANGARITA HECTOR', 'M', to_date('10-11-1971', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (4965020, 13, 'GUZMAN VARGAS IVONNE MARITZA', 'F', to_date('23-09-1991', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (4965020, 14, 'GUZMAN VARGAS HECTOR MARIO', 'M', to_date('21-02-1997', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (4965020, 15, 'GUZMAN VARGAS WENDY MARCELA', 'F', to_date('25-10-2002', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (78824790, 16, 'RODRIGUEZ JAIMES JUAN SEBASTIAN', 'M', to_date('14-04-2009', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (1347000, 17, 'DUARTE BARRERA RAQUEL VANESA', 'F', to_date('08-03-2006', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (1347000, 18, 'DUARTE BARRERA WENDY JUDITH', 'F', to_date('27-03-2004', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (1347000, 19, 'DUARTE SANCHEZ MIREYA', 'F', to_date('12-09-1976', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (46030420, 20, 'QUINTERO PULIDO MARIA CAMILA', 'F', to_date('25-08-2019', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (62687620, 21, 'GUARNIZO PEREZ CARLOS ENRIQUE', 'M', to_date('10-09-1997', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (62687620, 22, 'GUARNIZO PEREZ ANA KARINA', 'F', to_date('30-08-2003', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (62687620, 23, 'GUARNIZO SANTAELLA ENRIQUE', 'M', to_date('25-09-1965', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (62687620, 24, 'GUARNIZO DE PEREZ ALICIA', 'F', to_date('08-12-1951', 'dd-mm-yyyy'), 'P');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (66760610, 25, 'ESTEBAN MORENO ANGELA', 'F', to_date('11-11-1963', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (66029630, 26, 'RIVERA CONTRERAS JULIANA LILIANA', 'F', to_date('25-12-1996', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (66029630, 27, 'RIVERA CONTRERAS ERICK JULIAN', 'M', to_date('10-08-2003', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (66029630, 28, 'RIVERA RODRIGUEZ ALVARO JAMES', 'M', to_date('21-06-1968', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (66029630, 29, 'RIVERA DE CONTRERAS FERNANDA', 'F', to_date('30-03-1950', 'dd-mm-yyyy'), 'P');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (66029630, 30, 'RIVERA CONTRERAS JAMES DAVID', 'M', to_date('07-05-1992', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (34965360, 31, ' CONTRERAS LUIS CAMILO', 'M', to_date('30-05-1997', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (34965360, 32, ' CONTRERAS JUAN SEBASTIAN', 'M', to_date('05-02-2000', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (34965360, 33, ' ANA DE JESUS', 'F', to_date('24-04-1956', 'dd-mm-yyyy'), 'P');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (61348690, 34, 'VILLAMIZAR BELTRAN INGRID TATIANA', 'F', to_date('18-05-1999', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (61348690, 35, 'VILLAMIZAR CONTRERAS JUAN FELIPE', 'M', to_date('30-08-2002', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (46026410, 36, 'CARDENAS VILLAMIZAR JULIAN PEDRO', 'M', to_date('11-06-2007', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (94966900, 37, 'VALENCIA TABARES ROSMIRA', 'N', null, 'P');


insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (94966900, 38, 'VALENCIA GIRALDO HUMBERTO', 'N', null, 'P');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (98821970, 39, 'SOTO SOTO CARLOS EDUARDO', 'N', null, 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (51345550, 44, 'SILVA CARDENAS CARLOS FABIAN', 'M', to_date('27-09-1993', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (51345550, 45, 'SILVA CARDENAS CARMEN B.', 'F', to_date('12-11-1996', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (81345840, 46, 'LEON ALVAREZ PABLO JOSE', 'M', to_date('09-04-2013', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (81345840, 47, 'LEON ALVAREZ PEDRO FELIPE', 'M', to_date('05-03-2004', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (81345840, 48, 'LEON JARAMILLO FRANCIA', 'F', to_date('18-09-2007', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (81345840, 49, 'LEON ALVAREZ JUAN SEBASTIAN', 'M', to_date('15-07-2009', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (21387210, 50, 'AYALA URIBE VILMA SOFIA', 'F', to_date('26-05-1994', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (21387210, 51, 'AYALA ORTIZ LINA MARIA', 'F', to_date('29-06-1993', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (36028390, 52, 'BARRETO CAMILO MATAMOROS BARRETO', 'M', to_date('28-11-2008', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (86039860, 53, 'CONTRERAS SEPULVEDA JUAN DARIO', 'M', to_date('16-04-2011', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (16029160, 54, 'VILLAMIZAR ALBARRACIN MAURICIO EDUARDO', 'M', to_date('11-05-2002', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (16029160, 55, 'VILLAMIZAR MARIA OLIVIA', 'F', to_date('07-12-1937', 'dd-mm-yyyy'), 'P');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (61344680, 56, 'BARBOSA CARDENAS BERTHA PATRICIA', 'F', to_date('19-08-1996', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (61344680, 57, 'BARBOSA CARDENAS CLAUDIA  INES', 'F', to_date('11-05-1990', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (61344680, 58, 'BARBOSA CARDENAS ERNEIDA', 'F', to_date('10-05-1991', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (61344680, 59, 'BARBOSA CARDENAS ANA YULEY', 'F', to_date('06-11-1992', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (61344680, 60, 'BARBOSA CELINA', 'F', to_date('08-12-1969', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (56330540, 61, 'TOBON FERNANDEZ CARLOS GUILLERMO', 'M', to_date('14-03-1974', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (53731530, 62, 'VEGA FUENTES ANNY CRISTINA', 'F', to_date('08-04-2009', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (53731530, 63, 'VEGA MARTINEZ ARGEMIRO JOSE', 'M', to_date('21-11-1965', 'dd-mm-yyyy'), 'C');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (24972290, 64, 'JACOME JACOME LUZ MARINA', 'N', null, 'N');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (81936840, 65, 'DUARTE LOPEZ YORLY KARINA', 'F', to_date('23-02-1998', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (81936840, 66, 'DUARTE SUAREZ YANINA', 'F', to_date('13-01-2024', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (81936840, 67, 'DUARTE LOPEZ RAUL DANIEL', 'M', to_date('25-10-2003', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (81936840, 68, 'DUARTE DE MARTINEZ ANA ISABEL', 'F', to_date('03-12-1946', 'dd-mm-yyyy'), 'P');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (81936840, 69, 'DUARTE LOPEZ GLADIZ YESENIA', 'F', to_date('11-06-1996', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (81936840, 70, 'DUARTE AVILA YANETH', 'F', to_date('14-12-1983', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (38824320, 71, 'RIVERA ROMERO HARRISON MICHELL', 'M', to_date('24-04-2014', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (38824320, 72, 'RIVERA PINTO EMILY SHARAY', 'F', to_date('29-05-2015', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (38824320, 73, 'RIVERA ROMERO FREYDDER LEONARDO', 'M', to_date('27-01-2016', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (38824320, 74, 'RIVERA PINTO LINCON SEBASTIAN', 'M', to_date('07-12-2017', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (38824320, 75, 'RIVERA POVEDA MARISOL', 'F', to_date('11-04-1989', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (36038390, 77, 'BOADA RINCON KATIA JULIETH', 'F', to_date('26-11-2007', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (36038390, 78, 'BOADA OSSA DIEGO PATRICIO', 'M', to_date('19-06-1983', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (53981510, 79, 'GUZMAN VERGARA YXEEL BALERIA', 'F', to_date('19-01-2025', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (53981510, 80, 'GUZMAN MEJIA RAFAEL ANTONIO', 'M', to_date('07-05-1998', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (53981510, 81, 'GUZMAN MEJIA YEISON FABIAN', 'M', to_date('31-03-1996', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (53981510, 82, 'GUZMAN MENECES ROSENDA', 'F', to_date('14-02-1965', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (53981510, 83, 'GUZMAN MEJIA YEIMI', 'F', to_date('07-03-1989', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (53981510, 84, 'GUZMAN MEJIA JEAN CARLOS', 'M', to_date('17-09-1991', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (88821840, 85, 'NIETO ACEVEDO MAZZIRE BAYRON EMMANUEL', 'M', to_date('12-11-2006', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (88821840, 86, 'NIETO ACEVEDO LIDSAY YAHANDRA', 'F', to_date('23-08-2010', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (68828640, 87, 'GAONA BENITEZ SHAYRA SOFIA', 'F', to_date('22-07-2019', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (68828640, 88, 'GAONA SANCHEZ JOHANNA SOFIA', 'F', to_date('28-06-1989', 'dd-mm-yyyy'), 'C');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (68828640, 89, 'GAONA ARENAS CARMEN FERNANDA', 'F', to_date('18-03-2007', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (68828640, 90, 'GAONA BENITEZ ADRIAN CAMILO', 'M', to_date('29-08-2009', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (31387390, 91, 'FORERO RODRIGUEZ ISABELLA', 'F', to_date('13-06-2015', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (35531320, 92, 'PINZON RESTREPO ISABEL', 'F', to_date('20-02-1999', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (35531320, 93, 'PINZON MONTOYA MARIA TERESA', 'F', to_date('10-03-1969', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (35531320, 94, 'PINZON RESTREPO ALEXANDER', 'M', to_date('26-02-1992', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (35531320, 95, 'PINZON RESTREPO EDGAR ALBERTO', 'M', to_date('17-11-1990', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (66333670, 96, 'OSORIO ARDILA JESUS DARIO', 'M', to_date('29-04-2011', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (66333670, 97, 'OSORIO ARDILA MARIA LUCIA', 'F', to_date('09-08-2007', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (66333670, 98, 'OSORIO CARRILLO JESUS DARIO', 'M', to_date('07-04-1972', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (64966650, 99, 'MURCIA CASTRO ARMANDO', 'M', null, 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (64966650, 100, 'MURCIA ROJAS LAURA DANIELA', 'F', to_date('22-11-2004', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (64966650, 101, 'MURCIA ROJAS PEDRO HUMBERTO', 'M', to_date('23-11-2005', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (16028170, 102, 'COLOBON GUERRERO JULIANA', 'F', to_date('17-03-2010', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (16028170, 103, 'COLOBON GUERRERO DANIELA', 'F', to_date('21-10-2006', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (81343840, 104, 'TARAZONA JAUREGUI RITA ISABEL', 'F', null, 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (81343840, 105, 'TARAZONA BONET LUCY TATIANA', 'F', to_date('10-04-1992', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (81343840, 106, 'TARAZONA BONET JOHANA CAROLINA', 'F', to_date('08-09-1995', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (81343840, 107, 'TARAZONA BONET JUAN CARLOS', 'M', to_date('29-04-1999', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (81343840, 108, 'TARAZONA POLICITIVO SANDRA', 'F', to_date('07-01-1993', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (81343840, 109, 'TARAZONA BONET LUIS CARLOS', 'M', to_date('20-02-1991', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (21337260, 110, 'MANOSALVA ORTEGA MARIA CAMILA', 'F', to_date('19-06-1998', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (21337260, 111, 'MANOSALVA ORTEGA LUISA MILENA', 'F', to_date('02-10-1991', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (21337260, 112, 'MANOSALVA MARTHA CECILIA', 'F', to_date('09-02-1970', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (21337260, 113, 'MANOSALVA ORTEGA JOHANA ', 'F', to_date('19-09-1990', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (3005010, 114, 'PINZON RAMIREZ SONIA', 'F', to_date('19-06-2010', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (38814380, 115, 'PEREZ ALVAREZ CARMEN FERNANDA', 'F', to_date('06-06-2010', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (38814380, 116, 'PEREZ ALVAREZ ALIX CAROLINA', 'F', to_date('04-04-2006', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (38814380, 117, 'PEREZ CLARO CARMEN', 'F', to_date('11-06-1982', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (57950530, 118, 'HERNANDEZ MARIA ALEXANDRA', 'F', to_date('23-06-1980', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (91348940, 119, 'PUERTO GOMEZ OMAR JULIAN', 'M', to_date('12-07-2014', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (91348940, 120, 'PUERTO OCHOA CARLOS PEDRO', 'M', to_date('28-12-2017', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (91348940, 121, 'PUERTO DELGADO MARTHA', 'F', to_date('16-12-1978', 'dd-mm-yyyy'), 'C');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (91348940, 122, 'PUERTO GOMEZ ANGELA', 'F', to_date('18-11-2007', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (46043470, 123, 'PAEZ GOMEZ TATIANA ', 'F', to_date('26-06-2016', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (38827370, 124, 'CHAPARRO PEREZ  SOFIA', 'F', to_date('05-12-1999', 'dd-mm-yyyy'), 'C');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (38827370, 125, 'CHAPARRO GARCIA JULIAN CAMILO', 'M', to_date('04-02-2022', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (61345690, 126, 'VASQUEZ OROZCO EGDAR HERNANDO', 'M', to_date('07-05-2014', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (61345690, 127, 'VASQUEZ SUAREZ MONICA MARIA', 'F', to_date('12-01-1981', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (41350470, 128, 'USECHE BOHORQUEZ YEHOSHUA', 'M', to_date('04-03-2017', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (41350470, 129, 'USECHE AMAYA MARTA LILIANA', 'F', to_date('02-10-1984', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (11014190, 130, 'MALDONADO MALDONADO MAGDA LICETH', 'F', null, 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (18826110, 131, 'SARMIENTO VILLAMIZAR ANA MARIA', 'F', to_date('27-05-2022', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (18826110, 132, 'SARMIENTO VILLAMIZAR DANIEL SANTIAGO', 'M', to_date('05-10-2027', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (18826110, 133, 'SARMIENTO VILLANUEVA MARIA DANIELA', 'F', to_date('10-06-1999', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (91346980, 134, 'HERNANDEZ GOMEZ MARIA FERNANDA', 'F', to_date('04-06-2000', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (91346980, 135, 'HERNANDEZ ESTEBAN MAGDALENA', 'F', to_date('07-03-1971', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (91346980, 136, 'HERNANDEZ GOMEZ JUAN CAMILO', 'M', to_date('03-06-2006', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (88819830, 137, 'WILCHES PEÑA MANUEL SANTIAGO', 'M', to_date('01-07-2012', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (88819830, 138, 'WILCHES PEÑA DANIELA SOFIA', 'F', to_date('19-12-2020', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (88819830, 139, 'WILCHES BELTRAN CARMEN SOFIA', 'F', to_date('14-01-1995', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (52760590, 140, 'RAMIREZ ESPINOSA PEDRO', 'M', to_date('22-11-2023', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (52760590, 141, 'RAMIREZ MENDOZA NORMA', 'F', to_date('23-10-1966', 'dd-mm-yyyy'), 'P');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (52760590, 142, 'RAMIREZ CUBILLOS PEDRO ALBERTO', 'M', to_date('22-07-1994', 'dd-mm-yyyy'), 'E');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (78827760, 143, 'ANGARITA TORRES  JOSUE ALEJANDRO', 'M', to_date('10-04-2017', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (78827760, 144, 'ANGARITA TORRES MANUEL DAVID', 'M', to_date('01-03-2021', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (68830660, 146, 'CACERES MARTINEZ CATALINA', 'F', to_date('04-11-2020', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (68830660, 147, 'CACERES FAJARDO MARTHA', 'F', to_date('10-02-1995', 'dd-mm-yyyy'), 'C');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (91532900, 148, 'RESTREPO ANILLO JUAN PABLO', 'M', to_date('05-03-2012', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (52760570, 149, 'GIRALDO DE PINEDA LUCRECIA', 'F', to_date('14-09-1962', 'dd-mm-yyyy'), 'P');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (53734580, 150, 'IBARRA RAMIREZ ISABEL', 'F', to_date('14-09-2030', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (53734580, 151, 'IBARRA LEON ENRIQUE JOSE', 'M', to_date('31-05-1999', 'dd-mm-yyyy'), 'C');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (53734580, 152, 'IBARRA RAMIREZ ERNESTO PEDRO', 'M', to_date('21-04-2028', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (53734580, 153, 'IBARRA RAMIREZ ORLANDO', 'M', to_date('29-08-1967', 'dd-mm-yyyy'), 'P');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (53734580, 154, 'IBARRA REINA TERESA', 'F', to_date('31-05-1968', 'dd-mm-yyyy'), 'P');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (8826030, 155, 'HERNANDEZ PORTILLO DANIELA', 'F', to_date('02-07-2020', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (8826030, 156, 'HERNANDEZ PORTILLO ALEJANDRA', 'F', to_date('24-12-2026', 'dd-mm-yyyy'), 'H');

insert into BENEFICIARIOS (CODIGO_EMP, CODIGO_BEN, NOMBRE_BEN, SEXO, FECHA_NAC, COD_PARENTESCO)
values (8826030, 157, 'HERNANDEZ PEREZ MARTHA', 'F', to_date('05-09-1990', 'dd-mm-yyyy'), 'E');

PROMPT --------------------------------------------------------------------------------
PROMPT ---- Registro de datos AREAS JEFES
PROMPT --------------------------------------------------------------------------------

UPDATE AREAS
SET    codigo_jefe = 34965360
,      fecha_jefe  = to_date('01-01-2020', 'dd-mm-yyyy')
WHERE  codigo_area = 7200;	

UPDATE AREAS
SET    codigo_jefe = 28831280
,      fecha_jefe  = to_date('01-01-2018', 'dd-mm-yyyy')
WHERE  codigo_area = 130;

UPDATE AREAS
SET    codigo_jefe = 91532900
,      fecha_jefe  = to_date('10-05-2019', 'dd-mm-yyyy')
WHERE  codigo_area = 132;

UPDATE AREAS
SET    codigo_jefe = 18811130
,      fecha_jefe  = to_date('01-02-2020', 'dd-mm-yyyy')
WHERE  codigo_area = 299;

INSERT INTO AREAS_MUN (CODIGO_AREA, CODIGO_MUN) VALUES (234, '68001');
INSERT INTO AREAS_MUN (CODIGO_AREA, CODIGO_MUN) VALUES (130, '68001');
INSERT INTO AREAS_MUN (CODIGO_AREA, CODIGO_MUN) VALUES (410, '68001');
INSERT INTO AREAS_MUN (CODIGO_AREA, CODIGO_MUN) VALUES (131, '68001');
INSERT INTO AREAS_MUN (CODIGO_AREA, CODIGO_MUN) VALUES (200, '68001');
INSERT INTO AREAS_MUN (CODIGO_AREA, CODIGO_MUN) VALUES (220, '68001');
INSERT INTO AREAS_MUN (CODIGO_AREA, CODIGO_MUN) VALUES (2310, '68001');

INSERT INTO AREAS_MUN (CODIGO_AREA, CODIGO_MUN) VALUES (299, '68276');
INSERT INTO AREAS_MUN (CODIGO_AREA, CODIGO_MUN) VALUES (210, '68276');
INSERT INTO AREAS_MUN (CODIGO_AREA, CODIGO_MUN) VALUES (260, '68276');

INSERT INTO AREAS_MUN (CODIGO_AREA, CODIGO_MUN) VALUES (334, '54001');
INSERT INTO AREAS_MUN (CODIGO_AREA, CODIGO_MUN) VALUES (7100, '54001');

INSERT INTO AREAS_MUN (CODIGO_AREA, CODIGO_MUN) VALUES (7300, '05001');
INSERT INTO AREAS_MUN (CODIGO_AREA, CODIGO_MUN) VALUES (2100, '05001');
INSERT INTO AREAS_MUN (CODIGO_AREA, CODIGO_MUN) VALUES (460, '05001');
INSERT INTO AREAS_MUN (CODIGO_AREA, CODIGO_MUN) VALUES (132, '05001');

ALTER TRIGGER T_UNIVERSIDAD_BI DISABLE;

INSERT INTO UNIVERSIDAD (COD_UNIVERSIDAD, NOM_UNIVERSIDAD) VALUES (1, 'UNAB');
INSERT INTO UNIVERSIDAD (COD_UNIVERSIDAD, NOM_UNIVERSIDAD) VALUES (2, 'UIS');
INSERT INTO UNIVERSIDAD (COD_UNIVERSIDAD, NOM_UNIVERSIDAD) VALUES (3, 'SANTO TOMAS');
INSERT INTO UNIVERSIDAD (COD_UNIVERSIDAD, NOM_UNIVERSIDAD) VALUES (4, 'ANDES');
INSERT INTO UNIVERSIDAD (COD_UNIVERSIDAD, NOM_UNIVERSIDAD) VALUES (5, 'UPB');

COMMIT;

ALTER TRIGGER T_UNIVERSIDAD_BI ENABLE;

--------------------------------------------------------------------------------
-----------                     Actualizaciones                      -----------
--------------------------------------------------------------------------------

UPDATE DEPARTAMENTOS 
SET NOMBRE_DEPTO = UPPER(NOMBRE_DEPTO);

COMMIT;

UPDATE MUNICIPIOS 
SET NOMBRE_MUN = UPPER(NOMBRE_MUN);

COMMIT;

UPDATE EMPLEADOS_FAB
SET SALARIO = 1160000
WHERE SALARIO < 1160000;

COMMIT;

--------------------------------------------------------------------------------
---- 7. Separar los nombres de los empleados
--------------------------------------------------------------------------------

-- Se crean los campos para almacenar la informacion del nombre
ALTER TABLE EMPLEADOS_FAB ADD NOMBRE1 VARCHAR2(20);
ALTER TABLE EMPLEADOS_FAB ADD NOMBRE2 VARCHAR2(20);
ALTER TABLE EMPLEADOS_FAB ADD APELLIDO1 VARCHAR2(20);
ALTER TABLE EMPLEADOS_FAB ADD APELLIDO2 VARCHAR2(20);

-- Separar los nombres
SELECT nombre_emp, 
       TRIM(SUBSTR(nombre_emp,1, INSTR(TRIM(nombre_emp),' '))) AS nombre1,  
       TRIM(SUBSTR(nombre_emp,INSTR(TRIM(nombre_emp),' '),(INSTR(TRIM(nombre_emp),' ',-1,2)-INSTR(TRIM(nombre_emp),' ')))) AS nombre2,
       TRIM(SUBSTR(nombre_emp,INSTR(TRIM(nombre_emp),' ',-1,2),(INSTR(TRIM(nombre_emp),' ',-1,1)-INSTR(TRIM(nombre_emp),' ',-1,2)) )) AS apellido1,
       TRIM(SUBSTR(nombre_emp,INSTR(TRIM(nombre_emp),' ',-1),LENGTH(TRIM(nombre_emp)))) AS apellido2
FROM   Empleados_FAB;

-- Actualizo los datos
UPDATE Empleados_FAB
SET    nombre1 = TRIM(SUBSTR(nombre_emp,1, INSTR(TRIM(nombre_emp),' '))),  
       nombre2 = TRIM(SUBSTR(nombre_emp,INSTR(TRIM(nombre_emp),' '),(INSTR(TRIM(nombre_emp),' ',-1,2)-INSTR(TRIM(nombre_emp),' ')))),
       apellido1 = TRIM(SUBSTR(nombre_emp,INSTR(TRIM(nombre_emp),' ',-1,2),(INSTR(TRIM(nombre_emp),' ',-1,1)-INSTR(TRIM(nombre_emp),' ',-1,2)) )),
       apellido2 = TRIM(SUBSTR(nombre_emp,INSTR(TRIM(nombre_emp),' ',-1),LENGTH(TRIM(nombre_emp))));

COMMIT;

-- Una vez se han verificado los datos, se elimina el campo NOMBRE_EMP
ALTER TABLE EMPLEADOS_FAB DROP COLUMN NOMBRE_EMP;


--------------------------------------------------------------------------------
---- 8. Asignar y guardar el email para cada empleado
--------------------------------------------------------------------------------

-- Se crean los campos para almacenar la informacion del email
ALTER TABLE EMPLEADOS_FAB ADD EMAIL VARCHAR2(50);

-- Verifico como se construye la informacion para el email
SELECT nombre1, apellido1, LOWER(SUBSTR(nombre1,1,1)||apellido1)||'@multinacional.com' AS email
FROM   EMPLEADOS_FAB; 

-- Se actualiza el email como primer letra nombre.apellido1
UPDATE EMPLEADOS_FAB
SET    email = LOWER(SUBSTR(nombre1,1,1)||apellido1)||'@multinacional.com'; 

COMMIT;

-- Verifico la informacion en la tabla
SELECT *
FROM   EMPLEADOS_FAB; 


--------------------------------------------------------------------------------
---- 9. Actualizar Area del Empleado
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Los empleados del área 2420- Almacenes van a ser reasignados al área 410 –Mercado mayorista
--------------------------------------------------------------------------------

-- verifica empleados en el area 2440 y 410, hay 1 y 2 respectivamente;
SELECT * FROM empleados_FAB WHERE codigo_area IN (2420, 410); 

-- Se realiza el cambio de area
UPDATE empleados_FAB
SET    codigo_area = 410
WHERE  codigo_area = 2420;

COMMIT;

-- verifica empleados en el area 2440 y 410, hay 0 y 3 respectivamente;
SELECT * FROM empleados_FAB WHERE codigo_area IN (2420, 410); 


--------------------------------------------------------------------------------
-- Reasignacion de areas, para el area con mayor numero de empleados
--------------------------------------------------------------------------------

-- Verifica cantidad de empleados por area;
SELECT codigo_area, COUNT(*) AS cantidad
FROM   empleados_FAB 
WHERE  codigo_area IN (6200,7200,640,460,133,4330,2100,132,2310,1100,135,400,4000,230)
GROUP BY codigo_area
ORDER BY  cantidad DESC;

-- Se realiza el cambio de area
UPDATE empleados_FAB
SET    codigo_area = 2100
WHERE  codigo_area IN (133,230);


--------------------------------------------------------------------------------
-- Eliminacion de areas sin empleados, en este caso area 133 y 230.
--------------------------------------------------------------------------------

-- Verificamos si las aresa a eliminar estan registradas en AREAS_MUN, dado que entre AREAS y AREAS_MUN hay una relación.

-- Forma 1. Verifica areas que estan relacionadas en la tabla areas_mun;
SELECT a.*
FROM   areas a, areas_mun m
WHERE  a.codigo_area IN (6200,7200,640,460,133,4330,2100,132,2310,1100,135,400,4000,230)
AND    m.codigo_area = a.codigo_area;

-- Forma 2. Verifica areas que estan relacionadas en la tabla areas_mun;
SELECT a.*
FROM   areas a
WHERE  a.codigo_area IN (6200,7200,640,460,133,4330,2100,132,2310,1100,135,400,4000,230)
AND    EXISTS (SELECT 1 FROM areas_mun m WHERE m.codigo_area = a.codigo_area);

-- Si el área a eliminar esta en Areas_mun, debo eliminar el registro
DELETE FROM areas_mun
WHERE  codigo_area IN (133,230); 

-- Eliminar areas sin empleados
DELETE FROM areas
WHERE  codigo_area IN (133,230);

--------------------------------------------------------------------------------
---- 10. Se requiere generar listado de empleados indicando nombres, salario, sexo y edad.
--------------------------------------------------------------------------------

-- Creo una vista con la informacion del Empleado y areas
--CREATE OR REPLACE FORCE VIEW V_EMPLEADOS_FAB AS 
--SELECT e.codigo_emp, (e.nombre1||' '||e.nombre2||' '||e.apellido1||' '||e.apellido2) AS nombre_emp
----,      e.direccion, e.salario, e.sexo, DECODE(e.sexo, 'F', 'Femenino', 'M', 'Masculino', 'Sin Dato') AS d_sexo
--,      e.email, e.fecha_nac, ROUND((SYSDATE-e.fecha_nac)/365) AS edad, e.codigo_area AS area, a.nombre_area, a.codigo_jefe
--,     (j.nombre1||' '||j.nombre2||' '||j.apellido1||' '||j.apellido2) AS nombre_jefe, j.email As email_jefe
--FROM   empleados_fab e, areas a, empleados_fab j  
--WHERE  e.codigo_area = a.codigo_area
--AND    a.codigo_jefe = j.codigo_emp(+);
--/
--
---- Sobre la vista V_EMPLEADOS_FAB realizó la consulta punto 10
--SELECT codigo_emp, nombre_emp, salario, sexo, d_sexo, edad
--FROM   V_EMPLEADOS_FAB; 
--
--
----------------------------------------------------------------------------------
------ 11. Se requiere generar listado de empleados que sean mujeres y que estén en un rango de edad entre 20 y 35 años
----------------------------------------------------------------------------------
--
---- Sobre la vista V_EMPLEADOS_FAB realizó la consulta punto 11 
--SELECT codigo_emp, nombre_emp, salario, sexo, d_sexo, edad
--FROM   V_EMPLEADOS_FAB
--WHERE  sexo = 'F' AND edad BETWEEN 20 AND 35
--ORDER  BY nombre_emp; 
--
----------------------------------------------------------------------------------
------ 12. Listado de los cumpleaños
----------------------------------------------------------------------------------
--
---- OPCION 1:
--SELECT nombre_emp, TO_CHAR(fecha_nac,'MONTH') AS mes, TO_CHAR(fecha_nac,'DD') AS dia, email
--FROM   V_EMPLEADOS_FAB
--ORDER  BY mes, dia; 
--
---- OPCION 2:
--SELECT nombre_emp, TO_CHAR(fecha_nac,'MONTH', 'NLS_DATE_LANGUAGE = SPANISH') AS mes, TO_CHAR(fecha_nac,'DD') AS dia, email
--FROM   V_EMPLEADOS_FAB
--ORDER  BY mes, dia;
--
--
----------------------------------------------------------------------------------
------ 13. listado de los beneficiarios menores de 15 años
----------------------------------------------------------------------------------
--
---- Creo una vista con la informacion del Empleado y sus beneficiarios
--CREATE OR REPLACE FORCE VIEW V_BENEFICIARIOS AS 
--SELECT b.codigo_emp, (e.nombre1||' '||e.nombre2||' '||e.apellido1||' '||e.apellido2) AS nombre_emp
--,      b.codigo_ben, b.nombre_ben, b.sexo, DECODE(b.sexo,'F','Femenino','Masculino') AS descripcion
--,      b.cod_parentesco, p.nom_parentesco,  b.fecha_nac, ROUND(MONTHS_BETWEEN(SYSDATE,b.fecha_nac)/12) AS edad
--FROM   beneficiarios b, empleados_fab e, parentesco p
--WHERE  b.codigo_emp     = e.codigo_emp 
--AND    b.cod_parentesco = p.cod_parentesco;
--/
--
--
---- Sobre la vista V_BENEFICIARIOS realizo la consulta para el punto 13
--SELECT *
--FROM   V_BENEFICIARIOS
--WHERE  edad <= 15
--ORDER BY codigo_emp;   
--
--
----------------------------------------------------------------------------------
------ 14. Estadisticas sobre informacion de empleados
----------------------------------------------------------------------------------
--
---- Salario mínimo, máximo y promedio de los empleados
--SELECT MAX(salario) AS maximo, MIN(salario) AS minimo, AVG(salario) As promedio
--FROM   empleados_fab;   
--
---- Cantidad de empleados por salario 
--SELECT salario, COUNT(*) AS total_empleados
--FROM   empleados_fab
--GROUP BY salario
--ORDER BY salario;
--
---- Valor de la nomina a pagar a fin de mes
--SELECT SUM(salario) AS total_nomina
--FROM   empleados_fab;
--
---- Valor de la nomina a pagar a fin de mes - aplico formato al numero
--SELECT TO_CHAR(SUM(salario),'$999,999,999') AS total_nomina
--FROM   empleados_fab;
--
---- Cantidad de hombres y mujeres
--SELECT sexo, d_sexo, COUNT(*) AS cantidad
--FROM   v_empleados_fab
--GROUP BY sexo, d_sexo;
--
---- Cantidad de empleados en rango de salarios mínimo, así cuantos ganan 1 SMLV, 2 SMLV, etc
--SELECT ROUND(salario/1000000,0) AS SMLV, COUNT(*) AS cantidad
--FROM   empleados_fab
--GROUP BY ROUND(salario/1000000,0)
--ORDER BY 1;
--
--
----------------------------------------------------------------------------------
------ 15. Valor a pagar por parte de la empresa a Seguridad Social
----------------------------------------------------------------------------------
--
--SELECT (salud_emp + pension_emp) AS aporte_emp, (salud_fab + pension_fab) AS aporte_fab
--FROM (
--        SELECT SUM(ROUND(salario*4/100,0)) AS salud_emp, SUM(ROUND(salario*8.5/100,0)) AS salud_fab
--        ,      SUM(ROUND(salario*4/100,0)) AS pension_emp, SUM(ROUND(salario*12/100,0)) AS pension_fab
--        FROM   empleados_fab
--     );

