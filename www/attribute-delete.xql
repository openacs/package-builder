<?xml version="1.0"?>
<queryset>

<fullquery name="type_and_package_data">
      <querytext>

    select p.pretty_name as package_name, t.pretty_name as type_name
    from pb_packages p, pb_types t
    where p.pkg_id = :pkg_id
    and t.type_id = :type_id

      </querytext>
</fullquery>

<fullquery name="attribute_name">
      <querytext>

    select pretty_name
    from pb_attributes
    where attribute_id = :attribute_id

      </querytext>
</fullquery>

<fullquery name="delete_attribute">
      <querytext>

    delete from pb_attributes
    where attribute_id = :attribute_id

      </querytext>
</fullquery>

</queryset>
