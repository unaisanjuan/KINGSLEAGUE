DROP TABLE TEMPORADAS CASCADE CONSTRAINTS;
DROP TABLE JORNADAS CASCADE CONSTRAINTS;
DROP TABLE PARTIDOS CASCADE CONSTRAINTS;
DROP TABLE EQUIPOS CASCADE CONSTRAINTS;
DROP TABLE JUGADORES CASCADE CONSTRAINTS;
DROP TABLE STAFFS CASCADE CONSTRAINTS;
DROP TABLE PRESIDENTES CASCADE CONSTRAINTS;
DROP TABLE PARTIDOS_LOCALES;
DROP TABLE PARTIDOS_VISITANTES;
DROP TABLE EQUIPOS_JUGADORES;
DROP TABLE EQUIPOS_STAFFS;
DROP TABLE USUARIOS;
DROP TABLE TEMP_XML_GEN;

DROP SYNONYM PERSONAL;
DROP SYNONYM PLANTILLA;


CREATE TABLE TEMPORADAS(
	ID_TEMPORADA NUMBER
    GENERATED ALWAYS AS IDENTITY
    MAXVALUE 500
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE,
	FECHA_INICIO DATE,
	FECHA_FIN DATE,
	ESTADO VARCHAR2(20),
    PERIODO VARCHAR(3),
    CONSTRAINT TEM_ID_PK PRIMARY KEY (ID_TEMPORADA),
    CONSTRAINT TEM_EST_CK CHECK (ESTADO IN ('CERRADO', 'ABIERTO')),
    CONSTRAINT TEM_PER_CK CHECK (PERIODO IN ('INV', 'VER'))
);

CREATE TABLE JORNADAS(
	ID_JORNADA NUMBER
    GENERATED ALWAYS AS IDENTITY
    MAXVALUE 500
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE,
	ID_TEMPORADA NUMBER,
	NUM_JORNADA NUMBER,
    FECHA DATE,
	CONSTRAINT JOR_ID_PK PRIMARY KEY (ID_JORNADA),
    CONSTRAINT JOR_ID_TEMP_FK FOREIGN KEY (ID_TEMPORADA) REFERENCES TEMPORADAS(ID_TEMPORADA)
);

CREATE TABLE EQUIPOS(
	ID_EQUIPO NUMBER
    GENERATED ALWAYS AS IDENTITY
    MAXVALUE 500
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE,
	NOMBRE VARCHAR2(50),
	PRESUPUESTO NUMBER(9),
	CONSTRAINT EQU_ID_PK PRIMARY KEY (ID_EQUIPO)
);

CREATE TABLE PARTIDOS(
	ID_PARTIDO NUMBER
    GENERATED ALWAYS AS IDENTITY
    MAXVALUE 500
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE,
	TIPO_PARTIDO VARCHAR2(2),
	HORA VARCHAR2(5),
	ID_JORNADA NUMBER,
    ID_EQUIPO_GANADOR NUMBER,
	CONSTRAINT PAR_ID_PK PRIMARY KEY (ID_PARTIDO),
	CONSTRAINT PAR_ID_JOR_FK FOREIGN KEY (ID_JORNADA) REFERENCES JORNADAS(ID_JORNADA),
    CONSTRAINT PAR_ID_EQU_FK FOREIGN KEY (ID_EQUIPO_GANADOR) REFERENCES EQUIPOS(ID_EQUIPO),
    CONSTRAINT PAR_ID_EQU_CK CHECK (TIPO_PARTIDO IN('FR','PO'))
);

CREATE TABLE JUGADORES(
	ID_JUGADOR NUMBER
    GENERATED ALWAYS AS IDENTITY
    MAXVALUE 500
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE,
	NOMBRE VARCHAR2(50),
	APELLIDO VARCHAR2(50),
	DNI VARCHAR2(9) UNIQUE NOT NULL,
	POSICION VARCHAR2(2),
	TIPO_JUGADOR VARCHAR2(10),
	CONSTRAINT JUG_ID_PK PRIMARY KEY(ID_JUGADOR),
	CONSTRAINT JUG_POS_CK CHECK (POSICION IN ('DC','DF','MC', 'P')),
	CONSTRAINT JUG_TIP_CK CHECK (TIPO_JUGADOR IN ('HABITUAL', 'WILDCARD'))
);

CREATE TABLE STAFFS(
	ID_STAFF NUMBER
    GENERATED ALWAYS AS IDENTITY
    MAXVALUE 500
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE,
	NOMBRE VARCHAR2(50),
	APELLIDO VARCHAR2(50),
	DNI VARCHAR2(9) UNIQUE NOT NULL,
	ROL VARCHAR2(20),
	CONSTRAINT STA_ID_PK PRIMARY KEY (ID_STAFF),
	CONSTRAINT STA_ROL_CK CHECK (ROL IN ('ENTRENADOR1', 'ENTRENADOR2', 'ANALISTA', 'PSICOLOGO','FISIOTERAPEUTA'))
);

