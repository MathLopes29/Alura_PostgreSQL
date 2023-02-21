/* Comandos DML e DDL 

	DML 
	- Insert Updade Delete Select
	 
	(DDL) permite aos usuários especificar um esquema de banco de dados através de um conjunto de definições. Portanto, um esquema é o projeto geral de um banco de dados e raramente é modificado
	- Create Alter Drop
	
	(DCL) inclui comandos como GRANT e REVOKE que lidam principalmente com os direitos, permissões e outros controles do sistema de banco de dados. 
	- GRANT: concede aos usuários privilégios de acesso ao banco de dados. 
	- REVOKE: retira os privilégios de acesso do usuário dados usando o comando GRANT.

	(TCL) são usados para gerenciar transações no banco de dados. Dessa forma, um conjunto de instruções SQL correlacionadas logicamente e executadas nos dados armazenados na tabela é conhecido como transação.  
	- COMMIT: confirma uma transação. 
	- ROLLBACK: reverte uma transação no caso de ocorrer algum erro. 
	- SAVE POINT: define um ponto de salvamento dentro de uma transação.

/* Criando um Database

CREATE DATABASE name
    [ WITH ] [ OWNER [=] user_name ]
           [ TEMPLATE [=] template ]
           [ ENCODING [=] encoding ]
           [ STRATEGY [=] strategy ] ]
           [ LOCALE [=] locale ]
           [ LC_COLLATE [=] lc_collate ]
           [ LC_CTYPE [=] lc_ctype ]
           [ ICU_LOCALE [=] icu_locale ]
           [ LOCALE_PROVIDER [=] locale_provider ]
           [ COLLATION_VERSION = collation_version ]
           [ TABLESPACE [=] tablespace_name ]
           [ ALLOW_CONNECTIONS [=] allowconn ]
           [ CONNECTION LIMIT [=] connlimit ]
           [ IS_TEMPLATE [=] istemplate ]
           [ OID [=] oid ]



		-- Database: DB_ALURA
		-- DROP DATABASE IF EXISTS "DB_ALURA";

		CREATE DATABASE "DB_ALURA"
			WITH
			OWNER = postgres
			ENCODING = 'UTF8'
			LC_COLLATE = 'Portuguese_Brazil.1252'
			LC_CTYPE = 'Portuguese_Brazil.1252'
			TABLESPACE = pg_default
			CONNECTION LIMIT = -1
			IS_TEMPLATE = False;

		COMMENT ON DATABASE "DB_ALURA"
			IS 'Database do curso de PostgreSQL';
*/


/* IMPORT E EXPORT EXEMPLO*/
COPY Cursos_Prog TO /* EXPORT */ /* FROM - IMPORT */
'D:\Matheus\Cursos\[BACKUP] Domine as Linguagens SQL e T-SQL\Arquivo PostgreSQL\REL_LOCADORA.csv'
DELIMITER ';'
CSV HEADER;

/* NO MUNDO REAL 
 
	DATA_SCIENCE -> ETL, PHP e PDO
 
 */

/* CREATE SCHEMA */
CREATE SCHEMA Academico;
SHOW DATESTYLE;

CREATE TABLE IF NOT EXISTS Academico.aluno (
    id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL CHECK (primeiro_nome != ''),
	ultimo_nome VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL DEFAULT NOW()::DATE
);

