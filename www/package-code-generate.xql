<?xml version="1.0"?>
<queryset>

<fullquery name="types">
      <querytext>

    select type_id
    from pb_types
    order by sort_order

      </querytext>
</fullquery>

<fullquery name="type_data">
      <querytext>

    select type_id, name, pretty_name, pretty_plural, tablename, id_column,
           name_pretty, title_pretty, descr_pretty
    from pb_types
    where type_id = :type_id

      </querytext>
</fullquery>

</queryset>
