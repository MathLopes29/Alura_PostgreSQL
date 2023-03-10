/*
TIPOS DE VARIÁVEIS MAIS USADAS:

integer
real
serial
numeric

varchar
char
text

boolean

date 
time
timestamp

FATAL ERROR -> C:\Users\User\AppData\Roaming\pgadmin  OR  Services */

/* Criação das Tabelas */
SELECT NOW();
SHOW DATESTYLE;

DROP TABLE ALUNO;

CREATE TABLE Aluno(
 Id_Aluno SERIAL,
 Nome VARCHAR (255),
 CPF CHAR(11),
 Obs TEXT,
 Idade Integer,
 Dinheiro Numeric(10,2),
 Altura Real,
 Ativo BOOLEAN,
 Data_Nascimento Date,
 Hora_Aula Time,
 Data_Matricula TIMESTAMP
);

/* Insert de Dados, Update, Delete e Select  */
INSERT INTO Aluno VALUES
(3,'Giovana','04871123650','Estudante',10, 311.00, 1.65, TRUE,'07-29-2001','10:00:00','06-28-2022  11:36:00'),
(4,'Ana','71792018421','Estudante',18, 132.00, 1.67, TRUE,'02-19-2004','08:30:00','02-10-2022  18:50:00');

SELECT * FROM ALUNO WHERE Id_Aluno = 1;
SELECT * FROM ALUNO WHERE NOME = 'Junior';

UPDATE ALUNO 
	SET Nome = 'Junior',
		 CPF = '63249871025',
		 Obs = 'Teste',
		 Idade = 17,
		 Dinheiro = 50.00,
		 Altura = 1.75,
		 Ativo = FALSE,
		 Data_Nascimento = '04-17-1999',
		 Hora_Aula = '07:45:00',
		 Data_Matricula = '01-25-2019  19:12:00'
	WHERE Id_Aluno = 2;

DELETE FROM ALUNO WHERE NOME = 'Junior'; 

SELECT A.NOME FROM ALUNO A;
SELECT ALUNO.CPF AS "CPF", ALUNO.NOME AS "NOME" FROM ALUNO;
SELECT ALUNO.CPF AS "CPF", ALUNO.NOME AS "NOME" FROM ALUNO WHERE ALUNO.NOME != 'Junior';
SELECT * FROM Aluno WHERE nome LIKE 'Jun_or';
SELECT * FROM Aluno WHERE nome LIKE '%A%';
SELECT * FROM ALUNO WHERE CPF IS NOT NULL;
SELECT ROUND(AVG (idade), 2) AS "MEDIA DE IDADE" FROM Aluno; 
SELECT * FROM Aluno WHERE idade BETWEEN 16 AND 18;
SELECT * FROM Aluno WHERE nome LIKE 'A%' OR CPF IS NOT NULL;
SELECT * FROM Aluno WHERE nome LIKE 'A%' AND CPF IS NOT NULL;

CREATE TABLE Curso(
	id SERIAL PRIMARY KEY,
	nome varchar (255) not null
);

INSERT INTO Curso VALUES 
(1,'Java'),
(2,'PostgreSQL'),
(3,'Python');

SELECT * FROM Curso;

CREATE TABLE Aluno(
	id SERIAL PRIMARY KEY,
	Nome VARCHAR(255) NOT NULL
);

INSERT INTO Aluno (Nome) VALUES 
('Marcos'),
('Thiago'),
('Marcelo');

CREATE TABLE Aluno_Curso (
 Aluno_Id INTEGER,
 Curso_Id INTEGER,

 FOREIGN KEY (Aluno_Id) REFERENCES Aluno (id),
 FOREIGN KEY (Curso_Id) REFERENCES Curso (id)
);

INSERT INTO Aluno_Curso (Aluno_Id, Curso_Id) VALUES 
(3,2), 
(1,3), 
(2,1),
(3,4);

/* Inner Join */
SELECT Aluno_Curso.Aluno_id, A.Nome, Aluno_Curso.Curso_id, C.Nome 
FROM Aluno A 
INNER JOIN Aluno_Curso 
ON A.id = Aluno_Curso.Aluno_id 
INNER JOIN Curso C 
ON C.id = Aluno_Curso.Curso_id;

/* Insert de novos dados*/
INSERT INTO Aluno (Nome) VALUES
('Nico');

SELECT * FROM Aluno;

INSERT INTO Curso (id, Nome) VALUES
(4,'CSS');

SELECT * FROM Curso;

/* Right, Left and Full outher Jojn */
SELECT 
	Aluno.nome as "Nome do Aluno", 
	Curso.nome as "Nome do Curso"
FROM Aluno 
RIGHT JOIN Aluno_Curso ON Aluno_Curso.Aluno_Id = Aluno.id
RIGHT JOIN Curso ON Aluno_Curso.Curso_Id = Curso.id;


SELECT 
	Aluno.nome as "Nome do Aluno", 
	Curso.nome as "Nome do Curso"
