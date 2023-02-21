/*****************************************************/
select * from instrutor.TB_instrutor;
select * from instrutor.TB_logInstrutores;
update instrutor.TB_instrutor set id = 10 where id = 14;
update instrutor.TB_logInstrutores set id = 1 where id = 9;
delete from instrutor.TB_instrutor where id = 10;
delete from instrutor.TB_logInstrutores where id = 1;

insert into instrutor.TB_Instrutor (id,nome, salario) values 
--(nextval('instrutor.SQ_instrutor'),'Lucas', 500),
(nextval('instrutor.SQ_instrutor'),'Thiago', 800),
(nextval('instrutor.SQ_instrutor'),'Marcos',900),
(nextval('instrutor.SQ_instrutor'),'Ana',750),
(nextval('instrutor.SQ_instrutor'),'Giovanna',680),
(nextval('instrutor.SQ_instrutor'),'Felipe',799),
(nextval('instrutor.SQ_instrutor'),'Matheus',689),
(nextval('instrutor.SQ_instrutor'),'Maria',760);

/********************************************************/
-- Queremos inserir dados na tabela criada
drop function instrutor.PROC_logInstrutores();

create or replace function instrutor.PROC_logInstrutores()
 returns trigger as $$
	declare 
	media_salarial decimal (10,2);
	total_instrutor integer default 0;
	instrutores_recebem_menos integer default 0;
	percentual decimal(5,2);
	logs_inseridos integer;
 begin
	select avg (salario) into media_salarial from instrutor.TB_instrutor where id <> new.id;
	
	if new.salario > media_salarial then
		insert into instrutor.TB_logInstrutores (info) values (new.nome || ' Recebe salário ácima da média');
		
		get diagnostics logs_inseridos = row_count; 
		if(logs_inseridos > 1) then
			raise exception 'Algo de Errado Aconteceu!';
		end if;
		return null;
	else 
		insert into instrutor.TB_logInstrutores (info) values (new.nome || ' Recebe salário ábaixo da média');
		return null;
	end if;
	
	for new.salario in select TB_instrutor.salario from instrutor where id <> new.id loop
		total_instrutor := total_instrutor+1;
		
	raise notice'Salário inserido: % enquanto o salário existente é: %', new.salario, salario;			
		if new.salario > salario then
			instrutores_recebem_menos := instrutores_recebem_menos+1;
		end if;
	end loop;
												   
	percentual = instrutores_recebem_menos::Decimal / total_instrutor::Decimal * 100;
	assert percentual < 100::Decimal, 'Instrutores novos não podem receber mais que todos os antigos!';
	
	insert into instrutor.TB_logInstrutores (info) 
		values (new.nome || percentual ||' Recebe mais do que X% da grade de instrutores');
	return new;	
	
 end;
 $$ language plpgsql;

/*******************************************************/
drop trigger TRIG_instrutor on instrutor.TB_instrutor;

create trigger TRIG_instrutor
	after insert on instrutor.TB_instrutor
	for each row
	execute procedure instrutor.PROC_logInstrutores();

/********************************************************/
start transaction;	
Insert into instrutor.TB_instrutor (id,nome, salario) 
	values (nextval('instrutor.SQ_instrutor'),'Marcos', 19759); 
commit;