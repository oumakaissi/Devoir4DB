
-----------NOM:DERIFE                    NOM:KAISSI                    GROUPE:G2
-----------Prénom:Rachida                Prénom:oumaima


--Q1
create or replace trigger piloteContol 
    before insert or update or delete
    on pilote for each row
    when (extract(hour from systimestamp)>18 or extract(hour from systimestamp)<8)
    begin
        if inserting then
            raise_application_error(-20501, 'Insertion impossible à cette heure.');
        elsif updating then
            raise_application_error(-20502, 'Mise à jour impossible à cette heure.');
        else
            raise_application_error(-20503, 'Suppression impossible à cette heure.');
        end if;
    end;
/

--Q2
create table Audit_Pilote_Table
(
username varchar2(15),
sysdate timestamp,
id number(4),
old_last_name varchar2(15),
new_last_name varchar2(15),
old_comm number(4),
new_comm number(4),
old_salary number(4),
new_salary number(4)
);

create or replace trigger tr2
after update of nom,comm,sal on pilote
for each row
begin
insert into Audit_Pilote_Table values(user,sysdate,:old.nopilot,:old.sal,:old.comm,:old.embauche,:old.ville);
end;
/
--Q3
create or replace trigger calcul after insert or update on pilote
for each row
begin
  if inserting or updating then
    update pilote
	set comm = :new.comm+ :new.sal*0.1;
   end if;
end;
/

--Q4
create or replace trigger controleOp
before update of sal on pilote
for each row 
begin 
if (:new.sal>:old.sal*0.1)or(:new.sal<:old.sal-0.1*:old.sal)
then 
 raise_application-error(-20503,'le salaire ne peut pas etre ni reduit ni augmenté de plus de 10% ');
 end if ;
 end;
 /   
 
--Q5
create trigger ajout_pilot
 before insert on pilote
 for each row
 declare
        v_user varchar2(15);
  begin
        select user into v_user from dual;
        if v_user != 'SYSTEM' then
            raise_application_error(-20501, 'Utilisateur non autorisé');
        end if;
    end;
/

--Q6
create or replace trigger verif_nbhvol after insert or update on avion
declare
nbvol avion.nbhvol%type;
begin
select avg(nbhvol) into nbvol from avion;
  if nbvol> 20000 then
    raise_application-error(-20000,'le nombre moyen de vol est tropélevé');
  end if;
end;
/  
--Q7
create table log_trip_table(

user_id varchar2(12),

log_date date,

action varchar2(12)

);


CREATE OR REPLACE TRIGGER LOGON_TRIG

AFTER logon ON SCHEMA

BEGIN

INSERT INTO log_trig_table (user_id, log_date, action)

VALUES (user, sysdate, ’Logging on’);

END;

CREATE OR REPLACE TRIGGER LOGOFF_TRIG

BEFORE logoff ON SCHEMA

BEGIN

INSERT INTO log_trig_table (user_id, log_date, action)

VALUES (user, sysdate, ’Logging off’);

end;
/

--Q8
alter trigger verif_nhvol disable ;
ALTER TABLE pilote DISABLE ALL TRIGGERS;



