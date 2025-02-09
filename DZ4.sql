create table party_guest(
						  id serial primary key,
						  name varchar(100) not null,
						  email varchar(200) not null unique,
						  attended boolean default false
						  );

create user manager with password 'YuriPro2025)'
grant insert, select on table party_guest to manager;
grant usage, select, update on sequence party_guest_id_seq to manager;
grant usage on schema public to manager;

create view party_guest_name as(
							select name
							from party_guest
							);

create user guard with password 'YuriPostavte3/3 :)'
grant select on  party_guest_name to guard;

set role manager;
insert into party_guest (name, email) values 
    ('Charles', 'charles_ny@yahoo.com'),
    ('Charles', 'mix_tape_charles@google.com'),
    ('Teona', 'miss_teona_99@yahoo.com');

set role guard;
select *
from party_guest_name;

select *
from party_guest;

set role postgres;

create or replace procedure party_end()
 language plpgsql
 as $$
		 begin
			create table if not exists black_list(
						id serial primary key,
						email varchar(100) unique
						);
						
			insert into black_list (email)
			select email
			from party_guest
			where attended is false;

			truncate table party_guest;
		 end;
	$$;

create or replace function register_to_party(_name varchar, _email varchar)
	returns boolean 
	language plpgsql
	as $$
	declare
		black_list_exists boolean;
	begin
		select to_regclass('public.black_list') is not null into black_list_exists;
		if black_list_exists then
		if exists (select 1 from black_list where email = _email) then
		return false;
		end if;
	end if;

		insert into party_guest (name, email, attended) values (_name, _email, false);
		return true;
	end;
$$;

select register_to_party('Petr', 'korol_party@yandex.ru');

update party_guest
set attended = true
where email in ('mix_tape_charles@google.com', 'miss_teona_99@yahoo.com')

call party_end();




























