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

<fullquery name="attribute_data">
      <querytext>

    select name, pretty_name, datatype, column_spec, required_p, widget, options
    from pb_attributes
    where attribute_id = :attribute_id

      </querytext>
</fullquery>

<fullquery name="insert_attribute">
      <querytext>

    insert into pb_attributes (attribute_id, type_id, name, pretty_name, datatype,
                               column_spec, required_p, widget, options)
    values (:attribute_id, :type_id, :name, :pretty_name, :datatype, :column_spec,
            :required_p, :widget, :options_list)

      </querytext>
</fullquery>

<fullquery name="update_attribute">
      <querytext>

    update pb_attributes
    set name = :name,
        pretty_name = :pretty_name,
        datatype = :datatype,
        column_spec = :column_spec,
        required_p = :required_p,
        widget = :widget,
        options = :options_list
    where attribute_id = :attribute_id

      </querytext>
</fullquery>

</queryset>
