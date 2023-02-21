SELECT NOW();
SHOW DATESTYLE;

DROP TABLE Aluno;
CREATE TABLE aluno (
    id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL,
	ultimo_nome VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL
);

DROP TABLE Categoria;
CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL UNIQUE
);

DROP TABLE Curso;
CREATE TABLE curso (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES categoria(id)
);

DROP TABLE Aluno_Curso;
CREATE TABLE aluno_curso (
	aluno_id INTEGER NOT NULL REFERENCES aluno(id)  
	/* ON DELETE CASCADE
	ON UPDATE CASCADE */,
	curso_id INTEGER NOT NULL REFERENCES curso(id),
	PRIMARY KEY (aluno_id, curso_id)
);

/* INSERÇÃO */
INSERT INTO Aluno (primeiro_nome, ultimo_nome, 	data_nascimento) VALUES
('Celso','Roth','07-29-2003'),
('Shitom','Miyu','09-25-2001'),
('Santiago','Nuens','12-07-2008');
SELECT * FROM Aluno;

INSERT INTO Categoria (Nome) VALUES
('Back End'),
('Front End'),
('Dev Android');
SELECT * FROM Categoria;

INSERT INTO Curso(Nome, Categoria_id) VALUES 
('React Node',3),
('HTML & CSS',2),
('Python',1),
('Java Oracle',1),
('Javascript',2),
('PostgreSQL & SQL Sever',3);
SELECT * FROM Curso;

INSERT INTO Aluno_Curso (aluno_id, curso_id) VALUES 
(2,1),
(3,4),
(1,5),
(2,2),
(3,6),
(1,3),
(2,6),
(3,5),
(1,4),
(1,2),
(1,6);
SELECT * FROM Aluno_Curso;

/* UPDATE & DELETE */
UPDATE Categoria SET Nome = 'Ciência de Dados' WHERE id = 4;
UPDATE Categoria SET Nome = 'Dev Android' WHERE id = 4;
SELECT * FROM Categoria;

/* ALUNOS COM MAIS CURSOS */
SELECT 
	Aluno.primeiro_nome AS "NOME DO ALUNO",
	Aluno.ultimo_nome AS "SOBRENOME DO ALUNO",
	COUNT(Aluno_Curso.Curso_id) AS "QTD DE CURSOS"
FROM Aluno 
FULL JOIN Aluno_Curso ON Aluno_Curso.Aluno_id = Aluno.id
GROUP BY 1,2
ORDER BY 3 DESC
;

/* CURSO MAIS REQUISITADO */
SELECT 
	Curso.id AS "ID DO CURSO",
	Curso.nome AS "NOME DO CURSO",
	ROUND(COUNT(Aluno_Curso.Curso_id),1) AS "CURSOS MAIS REQUISITADOS"
FROM Curso 
FULL JOIN Aluno_Curso ON Aluno_Curso.Curso_id = Curso.id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1
;

/* MÉDIA */
SELECT AVG(Aluno_Curso.Aluno_id/Aluno_Curso.Curso_id) AS "MÉDIA DE ALUNOS POR CURSO" 
FROM Aluno_Curso;

/* CURSOS MAIS REQUISITADO ACIMA DA MÉDIA */
SELECT 
	Curso.id AS "ID DO CURSO",
	Curso.nome AS "NOME DO CURSO",
	ROUND(COUNT(Aluno_Curso.Curso_id),4) AS "CURSOS MAIS REQUISITADOS",
	COUNT(Aluno_Curso.Curso_id) > AVG(Aluno_Curso.Aluno_id/Aluno_Curso.Curso_id) AS "CURSOS ÁCIMA DA MÉDIA"
FROM Curso 
FULL JOIN Aluno_Curso ON Aluno_Curso.Curso_id = Curso.id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 3
;

/* TECLA IN, SUB QUERY */
SELECT * FROM Curso;
SELECT * FROM Categoria;
SELECT * FROM Curso WHERE Categoria_id IN (1,2) ORDER BY Categoria_id /* categoria_id = 1 ou 2 */
SELECT id FROM Categoria WHERE Nome NOT LIKE '% %';

SELECT Curso.nome FROM Curso WHERE Categoria_id IN (
	SELECT id FROM Categoria WHERE Categoria.Nome NOT LIKE '%Back%'
);

/* SUB QUERY */
SELECT Categoria AS categoria,
	COUNT(Curso.id) AS numero_cursos
