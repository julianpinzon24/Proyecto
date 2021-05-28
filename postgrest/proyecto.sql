create table admin (
id integer not null,
name1 varchar (50) not null,
primary key (name1)
);

/*
en este espacio se registra el admin o hace el inicio correspondiente
*/
select id,name1
from user_admin
inner join admin on name1 = name_rol
;

create table sistem_user (
id int4 not null,
login varchar(50) not null unique,
password varchar(50) not null unique,
email varchar(50) not null unique,
activated int4 not null,
lang_key varchar(5) not null,
image_url varchar(250) not null,
activation_key varchar(20) not null,
reset_key varchar(20) not null,
reset_date timestamp not null,
primary key (id)
);

/*
el cliente se le solicita ingresar algunos datos para la creacion de la cuenta
*/
select login, password, email, activated, lang_key, image_url, activation_key, reset_key, reset_date
from user_admin
inner join sistem_user on id = id_sistem_user ;



create table poder_admin (
id int4 not null,
configuracion varchar (400) not null,
coreccion varchar (400) not null,
primary key (id)
);

/*
el administrador podra controlar disntintas funciones del aplicativo
*/
select configuracion,coreccion
from user_admin
inner join poder_admin on id_poder_admin = id 
;

create table user_admin (
name_rol varchar (50) not null,
id_sistem_user int4 not null,
id_poder_admin int4 not null,
primary key (name_rol,id_sistem_user,id_poder_admin),
constraint fk_admi foreign key (name_rol) references admin (name1),
constraint fk_syst_user foreign key (id_sistem_user) references sistem_user (id),
constraint fk_pode_admi foreign key (id_poder_admin) references poder_admin (id)
);

/*
el administrador debera emplear el uso de cuenta para poder realizar las funciones correspondientes
*/
select name_rol,id_sistem_user,id_poder_admin
from sistem_user
inner join user_admin on name_rol = login
;

create table tipo_documento (
id int4 not null,
sigla int4 not null unique,
nombre_documento varchar(100) not null unique,
estado varchar(40) not null unique,
primary key (id)
);

/*
se le pide al usuario el ingresar distintos datos respecto a su documento
*/
select sigla, nombre_documento, estado 
from cliente
inner join tipo_documento on id_tipo_documento = sigla 
;

create table cliente (
id int4 not null,
id_tipo_documento int4 not null unique,
numero_documento integer not null unique,
primer_nombre varchar(50) not null unique,
segundo_nombre varchar(50) not null unique,
primer_apellido varchar(50) not null unique,
segundo_apellido varchar(50) not null unique,
id_sistem_user int4 not null,
primary key (id),
constraint fk_user_clien foreign key (id_tipo_documento) references sistem_user (id),
constraint fk_tipo_clie foreign key (id_sistem_user) references tipo_documento (id)
);

/*
se le solicita al cliente que ingrese detalladamente algunos datos importantes
*/
select id_tipo_documento, numero_documento, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, id_sistem_user
from tipo_documento
inner join cliente on id_tipo_documento = sigla ;


create table log_errores_cliente(
id integer not null,
nivel varchar(400) not null,
log_name varchar(400) not null unique,
mensaje varchar (400) not null unique,
fecha date not null,
id_cliente integer not null,
primary key (id),
constraint fk_clie_log_erro foreign key (id_cliente) references cliente (id)
);

/*
en caso de existir algun error en el registro del cliente, se le mostraran algunos datos 
*/
select nivel,log_name, mensaje, fecha, id_cliente
from cliente
inner join log_errores_cliente on id_cliente = numero_documento
;

create table calificaciones(
id integer not null,
calificacion_usuario integer not null unique,
proteccion_admin varchar(40) not null,
vista_previa varchar (40) not null,
	primary key (id)
);

/*
al cliente se le solicitara el calificar de manera positiva o negativa algun sitio visto en el aplicativo, asi mismo el admin tendra poder
*/
select calificacion_usuario, proteccion_admin, vista_previa
from lugares
inner join calificaciones on id_calificacion = calificacion_usuario 
;

create table registro_lugares  (
id integer not null,     
registro_usuario varchar(400) not null unique, 
registro_admin   varchar(400) not null unique, 
correciones_admin varchar(400)not null, 
correciones_usuario varchar(400)not null, 
eliminar_informacion varchar(400)not null, 
estado varchar(40)not null, 
primary key (id)
);

/*
el usuario podra ingresar y documentar algun sitio que quiera integrar en el sistema
*/
select registro_usuario, registro_admin, correciones_admin, correciones_usuario, eliminar_informacion, estado
from especificaciones_lugares
inner join registro_lugares on registro_usuario = ubicaion
;

create table especificaciones_lugares(
id integer not null,     
ubicaion  varchar(400)not null unique,
direccion  varchar(400)not null unique,
correo varchar(400)not null unique,
telefono integer not null unique,
nombre varchar(400)not null unique,
fecha time not null unique,
imagen_foto varchar(400)not null,
primary key (id)
);

/*
se le pide al usuario dar ciertos datos del lugar que desea integrar en el aplicativo 
*/
select ubicaion, direccion, correo, telefono, nombre, fecha, imagen_foto
from registro_lugares
inner join especificaciones_lugares on registro_usuario = ubicaion
;

create table lugares(
id integer not null,
id_cliente integer not null,
id_poder_admin integer not null,
id_especificaciones_lugares integer not null,
id_registro_lugares integer not null,
id_calificacion integer not null,
primary key (id),
constraint fk1 foreign key (id_cliente) references cliente (id),
constraint fk2 foreign key (id_poder_admin) references poder_admin(id),
constraint fk3 foreign key (id_especificaciones_lugares) references especificaciones_lugares(id),
constraint fk4 foreign key (id_registro_lugares) references registro_lugares(id),
constraint fk5 foreign key (id_calificacion) references calificaciones (id)
);


