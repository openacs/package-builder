<?xml version="1.0"?>
<queryset>

<fullquery name="type_data">
      <querytext>

    select pretty_name as type_name
    from pb_types
    where type_id = :type_id

      </querytext>
</fullquery>

<fullquery name="attributes">
      <querytext>

    select :pkg_id as pkg_id, type_id, attribute_id, pretty_name
    from pb_attributes
    where type_id = :type_id
    order by attribute_id

      </querytext>
</fullquery>

</queryset>
