ad_page_contract {
    Confirmation form to delete an attribute.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    pkg_id:integer
    type_id:integer
    attribute_id:integer
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

db_1row type_and_package_data {}

set page_title "[_ package-builder.Delete_Attribute]"
set context_bar [ad_context_bar [list [export_vars -base type-list {pkg_id}] $package_name] [list [export_vars -base attribute-list {pkg_id type_id}] $type_name] $page_title]

set confirm_options [list [list "[_ package-builder.continue_with_delete]" t] [list "[_ package-builder.cancel_and_return]" f]]

ad_form -name attribute_delete_confirm -action attribute-delete -export { pkg_id type_id } -form {
    {attribute_id:key}
    {pretty_name:text(inform) {label "[_ package-builder.Delete_Attribute]"}}
    {from:text(inform) {label "[_ package-builder.From_Type]"} {value $type_name}}
    {confirmation:text(radio) {label " "} {options $confirm_options} {value f}}
} -select_query_name {attribute_name} \
-on_submit {
    if {$confirmation} {
	db_dml delete_attribute {}
    }
} -after_submit {
    ad_returnredirect [export_vars -base attribute-list {pkg_id type_id}]
    ad_script_abort
}

ad_return_template
