ad_page_contract {

    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-08
} {
    pkg_id:integer
    type_id:integer
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

db_1row type_data {}

set page_title "[_ package-builder.Attributes]"
set context_bar [ad_context_bar [list [export_vars -base type-list {pkg_id}] $type_name] $page_title]

set actions [list "[_ package-builder.New_Attribute]" [export_vars -base attribute-ae {pkg_id type_id}] "[_ package-builder.New_Attribute2]"]

db_multirow -extend {edit_link delete_link} attributes attributes {} {
    set edit_link [export_vars -base attribute-ae {pkg_id type_id attribute_id}]
    set delete_link [export_vars -base attribute-delete {pkg_id type_id attribute_id}]
}

list::create \
    -name attributes \
    -key attribute_id \
    -no_data "[_ package-builder.None]" \
    -elements {
	pretty_name {
	    label "[_ package-builder.Name]"
	}
	action {
	    display_template {<a href="@attributes.edit_link@">#package-builder.Edit#</a>&nbsp;<a href="@attributes.delete_link@">#package-builder.Delete#</a>}
	}
    } -actions $actions

ad_return_template
