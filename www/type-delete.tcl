ad_page_contract {
    Confirmation form to delete an item type.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    pkg_id:integer
    type_id:integer
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

db_1row package_data {}

set page_title "[_ package-builder.Delete_Type]"
set context_bar [ad_context_bar [list [export_vars -base type-list {pkg_id}] $package_name] $page_title]

set confirm_options [list [list "[_ package-builder.continue_with_delete]" t] [list "[_ package-builder.cancel_and_return]" f]]

ad_form -name type_delete_confirm -action type-delete -export { pkg_id } -form {
    {type_id:key}
    {pretty_name:text(inform) {label "[_ package-builder.Delete_Type]"}}
    {from:text(inform) {label "[_ package-builder.From_Package]"} {value $package_name}}
    {confirmation:text(radio) {label " "} {options $confirm_options} {value f}}
} -select_query_name {type_name} \
-on_submit {
    if {$confirmation} {
	db_transaction {
	    db_dml delete_attributes {}
	    db_dml delete_type {}
	}
    }
} -after_submit {
    ad_returnredirect [export_vars -base type-list {pkg_id}]
    ad_script_abort
}

ad_return_template
