/* PROGRAMAÇÃO EM SQL -> PL/pgSQL */
DROP FUNCTION primeira_funcao;
CREATE FUNCTION primeira_funcao(numero_1 int, numero_2 int) RETURNS INTEGER 
AS'
	SELECT numero_1 + numero_2;
' LANGUAGE SQL; 

SELECT primeira_funcao(5,3) AS "RESPOSTA";

/**********************************/
create table TB_insertName (
	nome varchar (255) not null
);

create or replace function fc_newName (nome varchar) returns varchar 
as '
	insert into TB_insertName (nome) values (fc_newName.nome);
	select nome as "Nome";
'language sql;

select fc_newName('Carlos');

/****************************/
create table Instrutor (
	id serial primary key,
	nome varchar(255) not null,
	salario decimal (10,2) not null
);

Insert into Instrutor (nome, salario) Values 
('Carlos',2000.00),
('Miguel',3700.00),
('João',4000.00);

select * from instrutor;

/**************************/
create or replace  function fc_aumentoSalario(Instrutor) returns decimal as
$$
	Select $1.salario * 0.5 + $1.salario;
$$ language sql;

select nome as "Nome", 
	salario as "Salário Antigo", 
	fc_aumentoSalario(Instrutor.*) as "Salário Novo", 
	fc_aumentoSalario(Instrutor.*)-salario as "Diferença" 
from Instrutor; 

/* Retorno Composto -> Tabela Registro*/
create function cria_instrutorFalso() returns instrutor as 
$$
	Select 22 as ID, 'Nome Falso' as Nome, 200 as Salario;
$$ language sql;

select * from cria_instrutorFalso();
select id, nome, salario, from cria_instrutorFalso();

/* 		Parametros de Saída      */
/**********************************
			1º Maneira
***********************************/
create function instrutores_bemPagos(valor_salario Decimal, out nome varchar, out salario decimal) returns /*setof*/ Instrutor as 
$$
	Select nome, salario from Instrutor where salario > (valor_salario);
$$ language sql;

select * from instrutores_bemPagos(1800);
select * from instrutor;

/*----------------------------------
			2º Maneira
------------------------------------*/
create type dois_numeros as (mult integer, soma integer);

create function mult_soma (in n1 integer, in n2 integer/*, out soma integer, out mult integer*/) returns dois_numeros as 
$$
	select n1 * n2 as "mult", n1 + n2 as "soma"; 
$$ language sql;

select mult_soma (4,7) as "Respostas";

/*-------------------------------------
				PLpgSQL
---------------------------------------*/
create function instrutores_bemPagos(valor_salario Decimal, out nome varchar, out salario decimal) returns setof record as 
$$
	Select nome, salario from Instrutor where salario > (valor_salario);
$$ language sql;

/* Diferenças */
create function instrutores_bemPagos(valor_salario Decimal) returns setof  Instrutor as 
$$
begin
	Return Query Select * from Instrutor where salario > (valor_salario);
end;
$$ language plpgsql;

select * from instrutores_bemPagos(1800.00);

/*    1ºManeira    */
create function salario_ok(instrutor instrutor) returns varchar as 
$$
begin
	-- salario > que 1700 OK  < 1700 NOT OK
	if instrutor.salario > 1700 then
		return 'Salario OK';	
	else
		return 'Pode aumentar';
	end if;
end;
$$ language plpgsql;

select id, nome, salario_ok(instrutor.*) from instrutor;

/*    2ºManeira   */
create function salario_ok(id_instrutor integer) returns varchar as 
$$
	declare instrutor instrutor;
begin
	select * from instrutor where id = id_instrutor into instrutor;
	
	-- salario > que 1700 OK  < 1700 NOT OK
	if instrutor.salario > 1900 then
		return 'Salário OK';	
	elseif instrutor.salario = 1900 then
		return 'Salário pode aumentar';
	else
		return 'Salário está defasado';
	end if;
end;
$$ language plpgsql;

select nome, salario_ok(instrutor.id) from instrutor;

/*   Case When    */
select * from instrutor;
drop function salario_ok;

create or replace function salario_ok(id_instrutor integer) returns varchar as 
$$
	declare instrutor instrutor;
begin
	select * from instrutor where id = id_instrutor into instrutor;
		
	case 
		when instrutor.salario > 2450 then
			-- print 'Salário OK!';
			return 'Salário OK!';
		when instrutor.salario = 1550 then
			return 'Salário Defasado';
		else
			return 'Salário Ótimo';
	end case;
end;
$$ language plpgsql;

select nome, salario_ok(instrutor.id) from instrutor;

/*  Loops & While  & For  */
create or replace function taboada (numero integer) returns setof varchar as $$
	declare mult integer default 1;
begin
	loop
		-- return next numero || ' x ' || mult || ' = ' || numero*mult;
		return next numero * mult;
		mult := mult+1;
		exit when mult >= 11;
	end loop;
end;
$$ language plpgsql;

select taboada (5) as "RESULTADO";


