ad_page_contract {
    Form to add/edit an item type.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    pkg_id:integer
    type_id:integer,optional
    {__new_p 0}
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

db_1row package_data {}

if {![info exists type_id] || $__new_p} {
    set page_title [_ package-builder.New_Type]
} else {
    set page_title [_ package-builder.Edit_Type]
}

set context_bar [ad_context_bar [list [export_vars -base type-list {pkg_id}] $package_name] $page_title]
set package_id [ad_conn package_id]

ad_form -name type_form -action type-ae -export {pkg_id} -form {
    {type_id:key}
    {name:text,optional {label "[_ package-builder.type_Name]"} {html {size 80 maxlength 200}} {help_text "[_ package-builder.type_Name_help]"}}
    {pretty_name:text {label "[_ package-builder.type_Pretty_Name]"} {html {size 80 maxlength 200}} {help_text "[_ package-builder.type_Pretty_Name_help]"}}
    {pretty_plural:text,optional {label "[_ package-builder.type_Pretty_Plural]"} {html {size 80 maxlength 200}} {help_text "[_ package-builder.type_Pretty_Plural_help]"}}
    {tablename:text,optional {label "[_ package-builder.type_Tablename]"} {html {size 80 maxlength 200}} {help_text "[_ package-builder.type_Tablename_help]"}}
    {id_column:text,optional {label "[_ package-builder.type_Id_Column]"} {html {size 80 maxlength 200}} {help_text "[_ package-builder.type_Id_Column_help]"}}
    {name_pretty:text,optional {label "[_ package-builder.type_Name_Pretty]"} {html {size 80 maxlength 200}} {help_text "[_ package-builder.type_Name_Pretty_help]"}}
    {title_pretty:text,optional {label "[_ package-builder.type_Title_Pretty]"} {html {size 80 maxlength 200}} {help_text "[_ package-builder.type_Title_Pretty_help]"}}
    {descr_pretty:text,optional {label "[_ package-builder.type_Descr_Pretty]"} {html {size 80 maxlength 200}} {help_text "[_ package-builder.type_Descr_Pretty_help]"}}
} -new_request {
    set name ""
    set pretty_name ""
    set pretty_plural ""
    set tablename ""
    set id_column ""
    set name_pretty ""
    set title_pretty ""
    set descr_pretty ""
} -edit_request {
    db_1row type_data {}
} -on_submit {
    if {[empty_string_p $name]} {
	regsub -all { } [string tolower $pretty_name] {_} name
	set name "$package_short\_$name"
    }
    if {[empty_string_p $pretty_plural]} {
	set pretty_plural "${pretty_name}s"
    }
    if {[empty_string_p $tablename]} {
	set tablename "${name}s"
    }
    if {[empty_string_p $id_column]} {
	regsub -all { } [string tolower $pretty_name] {_} id_column
	set id_column "$id_column\_id"
    }
} -new_data {
    set sort_order [db_string max_sort_order {}]
    if {[empty_string_p $sort_order]} {
	set sort_order 0
    }
    incr sort_order
    db_dml insert_type {}
} -edit_data {
    db_dml update_type {}
} -after_submit {
    ad_returnredirect [export_vars -base type-list {pkg_id}]
    ad_script_abort
}

ad_return_template
