<?xml version="1.0"?>
<queryset>

<fullquery name="pb::create::catalog::create.types">
<querytext>

	select type_id, name, pretty_name, pretty_plural, name_pretty,
	       title_pretty, descr_pretty
	from pb_types
	where pkg_id = :pkg_id
	order by sort_order

</querytext>
</fullquery>

<fullquery name="pb::create::catalog::create.attributes">
<querytext>

	select name, pretty_name, datatype, widget, options
	from pb_attributes
	where type_id = :type_id
	order by attribute_id

</querytext>
</fullquery>

</queryset>