create or replace function taboada (numero integer) returns setof varchar as $$
	declare mult integer default 1;
begin
	while mult < 10 loop
		-- return next numero || ' x ' || mult || ' = ' || numero*mult;
		return next numero * mult;
		mult := mult+1;
	end loop;
end;
$$ language plpgsql;

select taboada (5) as "RESULTADO";


create or replace function taboada (numero integer) returns setof varchar as $$
	declare mult integer default 1;
begin
	for mult in 1..10 loop
		-- return next numero || ' x ' || mult || ' = ' || numero*mult;
		return next numero * mult;
	end loop;
end;
$$ language plpgsql;

/* Exemplo */
create or replace function instrutor_com_salario (out nome varchar, out salario_ok varchar) returns setof record as $$
	declare instrutor instrutor;
begin
	for instrutor in select * from instrutor loop
		nome:= instrutor.nome;
		salario_ok = salario_ok(instrutor.id);
		return next;
	end loop;
end;
$$ language plpgsql;

select * from instrutor_com_salario();

/* Exemplo 2º */
select * from categoria
select * from curso

select id from categoria where nome = nome_categoria;
drop function cria_curso;

create or replace function cria_curso(nome_curso varchar, nome_categoria varchar) returns void as $$
	declare id_categoria integer;
begin
	select id into id_categoria from categoria where nome = nome_categoria;
	
	if not found then 
		insert into categoria (nome) values (nome_categoria) returning id into id_categoria;
	end if;
	
	insert into curso (nome, categoria_id) values (nome_curso, id_categoria);
end;
$$ language plpgsql;

select cria_curso('BD','Data Science');

/* Procedure or Function para inserir instrutores + salário
 verificação de salario maior que a média */

create table Instrutor (
	id serial primary key,
	nome varchar(255) not null,
	salario decimal (10,2) not null
);
create table log_instrutores(
	id serial primary key,
	info varchar (255) not null,
	momento_criacao TIMESTAMP default CURRENT_TIMESTAMP
);
 
 create or replace function cria_instrutor (nome_instrutor varchar, salario_instrutor decimal) 
 returns void as $$
	declare 
	id_instrutor_inserido integer;
	media_salarial decimal (10,2);
	total_instrutor integer default 0;
	instrutores_recebem_menos integer default 0;
	salario decimal(10,2);
	percentual decimal(5,2);
 begin
	Insert into instrutor (nome, salario) values (nome_instrutor, salario_instrutor) returning id into id_instrutor_inserido;
	
	select avg (instrutor.salario) into media_salarial from instrutor where id <> id_instrutor_inserido;
	
	if salario_instrutor > media_salarial then
		insert into log_instrutores (info) values (nome_instrutor || ' Recebe salário ácima da média');
	else 
		insert into log_instrutores (info) values (nome_instrutor || ' Recebe salário ábaixo da média');
	end if;
	
	for salario in select instrutor.salario from instrutor where id <> id_instrutor_inserido loop
		total_instrutor := total_instrutor+1;
												   
		if salario_instrutor > salario then
			instrutores_recebem_menos := instrutores_recebem_menos+1;
		end if;
	end loop;
												   
	percentual = instrutores_recebem_menos :: decimal/total_instrutor :: decimal*100;
	insert into log_instrutores (info) values (nome_instrutor || percentual ||' Recebe mais do que X% da grade de instrutores');
												   
 end;
 $$ language plpgsql;

select * from instrutor;
select * from log_instrutores;
select cria_instrutor ('Outro instrutor', 1360);

/* Trigger e Procedure */
drop trigger trigger_instrutor on instrutor;

create trigger trigger_instrutor
	after insert on log_instrutores 
	for each row
	execute procedure proc_instrutor();
	
-- drop function cria_instrutor ();
 create or replace function proc_instrutor()
 returns trigger as $$
	declare 
	media_salarial decimal (10,2);
	total_instrutor integer default 0;
	instrutores_recebem_menos integer default 0;
	percentual decimal(5,2);
 begin
	-- new.nome & new.salario
	select avg (instrutor.salario) into media_salarial from instrutor where id <> new.id;
	
	if new.salario > media_salarial then
		insert into log_instrutores (info) values (new.nome || ' Recebe salário ácima da média');
		return null;
	else 
		insert into log_instrutores (info) values (new.nome || ' Recebe salário ábaixo da média');
		return null;
	end if;
	
	for salario in select instrutor.salario from instrutor where id <> new.id loop
		total_instrutor := total_instrutor+1;
												   
		if new.salario > salario then
			instrutores_recebem_menos := instrutores_recebem_menos+1;
		end if;
	end loop;
												   
	percentual = instrutores_recebem_menos::decimal / total_instrutor::decimal * 100;
	
	insert into log_instrutores (info) 
	values (new.nome || percentual ||' Recebe mais do que X% da grade de instrutores');
	return new;											   
 end;
 $$ language plpgsql;
	
Insert into instrutor (nome, salario) 
values ('Teste', 1245.00) 