ad_page_contract {
    Form to add/edit a package.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    pkg_id:integer,optional
    {__new_p 0}
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

if {![info exists pkg_id] || $__new_p} {
    set page_title [_ package-builder.New_Package]
} else {
    set page_title [_ package-builder.Edit_Package]
}

set context_bar [ad_context_bar $page_title]
set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

ad_form -name package_form -action package-ae -form {
    {pkg_id:key}
    {key:text,optional {label "[_ package-builder.pkg_Key]"} {html {size 50 maxlength 50}} {help_text "[_ package-builder.pkg_Key_help]"}}
    {short_name:text {label "[_ package-builder.pkg_Short_Name]"} {html {size 5 maxlength 5}} {help_text "[_ package-builder.pkg_Short_Name_help]"}}
    {pretty_name:text {label "[_ package-builder.pkg_Pretty_Name]"} {html {size 80 maxlength 200}} {help_text "[_ package-builder.pkg_Pretty_Name_help]"}}
    {pretty_plural:text,optional {label "[_ package-builder.pkg_Pretty_Plural]"} {html {size 80 maxlength 200}} {help_text "[_ package-builder.pkg_Pretty_Plural_help]"}}
    {summary:text(textarea),optional {label "[_ package-builder.pkg_Summary]"} {html {rows 5 cols 80}} {help_text "[_ package-builder.pkg_Summary_help]"}}
    {vendor_name:text,optional {label "[_ package-builder.pkg_Vendor_Name]"} {html {size 80 maxlength 200}} {help_text "[_ package-builder.pkg_Vendor_Name_help]"}}
    {vendor_url:text,optional {label "[_ package-builder.pkg_Vendor_Url]"} {html {size 80 maxlength 200}} {help_text "[_ package-builder.pkg_Vendor_Url_help]"}}
    {description:text(textarea),optional {label "[_ package-builder.pkg_Description]"} {html {rows 5 cols 80}} {help_text "[_ package-builder.pkg_Description_help]"}}
} -new_request {
    set key ""
    set short_name ""
    set pretty_name ""
    set pretty_plural ""
    set summary ""
    set vendor_name ""
    set vendor_url ""
    set description ""
} -edit_request {
    db_1row package_data {}
} -validate {
    {key {![pb::util::package_exists -key $key -pretty_name $pretty_name]} "[_ package-builder.Package_exists]"}
} -on_submit {
    if {[empty_string_p $key]} {
	regsub -all { } [string tolower $pretty_name] {-} key
    }
    if {[empty_string_p $pretty_plural]} {
	set pretty_plural "${pretty_name}s"
    }
} -new_data {
    db_dml insert_package {}
} -edit_data {
    db_dml update_package {}
} -after_submit {
    ad_returnredirect .
    ad_script_abort
}

ad_return_template
