<?xml version="1.0"?>
<queryset>

<fullquery name="pb::create::tcl::install.types">
<querytext>

	select type_id, name, pretty_name, pretty_plural, tablename, id_column
	from pb_types
	where pkg_id = :pkg_id
	order by sort_order

</querytext>
</fullquery>

<fullquery name="pb::create::tcl::install.attributes">
<querytext>

	    select name, pretty_name, datatype, column_spec
	    from pb_attributes
	    where type_id = :type_id
	    order by attribute_id

</querytext>
</fullquery>

<fullquery name="pb::create::tcl::wrapper.attributes">
<querytext>

	    select name as attr_name
	    from pb_attributes
	    where type_id = :type_id
	    order by attribute_id

</querytext>
</fullquery>

</queryset>
