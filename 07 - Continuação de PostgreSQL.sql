do $$
	declare
		cursor_instrutor refcursor;
		salario decimal;
		total_instrutor integer default 0;
		instrutores_recebem_menos integer default 0;
		percentual decimal(5,2);
	begin
		select instrutor_interno(10) into cursor_instrutor;
			loop
				fetch cursor_instrutor into salario; 
				exit when not found;
				total_instrutor := total_instrutor+1;
					
				raise notice'Salário inserido: % enquanto o salário existente é: %', new.salario, salario;		
				if 600::Decimal > salario then
					instrutores_recebem_menos := instrutores_recebem_menos+1;
					return;
				end if;
			end loop;
				
		percentual = instrutores_recebem_menos::decimal / total_instrutor::decimal * 100;
		raise notice 'Percentual: % %%', percentual;
	end;
$$;	
	
