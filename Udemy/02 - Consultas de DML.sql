/* FATAL ERROR: C:\Users\User\AppData\Roaming\pgadmin */
/* ARQ DE CONF: C:\Program Files\PostgreSQL\15\data ...  #datestyle = 'iso, dmy' -> datestyle = 'iso, mdy' */

/*FUNÇOES DE AGREGACAO*/
/*QUERY SIMPLES*/

show datestyle;

select * from funcionarios;
select * from departamentos;

/* Contando o numero de ocorrencias */
select count(*) from funcionarios;
select count(*) from departamentos;
select count(*) from localizacao;

/* Agrupando por sexo com group by */
select count(*) from funcionarios
group by sexo;

/* colocando o nome da coluna */
select sexo, count(*) as "Quantidade" from funcionarios
group by sexo;


/* mostrando o numero de funcionarios em cada departamento */
select departamento, count(*)
from funcionarios
group by departamento;


/* Exibindo o Maximo de salario */
select max(salario) as "SALARIO MAXIMO" from funcionarios;

/* Exibindo o Minimo de salarios */
select min(salario) as "SALARIO MENOR" from funcionarios;

/* Exibindo o Máximo e o Mínimo Juntos */
select min(salario) as "SALARIO MINIMO", max(salario) as "SALARIO MAXIMO"
from funcionarios;

/* Exibindo o Máximo e o Mínimo de cada Departamento */
select departamento, min(salario), max(salario)
from funcionarios
group by departamento;

/* Exibindo o Máximo e o Mínimo por Sexo */
select sexo, min(salario), max(salario)
from funcionarios
group by sexo;

/*Estatisticas*/
/* Mostrando uma Quantidade Limitada de Linhas */
select * from funcionarios
limit 10;


/* Qual o Gasto Total de Salario pago pela empresa? */
select sum(salario) from funcionarios;


/* Qual o Montante Total que cada departamento recebe de salario */
select departamento, sum(salario)
from funcionarios
group by departamento;


/* Por departamento, qual o total e a média paga para os funcionarios? */
select sum(salario), avg(salario)
from funcionarios;

select funcionarios.departamento, sum(salario), avg(salario)
from funcionarios
group by departamento;

/* 1º Ordenando*/
select departamento, sum(salario), avg(salario)
from funcionarios
group by departamento
order by 3;

select departamento, sum(salario), avg(salario)
from funcionarios
group by departamento
order by 3 ASC;

/* 2º Oredenando */
select departamento, sum(salario), avg(salario)
from funcionarios
group by departamento
order by 3 DESC;

/* UTILIZANDO CASE 1º*/
SELECT NOME, SEXO FROM FUNCIONARIO;
SELECT CARGO FROM FUNCIONARIOS;

SELECT NOME, CARGO,
CASE
	WHEN CARGO = 'Structural Engineer' THEN 'CONDICAO 01'
	WHEN CARGO = 'Financial Advisor' THEN 'CONDICAO 02'
	WHEN CARGO = 'Recruiting Manager' THEN 'CONDICAO 03'
	WHEN CARGO = 'Desktop Support Technician' THEN 'CONDICAO 04'
	WHEN CARGO = 'Software Engineer III' THEN 'CONDICAO 05'
	WHEN CARGO = 'Executive Secretary' THEN 'CONDICAO 06'
	WHEN CARGO = 'Dental Hygienist' THEN 'CONDICAO 07'
	ELSE 'OUTRAS CONDICOES'
END AS "CONDICOES"
FROM FUNCIONARIOS;

/* CASE 2º */
SELECT NOME, SEXO FROM FUNCIONARIOS;

SELECT NOME,
CASE
	WHEN SEXO = 'Masculino' THEN 'M'
	ELSE 'F'

END AS "SEXO"
FROM FUNCIONARIOS;

/* BOOLEAN DUMMY */
SELECT NOME, CARGO, (SEXO = 'Masculino') AS MASCULINO, (SEXO = 'Feminino') AS FEMININO 
FROM FUNCIONARIOS;

/* MESCLANDO TÉCNICA */
SELECT NOME, CARGO,
CASE
	WHEN (SEXO = 'Masculino') = true THEN 1
	ELSE 0
END AS "MASCULINO",
CASE
	WHEN (SEXO = 'Feminino') = TRUE THEN 1
	ELSE 0
END AS "FEMININO"
FROM FUNCIONARIOS;

/* FILTROS */
SELECT DEPARTAMENTO, SUM(SALARIO) AS "TOTAL"
FROM FUNCIONARIOS
WHERE
DEPARTAMENTO LIKE 'B%'
GROUP BY DEPARTAMENTO
HAVING SUM(SALARIO) > 40000;

/* MULTIPLOS CONTADORES */
SELECT COUNT(*) FROM FUNCIONARIOS;

SELECT COUNT(*) AS QTD_TOTAL_FUNCIONARIOS, 
(SELECT COUNT(*)
 FROM FUNCIONARIOS
 WHERE SEXO = 'Masculino'
 GROUP BY SEXO) as QTD_SEXO_M
 FROM FUNCIONARIOS;
 
 /* 2º MANEIRA */
 SELECT COUNT(*) AS QTD_TOTAL_FUNCIONARIOS,
 COUNT(*) FILTER (WHERE SEXO = 'Masculino') AS QTD_SEXO_M,
 COUNT(*) FILTER (WHERE SEXO = 'Feminino') AS QTD_SEXO_F
 COUNT(*) FILTER (WHERE SALARIO > 140000) AS SALARIO > 140K
 FROM FUNCIONARIOS;
 
 /* SELECT DISTINCT */
SELECT DISTINCT DEPARTAMENTO FROM FUNCIONARIOS;
SELECT DISTINCT UPPER (DEPARTAMENTO) FROM FUNCIONARIOS;
SELECT DISTINCT LOWER (DEPARTAMENTO) FROM FUNCIONARIOS;

/* CONCATENANDO UMA STRING */
SELECT CARGO || ' - ' || DEPARTAMENTO FROM FUNCIONARIOS;
SELECT UPPER(CARGO || ' - ' || DEPARTAMENTO) FROM FUNCIONARIOS;
SELECT LOWER(CARGO || ' - ' || DEPARTAMENTO) FROM FUNCIONARIOS;

/* TRIM - REMOVER ESPAÇOS */ /* LENGTH - LER ESPAÇOS */
SELECT ' UNIDADOS ';
SELECT TRIM (' UNIDADOS ');
SELECT LENGTH (' UNIDADOS ');
SELECT LENGTH (TRIM (' UNIDADOS '));

/* DESAFIO - CRIAR COLUNA AO LADO DA COLUNA CARGO 
QUE DIGA SE A PESSOA É ASSISTENTE OU NÃO */
SELECT NOME, (CARGO LIKE '%Assistant%') AS Assistente
FROM FUNCIONARIOS;

SELECT NOME, 
CASE 
	WHEN(CARGO LIKE '%Assistant%') = TRUE THEN 1
	ELSE 0
END AS "Assistente"
FROM FUNCIONARIOS;