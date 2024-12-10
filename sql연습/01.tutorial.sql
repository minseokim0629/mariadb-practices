SELECT version(), current_date, current_date(), now() FROM dual;

-- 수학함수, 사칙연산도 된다.
SELECT sin(pi()/4), 1-2*3-4/5 from dual;

-- 대소문자 구분이 없다.
select VERSION(), current_date(), NOW() FROM DUal;

-- table 생성
-- varchar는 가변적이며, char는 고정적
create table pet (
	name    varchar(100),
	owner   varchar(20),
    species varchar(20),
    gender  char(1),
    birth	date,
    death date
);

-- schema 확인
describe pet;
desc pet;

-- table 삭제
drop table pet;

-- insert (C)
insert 
  into pet 
values ('코코', '김민서', 'dog', 'm', '20170705', null);

-- select (R)
select * from pet;

-- update (U)
update pet set name='귀여운 코코' where name='코코';
update pet set death=null where death='0000-00-00';

-- delete (D)
delete from pet where name='귀여운 코코';

-- load data : mysql(CLI) Local 전용 (원격 불가)
-- reject 에러
-- load data local infile 'c:/pet.txt' into table pet;

-- select 연습
select name, species
  from pet
 where name = 'bowser';
 
select name, species, birth
  from pet
 where birth >='1998-01-01';
 
select name, species, gender
  from pet
 where species='dog'
   and gender='f';
    
select name, species
  from pet
 where species='snake'
	or species='bird';

select name, birth, death
  from pet
 where death is not null;

select name
  from pet
 where name like '%fy';
 
select name
  from pet
 where name like '%w%';

-- 이름이 4글자
select name
  from pet
 where name like '____'; 
 
select count(*), max(birth) from pet;

-- null은 세지 않는다
select count(death) from pet;