CREATE TABLE IF NOT EXISTS Academico.categoria (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE  IF NOT EXISTS Academico.curso (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES Academico.categoria(id)
);

CREATE TABLE IF NOT EXISTS Academico.aluno_curso (
	aluno_id INTEGER NOT NULL REFERENCES Academico.aluno(id)  
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	curso_id INTEGER NOT NULL REFERENCES Academico.curso(id),
	PRIMARY KEY (aluno_id, curso_id)
);


INSERT INTO Academico.Aluno (Primeiro_Nome, Ultimo_Nome, Data_nascimento) VALUES
('Lucas','Santos','12-30-2000'),
('Carlos','Augusto','09-07-2001'),
('Marcos','Luiz','11-04-2003'),
('Ana','Marquez','05-08-2004'),
('Luiza','Andrade','01-11-2002');

INSERT INTO Academico.Categoria (Nome) VALUES 
('Banco de Dados'),
('Programação'),
('Front End'),
('Android'),
('Outros');

INSERT INTO Academico.Curso (Nome, Categoria_id) VALUES 
('SQL',1),
('Java',2),
('React',4),
('PHP',3),
('CSS',3),
('Python',2),
('C#',2),
('SQL Server',1),
('MariaDB',1),
('PostgreSQL',1),
('Adobe',5);

INSERT INTO Academico.Aluno_Curso (Aluno_id, Curso_id) VALUES
(5,10),
(4,6),
(1,7),
(2,4),
(3,9),
(2,2),
(1,3),
(5,6),
(3,8),
(4,11),
(2,7),
(5,8),
(5,3),
(1,4),
(1,9);

/* INSERT SELECT */
SELECT * FROM Academico.Curso
JOIN Academico.Categoria ON Academico.Categoria.id = Academico.Curso.Categoria_id
WHERE Categoria_id = 2;

DROP TABLE Cursos_Prog;
CREATE TEMPORARY TABLE Cursos_Prog(
	id_Curso INTEGER PRIMARY KEY UNIQUE,
	Nome_Curso VARCHAR (255) NOT NULL
);

INSERT INTO Cursos_Prog
SELECT Academico.Curso.id, Academico.Curso.Nome 
FROM Academico.Curso ;

SELECT * FROM Cursos_Prog;

/* UPDADTE E DELETE*/
UPDATE Academico.Curso  SET Nome = 'C' WHERE id = 7;

UPDATE Cursos_Prog SET nome_curso = Academico.Curso.Nome
FROM Academico.Curso WHERE Cursos_Prog.id_Curso = Academico.Curso.id;

DELETE FROM curso
      USING categoria
      WHERE categoria.id = curso.categoria_id
        AND categoria.nome = 'Teste';

/* ROLLBACK COMMIT */
BEGIN;
	DELETE FROM Cursos_Prog;
	ROLLBACK;
	
	SELECT * FROM Cursos_Prog;
	COMMIT;
END;

/* DML */
SELECT Aluno_id AS "ID_Aluno", Primeiro_Nome AS "Nome", Curso_id AS "ID_Curso", Nome AS "Curso_Nome" FROM Academico.Aluno_Curso
JOIN Academico.Aluno  ON Academico.Aluno.id = Aluno_Curso.Aluno_id
JOIN Academico.Curso  ON Academico.Curso.id =  Aluno_Curso.Curso_id
;

SELECT * FROM Academico.Curso
JOIN Academico.Categoria ON Academico.Categoria_id
WHERE Categoria_id = 2;

/* TABELA TEMPORARY */
CREATE TEMPORARY TABLE Teste(
	/*Coluna Varchar (255) NOT NULL CHECK (Coluna != ''),*/
	Coluna_1 VARCHAR (255) NOT NULL CHECK (Coluna_1 != ''),
	Coluna_2 VARCHAR (255) NOT NULL,
	UNIQUE (Coluna_1, Coluna_2)
);

INSERT INTO Teste VALUES (NULL);
INSERT INTO Teste VALUES 
('a','c'),
('a','b');

SELECT *  FROM Teste;

ALTER TABLE Teste RENAME TO Teste_Final;
ALTER TABLE Teste RENAME Coluna_2 TO Segunda_Coluna;

/* SEQUENCE */
create sequence sq_login;

select nextval('sq_login');
select currval('sq_login');

drop table auto;

create temporary table auto (
	id integer primary key default nextval('sq_login'),
	nome varchar (255) not null
);

insert into auto (id,nome) values 
(nextval('sq_login'),'Mateus'),
(nextval('sq_login'),'Thiago'),
(nextval('sq_login'),'Vinicíus');

insert into auto (id, nome) values (5,'Lucas');

/*  ERRO  
	insert into auto (nome) values ('Lucas');
*/

/* FUNCIONA */
insert into auto (nome) values ('Carlos');

select * from auto;


/* CHECK x ENUM */
create type Classificacao as enum ('Livre', '+12', '+16', '+18')
create temporary table filme(
	id serial primary key ,
	nome varchar (255) not null,
	info Classificacao
);

create temporary table filme_2(
	id serial primary key ,
	nome varchar (255) not null,
	info char (3) check (info in ('L','+12','+16','+18'))
);
