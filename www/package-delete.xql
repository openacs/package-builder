<?xml version="1.0"?>
<queryset>

<fullquery name="package_name">
      <querytext>

    select pretty_name
    from pb_packages
    where pkg_id = :pkg_id

      </querytext>
</fullquery>

<fullquery name="delete_attributes">
      <querytext>

    delete from pb_attributes
    where type_id in (select type_id
		      from pb_types
		      where pkg_id = :pkg_id)

      </querytext>
</fullquery>

<fullquery name="delete_types">
      <querytext>

    delete from pb_types
    where pkg_id = :pkg_id

      </querytext>
</fullquery>

<fullquery name="delete_package">
      <querytext>

    delete from pb_packages
    where pkg_id = :pkg_id

      </querytext>
</fullquery>

</queryset>
