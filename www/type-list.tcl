ad_page_contract {

    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-08
} {
    pkg_id:integer
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set page_title "[_ package-builder.Types]"
set context_bar [ad_context_bar $page_title]

set actions [list "[_ package-builder.New_Type]" [export_vars -base type-ae {pkg_id}] "[_ package-builder.New_Type2]"]

db_multirow -extend {edit_link delete_link} types types {} {
    set edit_link [export_vars -base type-ae {pkg_id type_id}]
    set delete_link [export_vars -base type-delete {pkg_id type_id}]
}

list::create \
    -name types \
    -key type_id \
    -no_data "[_ package-builder.None]" \
    -elements {
	pretty_name {
	    label "[_ package-builder.Name]"
	    link_url_eval "[export_vars -base attribute-list { pkg_id type_id }]"
	}
	action {
	    display_template {<a href="@types.edit_link@">#package-builder.Edit#</a>&nbsp;<a href="@types.delete_link@">#package-builder.Delete#</a>}
	}
    } -actions $actions

ad_return_template
