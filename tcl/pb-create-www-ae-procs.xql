<?xml version="1.0"?>
<queryset>

<fullquery name="pb::create::www::ae::tcl.attributes">
<querytext>

	select name, pretty_name, datatype, required_p, widget, options
	from pb_attributes
	where type_id = :type_id
	order by attribute_id

</querytext>
</fullquery>

<fullquery name="pb::create::www::ae::xql.attributes">
<querytext>

	select name
	from pb_attributes
	where type_id = :type_id
	order by attribute_id

</querytext>
</fullquery>

</queryset>
