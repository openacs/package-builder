ad_page_contract {

    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-08
} {
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set page_title "[_ package-builder.Index]"
set context_bar [ad_context_bar]
set package_id [ad_conn package_id]

set actions [list "[_ package-builder.New_Package]" package-ae "[_ package-builder.New_Package2]"]

db_multirow -extend {edit_link delete_link create_link} packages packages {} {
    set edit_link [export_vars -base package-ae {pkg_id}]
    set delete_link [export_vars -base package-delete {pkg_id}]
    set create_link [export_vars -base package-code-generate {pkg_id}]
}

list::create \
    -name packages \
    -key pkg_id \
    -no_data "[_ package-builder.None]" \
    -elements {
	pretty_name {
	    label "[_ package-builder.Name]"
	    link_url_eval "[export_vars -base type-list { pkg_id }]"
	}
	action {
	    display_template {<a href="@packages.edit_link@">#package-builder.Edit#</a>&nbsp;<a href="@packages.delete_link@">#package-builder.Delete#</a>&nbsp;<a href="@packages.create_link@">#package-builder.Generate#</a>}
	}
    } -actions $actions

ad_return_template
