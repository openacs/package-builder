<?xml version="1.0"?>
<queryset>

<fullquery name="package_data">
      <querytext>

    select key, short_name, pretty_name, pretty_plural, summary, vendor_name,
           vendor_url, description
    from pb_packages
    where pkg_id = :pkg_id

      </querytext>
</fullquery>

<fullquery name="insert_package">
      <querytext>

    insert into pb_packages (pkg_id, package_id, key, short_name, pretty_name,
                             pretty_plural, summary, vendor_name, vendor_url,
                             description, owner_id)
    values (:pkg_id, :package_id, :key, :short_name, :pretty_name, :pretty_plural,
            :summary, :vendor_name, :vendor_url, :description, :user_id)

      </querytext>
</fullquery>

<fullquery name="update_package">
      <querytext>

    update pb_packages
    set key = :key,
        short_name = :short_name,
        pretty_name = :pretty_name,
        pretty_plural = :pretty_plural,
        summary = :summary,
        vendor_name = :vendor_name,
        vendor_url = :vendor_url,
        description = :description
    where pkg_id = :pkg_id

      </querytext>
</fullquery>

</queryset>
