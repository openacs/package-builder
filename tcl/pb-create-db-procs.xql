<?xml version="1.0"?>
<queryset>

<fullquery name="pb::create::db::create.types">
<querytext>

	select type_id, tablename, id_column
	from pb_types
	where pkg_id = :pkg_id
	order by sort_order

</querytext>
</fullquery>

<fullquery name="pb::create::db::create.attributes">
<querytext>

	    select name, column_spec
	    from pb_attributes
	    where type_id = :type_id
	    order by attribute_id

</querytext>
</fullquery>

<fullquery name="pb::create::db::drop.tables">
<querytext>

        select tablename
	from pb_types
	where pkg_id = :pkg_id
	order by sort_order desc

</querytext>
</fullquery>

</queryset>
