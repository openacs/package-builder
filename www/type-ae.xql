<?xml version="1.0"?>
<queryset>

<fullquery name="package_data">
      <querytext>

    select pretty_name as package_name, short_name as package_short
    from pb_packages
    where pkg_id = :pkg_id

      </querytext>
</fullquery>

<fullquery name="type_data">
      <querytext>

    select name, pretty_name, pretty_plural, tablename, id_column, name_pretty,
           title_pretty, descr_pretty
    from pb_types
    where type_id = :type_id

      </querytext>
</fullquery>

<fullquery name="max_sort_order">
      <querytext>

    select max(sort_order)
    from pb_types
    where pkg_id = :pkg_id

      </querytext>
</fullquery>

<fullquery name="insert_type">
      <querytext>

    insert into pb_types (type_id, pkg_id, name, pretty_name, pretty_plural, tablename,
                          id_column, name_pretty, title_pretty, descr_pretty, sort_order)
    values (:type_id, :pkg_id, :name, :pretty_name, :pretty_plural, :tablename,
            :id_column, :name_pretty, :title_pretty, :descr_pretty, :sort_order)

      </querytext>
</fullquery>

<fullquery name="update_type">
      <querytext>

    update pb_types
    set name = :name,
        pretty_name = :pretty_name,
        pretty_plural = :pretty_plural,
        tablename = :tablename,
        id_column = :id_column,
        name_pretty = :name_pretty,
        title_pretty = :title_pretty,
        descr_pretty = :descr_pretty
    where type_id = :type_id

      </querytext>
</fullquery>

</queryset>
