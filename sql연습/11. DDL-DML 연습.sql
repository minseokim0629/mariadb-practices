--
-- DDL/DML 연습
--
drop table member; 

create table member(
	id int not null auto_increment,
    email varchar(200) not null,
    password varchar(64) not null,
    name varchar(50) not null,
    department varchar(100),
    primary key(id)
    
);

desc member;

alter table member add column juminbunho char(13) not null;
desc member;

alter table member drop juminbunho;
desc member;

-- 컬럼 순서 지정 가능
alter table member add column juminbunho char(13) not null after email;
desc member;

alter table member change column department dept varchar(100) not null;
desc member;

alter table member add column profile text;
desc member;

alter table member drop juminbunho;
desc member;

-- insert
-- id 자동 증가 -> null로 입력
insert
  into member
values (null, 'han8121449@naver.com', password('1234'), '김민서', '개발팀', null);
select * from member;

insert 
  into member (id, email, name, password, dept)
values (null, 'han81214492@naver.com', '김민서2', password('1234'), '개발팀');
select * from member;

-- update
update member
   set email='han81214493@naver.com', password=password('12345')
 where id = 2;
 select * from member;
 
 -- delete
 delete
   from member
  where id = 2;
select * from member;

-- transaction(tx)
select id, email from member;

-- 현재는 1로 세팅되어 있다
select @@autocommit; -- 1 true, 0 false
insert into member values (null, 'alstj@naver.com', 'alstj', password('123'), '개발팀2', null);
select id, email from member;

-- tx:begin
set autocommit = 0; -- false로 세팅
-- 0으로 변경
select @@autocommit; 
insert into member values (null, 'alstj2@naver.com', 'alstj2', password('123'), '개발팀3', null);
select id, email from member;

-- tx : end
commit;
-- rollback;
select id, email from member;
