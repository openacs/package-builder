<?xml version="1.0"?>
<queryset>

<fullquery name="package_data">
      <querytext>

    select pretty_name as package_name
    from pb_packages
    where pkg_id = :pkg_id

      </querytext>
</fullquery>

<fullquery name="type_name">
      <querytext>

    select pretty_name
    from pb_types
    where type_id = :type_id

      </querytext>
</fullquery>

<fullquery name="delete_attributes">
      <querytext>

    delete from pb_attributes
    where type_id = :type_id

      </querytext>
</fullquery>

<fullquery name="delete_type">
      <querytext>

    delete from pb_types
    where type_id = :type_id

      </querytext>
</fullquery>

</queryset>
