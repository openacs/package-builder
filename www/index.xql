<?xml version="1.0"?>
<queryset>

<fullquery name="packages">
      <querytext>

    select pkg_id, pretty_name
    from pb_packages
    where package_id = :package_id
    order by lower(pretty_name)

      </querytext>
</fullquery>

</queryset>