FROM Categoria
FULL JOIN Curso ON Curso.Categoria_id = categoria.id
GROUP BY Categoria

SELECT Categoria 
FROM (
	SELECT Categoria.Nome AS categoria,
		COUNT(Curso.id) AS numero_cursos
	FROM Categoria
	FULL JOIN Curso ON Curso.Categoria_id = categoria.id
	GROUP BY Categoria
		/* HAVING COUNT (Curso.id)>= 2 */
	) AS numero_cursos
WHERE numero_cursos >= 2;

/* EXEMPLO DE SUBQUERY */
SELECT curso.nome,
     COUNT(aluno_curso.aluno_id) numero_alunos
FROM curso
JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1
     HAVING COUNT(aluno_curso.aluno_id) > 2
ORDER BY numero_alunos DESC;
;


SELECT t.curso,
       t.numero_alunos
FROM(
    SELECT curso.nome AS curso,
		COUNT(aluno_curso.aluno_id) numero_alunos
	FROM curso
	JOIN aluno_curso ON aluno_curso.curso_id = curso.id
    GROUP BY 1
    ) AS t
WHERE t.numero_alunos > 2
ORDER BY t.numero_alunos DESC;

/* FUNÇÕES DE STRING */
SELECT (A.primeiro_nome || ' ' || A.ultimo_nome) AS Nome_Completo FROM Aluno A;
SELECT CONCAT(A.primeiro_nome ,' ',A.ultimo_nome)AS Nome_Completo FROM Aluno A;
SELECT CONCAT('Matheus',' ','Lopes') AS Teste;
SELECT UPPER(CONCAT('Matheus',' ','Lopes'));
SELECT TRIM (CONCAT('Matheus',' ','Lopes')) AS Teste;

/* FUNÇÕES DE  DATA*/
SELECT ((NOW()::DATE - A.data_nascimento)/365) AS Idade FROM Aluno A;
SELECT AGE(A.data_nascimento) AS Idade FROM Aluno A;

/* STRING + DATA */
SELECT CONCAT(A.primeiro_nome,' ',A.ultimo_nome) AS Nome_Completo, 
	AGE(A.data_nascimento) AS Idade
FROM Aluno A;

SELECT CONCAT(A.primeiro_nome,' ',A.ultimo_nome) AS Nome_Completo, 
	EXTRACT (YEAR FROM AGE(A.data_nascimento)) AS Idade
FROM Aluno A;

SELECT CONCAT(A.primeiro_nome,' ',A.ultimo_nome) AS Nome_Completo, 
	EXTRACT (YEAR FROM(A.data_nascimento)) AS Idade
FROM Aluno A;

/* FUNÇÃO DE CONVERÇÃO */
SELECT TO_CHAR(NOW(),'DD/MM/YYYY');

/* CRIAÇÃO DE VIEWS

CREATE [ OR REPLACE ] [ TEMP | TEMPORARY ] VIEW name [ ( column_name [, ...] ) ]
    [ WITH ( view_option_name [= view_option_value] [, ... ] ) ]
    AS query 
*/

SELECT Categoria 
FROM (
	SELECT Categoria.Nome AS categoria,
		COUNT(Curso.id) AS numero_cursos
	FROM Categoria
	FULL JOIN Curso ON Curso.Categoria_id = categoria.id
	GROUP BY Categoria
		HAVING COUNT (Curso.id)>= 2 
	) AS numero_cursos
WHERE numero_cursos >= 2;

CREATE VIEW VW_Cursos_Categorias AS SELECT Categoria.Nome AS categoria,
		COUNT(Curso.id) AS numero_cursos
	FROM Categoria
	FULL JOIN Curso ON Curso.Categoria_id = categoria.id
	GROUP BY Categoria;
	
SELECT * 
FROM VW_Cursos_Categorias AS Categoria_cursos
WHERE numero_cursos > 2;

/* CREATE VIEW */
CREATE VIEW VW_Cursos_Prog AS SELECT C.Nome 
FROM Curso C WHERE C.Categoria_id = 1;

SELECT * FROM VW_Cursos_Prog;

SELECT categoria.id AS categoria_id, 
	VW_Cursos_Categorias.*
FROM VW_Cursos_Categorias
JOIN Categoria ON Categoria.Nome = VW_Cursos_Categorias.categoria;
