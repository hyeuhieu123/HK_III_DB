use ss4;
create table category(
category_id int primary key auto_increment,
category_name varchar(50) not null,
category_description text,
category_status bit  not null
);
create table film(
film_id int primary key auto_increment,
film_name varchar(50) not null,
content text not null,
duration  time not null,
release_date date not null
);
create table category_film(
category_id int not null,
film_id int not null
);
alter table category_film add constraint fk_category foreign key(category_id) references category(category_id);
alter table category_film add constraint fk_film foreign key(film_id) references film(film_id);
alter table film add category_status tinyint default 1;
alter table category drop column category_status;
alter table category_film drop foreign key fk_category;
alter table category_film drop foreign key fk_film;