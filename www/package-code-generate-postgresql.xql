<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="package_data">
      <querytext>

    select p.pkg_id, p.key, p.short_name, p.pretty_name, p.pretty_plural, p.summary,
           p.vendor_name, p.vendor_url, p.description, pa.email as owner_email,
           pe.first_names || ' ' || pe.last_name as owner_name,
           to_char(now(), 'YYYY-MM-DD') as date
    from pb_packages p, persons pe, parties pa
    where p.pkg_id = :pkg_id
    and pe.person_id = p.owner_id
    and pa.party_id = p.owner_id

      </querytext>
</fullquery>

</queryset>
