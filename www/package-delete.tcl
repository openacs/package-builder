ad_page_contract {
    Confirmation form to delete a package.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    pkg_id:integer
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set page_title "[_ package-builder.Delete_Package]"
set context_bar [ad_context_bar $page_title]

set confirm_options [list [list "[_ package-builder.continue_with_delete]" t] [list "[_ package-builder.cancel_and_return]" f]]

ad_form -name package_delete_confirm -action package-delete -form {
    {pkg_id:key}
    {pretty_name:text(inform) {label "[_ package-builder.Delete_Package]"}}
    {confirmation:text(radio) {label " "} {options $confirm_options} {value f}}
} -select_query_name {package_name} \
-on_submit {
    if {$confirmation} {
	db_transaction {
	    db_dml delete_attributes {}
	    db_dml delete_types {}
	    db_dml delete_package {}
	}
    }
} -after_submit {
    ad_returnredirect .
    ad_script_abort
}

ad_return_template