CREATE TABLE PRESIDENTES(
	ID_PRESIDENTE NUMBER
    GENERATED ALWAYS AS IDENTITY
    MAXVALUE 99
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE,
	NOMBRE VARCHAR2(50),
	APELLIDO VARCHAR2(50),
	DNI VARCHAR2(9) UNIQUE NOT NULL,
	ID_EQUIPO NUMBER,
	CONSTRAINT PRE_ID_PK PRIMARY KEY (ID_PRESIDENTE),
	CONSTRAINT PRE_ID_EQU_FK FOREIGN KEY (ID_EQUIPO) REFERENCES EQUIPOS(ID_EQUIPO)
);

CREATE TABLE EQUIPOS_JUGADORES(
	ID_EQUIPO NUMBER,
	ID_JUGADOR NUMBER,
	SUELDO NUMBER,
	FECHA_INICIO DATE,
	FECHA_FIN DATE,
	CLAUSULA NUMBER,
	CONSTRAINT EQUJUG_IDS_PK PRIMARY KEY (ID_EQUIPO, ID_JUGADOR),
	CONSTRAINT EQUJUG_ID_EQU_FK FOREIGN KEY (ID_EQUIPO) REFERENCES EQUIPOS(ID_EQUIPO),
	CONSTRAINT EQUJUG_ID_JUG_FK FOREIGN KEY (ID_JUGADOR) REFERENCES JUGADORES(ID_JUGADOR),
	CONSTRAINT EQUJUG_SUELDO_CK CHECK(SUELDO IN('10000000','10500000','15000000','22500000')),
	CONSTRAINT EQUJUG_CLAUSULA_CK CHECK(CLAUSULA >= 1000000)
);


CREATE TABLE EQUIPOS_STAFFS(
	ID_EQUIPO NUMBER,
	ID_STAFF NUMBER,
	SUELDO NUMBER,
	FECHA_INICIO DATE,
	FECHA_FIN DATE,
	CONSTRAINT EQUSTA_IDS_PK PRIMARY KEY (ID_EQUIPO, ID_STAFF),
	CONSTRAINT EQUSTA_ID_EQU_FK FOREIGN KEY (ID_EQUIPO) REFERENCES EQUIPOS(ID_EQUIPO),
	CONSTRAINT EQUSTA_ID_STA_FK FOREIGN KEY (ID_STAFF) REFERENCES STAFFS(ID_STAFF)
);

CREATE TABLE PARTIDOS_LOCALES(
	ID_EQUIPO NUMBER,
	ID_PARTIDO NUMBER,
	GOLES NUMBER,
	CONSTRAINT PAR_LOC_IDS_PK PRIMARY KEY (ID_EQUIPO, ID_PARTIDO),
	CONSTRAINT PAR_LOC_ID_EQU_FK FOREIGN KEY (ID_EQUIPO) REFERENCES EQUIPOS(ID_EQUIPO),
	CONSTRAINT PAR_LOC_ID_PAR_FK FOREIGN KEY (ID_PARTIDO) REFERENCES PARTIDOS(ID_PARTIDO)
);

CREATE TABLE PARTIDOS_VISITANTES(
	ID_EQUIPO NUMBER,
	ID_PARTIDO NUMBER,
	GOLES NUMBER,
	CONSTRAINT PAR_VIS_IDS_PK PRIMARY KEY (ID_EQUIPO, ID_PARTIDO),
	CONSTRAINT PAR_VIS_ID_EQU_FK FOREIGN KEY (ID_EQUIPO) REFERENCES EQUIPOS(ID_EQUIPO),
	CONSTRAINT PAR_VIS_ID_PAR_FK FOREIGN KEY (ID_PARTIDO) REFERENCES PARTIDOS(ID_PARTIDO)
);

CREATE TABLE USUARIOS(
	ID_USUARIO NUMBER
    GENERATED ALWAYS AS IDENTITY
    MAXVALUE 99
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE,
	EMAIL VARCHAR2(100),
	USERNAME VARCHAR2(20),
	PASSWORD VARCHAR2(30),
	ADMIN VARCHAR2(1),
	CONSTRAINT USU_ID_PK PRIMARY KEY (ID_USUARIO),
	CONSTRAINT USU_ADM_CK CHECK(ADMIN IN ('S', 'N'))
);

CREATE TABLE TEMP_XML_GEN(
	RESULTADO CLOB
);

--SINONIMOS
CREATE SYNONYM PERSONAL FOR EQUIPOS_STAFFS;

CREATE SYNONYM PLANTILLA FOR EQUIPOS_JUGADORES;