FROM Aluno 
LEFT JOIN Aluno_Curso ON Aluno_Curso.Aluno_Id = Aluno.id
LEFT JOIN Curso ON Aluno_Curso.Curso_Id = Curso.id;


SELECT 
	Aluno.id as "ID do Aluno",
	Aluno.nome as "Nome do Aluno", 
	Curso.id as "ID do Curso",
	Curso.nome as "Nome do Curso"
FROM Aluno 
FULL JOIN Aluno_Curso ON Aluno_Curso.Aluno_Id = Aluno.id
FULL JOIN Curso ON Aluno_Curso.Curso_Id = Curso.id
ORDER BY Aluno.id;


SELECT 
	Aluno.nome as "Nome do Aluno", 
	Curso.nome as "Nome do Curso"
FROM Aluno 
CROSS JOIN Curso 

/* DELETE CASCADE */
SELECT * FROM Aluno;
SELECT * FROM Curso;
SELECT * FROM Aluno_Curso;

DROP TABLE Aluno;
DROP TABLE Curso;
DROP TABLE Aluno_Curso;

CREATE TABLE Aluno_Curso (
 Aluno_Id INTEGER,
 Curso_Id INTEGER,

 FOREIGN KEY (Aluno_Id) REFERENCES Aluno (id)
 ON DELETE CASCADE
 ON UPDATE CASCADE,
 FOREIGN KEY (Curso_Id) REFERENCES Curso (id)
);

DELETE FROM Aluno WHERE id = 1;
DELETE FROM Curso WHERE id = 1;
DELETE FROM Aluno_Curso WHERE Aluno_Id = 1;

/* UPDATE CASCADE */
UPDATE Aluno SET id = 5 WHERE id = 3;

/* NOVA TABELA */
/* ORDER BY, LIMIT, OFFSET */
CREATE TABLE Funcionarios (
	id SERIAL PRIMARY KEY,
	Matricula Varchar (10),
	Nome Varchar (255),
	Sobrenome Varchar (255)
);

Insert Into Funcionarios (Matricula, Nome, Sobrenome)Values 
('M001','Diego','Mascarenhas'),
('M002','Vinicius','Dias'),
('M003','Nico','Steppat'),
('M004','João','Roberto'),
('M005','Diego','Mascarenhas'),
('M006','Alberto','Martins'),
('M007','Diogo','Olivera');

SELECT * FROM Funcionarios ORDER BY id;
SELECT * FROM Funcionarios ORDER BY Nome;
SELECT * FROM Funcionarios ORDER BY 4,3,2;
SELECT F.id, F.Matricula, F.Nome, F.Sobrenome FROM Funcionarios F ORDER BY 1;
SELECT * FROM Funcionarios ORDER BY 1 LIMIT 3;
SELECT * FROM Funcionarios ORDER BY 1 LIMIT 5 OFFSET 4;

/*
-- COUNT - Retorna a quantidade de registros
-- SUM -   Retorna a soma dos registros
-- MAX -   Retorna o maior valor dos registros
-- MIN -   Retorna o menor valor dos registros
-- AVG -   Retorna a média dos registros
*/

SELECT COUNT (id) FROM Funcionarios;

SELECT COUNT (id),
       ROUND(SUM(id),2),
       ROUND(MAX(id),2),
       ROUND(MIN(id),2),
       ROUND(AVG(id),2)
  FROM funcionarios;
  
/* GROUP BY */
SELECT
	nome AS "NOME",
	sobrenome AS "SOBRENOME",
	COUNT(*) AS "QTD REGISTROS"
FROM funcionarios
GROUP BY nome, sobrenome
ORDER BY nome;  

SELECT 
	Curso.nome AS "NOME DO CURSO", 
	COUNT(Aluno.id) AS "CONTAGEM DE ALUNOS" 
FROM Aluno 
JOIN  Aluno_Curso ON Aluno.id = Aluno_Curso.aluno_id
JOIN Curso ON Curso.id = Aluno_Curso.curso_id
GROUP BY 1
ORDER BY 1;

/* FILTRAGENS */
SELECT 
	COUNT(Aluno_Curso.aluno_id) AS "QTD DE ALUNOS NOS CURSOS",
	Curso.Nome AS "NOME DO CURSO"
FROM Curso 
LEFT JOIN Aluno_Curso ON Aluno_Curso.curso_id = Curso.id
LEFT JOIN Aluno ON Aluno_Curso.Aluno_id = Aluno.id
	/* WHERE Curso.Nome = 'Python' */
GROUP BY Curso.Nome
	HAVING COUNT (Aluno.id)>=0
ORDER BY Curso.Nome
;
  
SELECT F.Nome AS "NOME", 
	COUNT(id) AS "CONTAGEM DE REGISTROS" 
FROM Funcionarios F
GROUP BY F.Nome
	HAVING COUNT (id) = 1
ORDER BY F.Nome
;