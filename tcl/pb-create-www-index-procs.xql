<?xml version="1.0"?>
<queryset>

<fullquery name="pb::create::www::index::adp.types">
<querytext>

	select name, pretty_plural
	from pb_types
	where pkg_id = :pkg_id
	order by sort_order

</querytext>
</fullquery>

</queryset>
