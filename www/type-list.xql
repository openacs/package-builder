<?xml version="1.0"?>
<queryset>

<fullquery name="types">
      <querytext>

    select pkg_id, type_id, pretty_name
    from pb_types
    where pkg_id = :pkg_id
    order by sort_order

      </querytext>
</fullquery>

</queryset>
