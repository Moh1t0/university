do $$  
	declare  
    result_row record;  
    c_table_name varchar;  
begin  
    for result_row in (select distinct product_type, is_company from bid) loop  
        c_table_name := case  
            when result_row.is_company then 'company_' || result_row.product_type  
            else 'person_' || result_row.product_type  
        end;  
        execute 'create table if not exists ' || c_table_name || ' (  
            id serial primary key,  
            client_name varchar(100),  
            amount numeric(12,2)  
        )';  
        execute format(
            'insert into %I (client_name, amount) select client_name,
			amount from bid where product_type = %L and is_company = %L', 
            c_table_name, result_row.product_type, result_row.is_company
        );  
    end loop;  
end $$;

do $$  
declare  
    base_rate numeric(5,3) := 0.1;  
    total_interest numeric(12,2);  
begin  
    execute 'create table if not exists credit_percent (  
        id serial primary key,  
        client_id int,  
        client_name varchar(100),  
        interest_amount numeric(12,2)  
    )';  

    execute 'truncate table credit_percent';  

    execute 'insert into credit_percent (client_id, interest_amount)  
             select id, (amount * ' || base_rate || ') / 365 from company_credit';  

    execute 'insert into credit_percent (client_id, interest_amount)  
             select id, (amount * (' || base_rate || ' + 0.05)) / 365 from person_credit';  

    select sum(interest_amount) into total_interest from credit_percent;  
    raise notice 'общая сумма начисленных процентов: %', total_interest;  
end $$;


create view company_bids as  
select * from bid  
where is_company = true;

select *
from company_bids;





























