/* 				DBA 
	Creating a Database Cluster: Um Cluster PostgreSQL inicializado pelo comando initdb nada mais é do que o local onde o PostgreSQl vai armazenar os arquivos necessários para representar o esquema e seus dados.
	-- $ initdb -D /urs/local/pgsql/data
	
	Starting the Database Server:
	-- $ postgres -D /urs/local/pgsql/data >logfile 2>&1 &
	
	-- pg_ctl start - l ctrl
	-- su postgre
	-- pg_ctl restart
	-- pg_shutdown ou pg_ctl stop
	-- docker exec -it banco bash
	-- pg_ctl status ..... no server running
	-- pgAdim ou pwd 
	-- pg_ctl start rotatelogs
	-- pg_dumb -f alura
	-- pg_restore -d alura
	
	-- Conheça o Windows ou Linux bem !
	-- auto vacuum : vacuumdb alura 
*/

DROP TABLE instrutor;

CREATE TABLE instrutor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    salario DECIMAL(10, 2)
);

SELECT COUNT(*) FROM instrutor;

DO $$
    DECLARE
    BEGIN
        FOR i IN 1..1000000 LOOP
            INSERT INTO instrutor (nome, salario) VALUES ('Instrutor(a) ' || i, random() * 1000 + 1);
        END LOOP;
    END;
$$;

UPDATE instrutor SET salario = salario * 2 WHERE id % 2 = 1;
DELETE FROM instrutor WHERE id % 2 = 0;

/* Processo de Vacuum de dados (Limpeza de Dados) */
VACUUM ANALYSE instrutor;

/* Update, Delete, Insert ... Tuplas Mortas ou Inuteis */
SELECT relname, n_dead_tup FROM pg_stat_user_tables;

/* Tamanho de Memoria */
SELECT pg_size_pretty(pg_relation_size('instrutor'));

/* Ordenando e Corrigindo dados*/
ANALYZE;
REINDEX TABLE instrutor;

/* Explica o que está acontecendo! + Index de Busca mais Rápida*/
Explain Select * from instrutor where salario > 1500;

Create index idx_salario on instrutor(salario);
Drop index idx_salario;

/* Quando utilizar o index ?

 -- Custo da Query (Performace, Velocidade, Gasto)
 -- Otimizaçãos
 -- Balanceamento de Querys Complexas
*/

/* Arquivo pg_hba - Usuários e Permissões 
	
	É possivel modificar e gerenciar os usuários do servidor utilizado, com
	as alterações devidas no pg_hba, sendo possível adicional user's e seu tipo de
	verificação seja ela password or trust. Desse modo determinando nossos hosts do
	sistema.
*/

/* Criando um usuário novo com o Database Roles */
	Drop role vinicius;
	-- (Create Role name;) 
	Create user vinicius password '12345' nosuperuser createdb;

/* Retirando permissões e Garantindo permissões dos usuários dentro de uma DB */
Revoke all privileges on database Alura from vinicius;
Grant select on public.instrutor to vinicius;