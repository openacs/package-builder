--
-- Package Builder Package
--
-- @author Timo Hentschel (timo@timohentschel.de)
-- @creation-date 2005-01-07
--


create table pb_packages (
	pkg_id			integer
				constraint pb_packages_pkg_id_pk
				primary key,
	package_id		integer
				constraint pb_packages_package_id_fk
				references apm_packages,
	key			varchar(50),
	short_name		varchar(5),
	pretty_name		varchar(200),
	pretty_plural		varchar(200),
	owner_id		integer
				constraint pb_packages_owner_id_fk
				references users(user_id),
	summary			varchar(1000),
	vendor_name		varchar(200),
	vendor_url		varchar(200),
	description		varchar(1000)
);

create table pb_types (
 	type_id			integer
				constraint pb_types_type_id_pk
				primary key,
	pkg_id			integer
				constraint pb_types_pkg_id_fk
				references pb_packages,
	name			varchar(200),
	pretty_name		varchar(200),
	pretty_plural		varchar(200),
	tablename		varchar(200),
	id_column		varchar(200),
	name_pretty		varchar(200),
	title_pretty		varchar(200),
	descr_pretty		varchar(200),
	sort_order		integer
);

create table pb_attributes (
	attribute_id		integer
				constraint pb_attributes_attribute_id_pk
				primary key,
	type_id			integer
				constraint pb_attributes_type_id_fk
				references pb_types,
	name			varchar(200),
	pretty_name		varchar(200),
	datatype		varchar(20),
	column_spec		varchar(1000),
	required_p		char(1) default 't'
				constraint pb_attributes_required_p_ck
				check (required_p in ('t','f')),
	widget			varchar(20),
	options			varchar(1000)
);
