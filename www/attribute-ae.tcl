ad_page_contract {
    Form to add/edit an attribute.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    pkg_id:integer
    type_id:integer
    attribute_id:integer,optional
    {__new_p 0}
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

db_1row type_and_package_data {}

if {![info exists attribute_id] || $__new_p} {
    set page_title [_ package-builder.New_Attribute]
} else {
    set page_title [_ package-builder.Edit_Attribute]
}

set context_bar [ad_context_bar [list [export_vars -base type-list {pkg_id}] $package_name] [list [export_vars -base attribute-list {pkg_id type_id}] $type_name] $page_title]
set package_id [ad_conn package_id]

set boolean_options [list [list "[_ package-builder.yes]" t] [list "[_ package-builder.no]" f]]
set datatype_options [list]
foreach dtype [list string number boolean] {
    lappend datatype_options [list "[_ package-builder.datatype_$dtype]" $dtype]
}
set widget_options [list]
foreach wtype [list text textarea radio checkbox select] {
    lappend widget_options [list "[_ package-builder.widget_$wtype]" $wtype]
}

ad_form -name attribute_form -action attribute-ae -export {pkg_id type_id} -form {
    {attribute_id:key}
    {name:text,optional {label "[_ package-builder.attr_Name]"} {html {size 80 maxlength 200}} {help_text "[_ package-builder.attr_Name_help]"}}
    {pretty_name:text {label "[_ package-builder.attr_Pretty_Name]"} {html {size 80 maxlength 200}} {help_text "[_ package-builder.attr_Pretty_Name_help]"}}
    {datatype:text(select) {label "[_ package-builder.attr_Datatype]"} {options $datatype_options} {value string} {help_text "[_ package-builder.attr_Datatype_help]"}}
    {column_spec:text(textarea) {label "[_ package-builder.attr_Column_Spec]"} {html {rows 8 cols 80}} {help_text "[_ package-builder.attr_Column_Spec_help]"}}
    {required_p:text(select) {label "[_ package-builder.attr_Required]"} {options $boolean_options} {value t} {help_text "[_ package-builder.attr_Required_help]"}}
    {widget:text(select) {label "[_ package-builder.attr_Widget]"} {options $widget_options} {help_text "[_ package-builder.attr_Widget_help]"}}
    {options:text(textarea),optional {label "[_ package-builder.attr_Options]"} {html {rows 8 cols 80}} {help_text "[_ package-builder.attr_Options_help]"}}
} -new_request {
    set name ""
    set pretty_name ""
    set datatype ""
    set column_spec ""
    set required_p ""
    set widget ""
    set options ""
} -edit_request {
    db_1row attribute_data {}
    set options [join $options "\n"]
} -on_submit {
    if {[empty_string_p $name]} {
	regsub -all { } [string tolower $pretty_name] {_} name
    }
    set options_list [list]
    foreach line [split $options "\n"] {
	lappend options_list [string trim $line]
    }
} -new_data {
    db_dml insert_attribute {}
} -edit_data {
    db_dml update_attribute {}
} -after_submit {
    ad_returnredirect [export_vars -base attribute-list {pkg_id type_id}]
    ad_script_abort
}

ad_return_template
