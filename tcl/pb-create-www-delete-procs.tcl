ad_library {
    Package Builder procs
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07
}

namespace eval pb::create::www::delete {}

ad_proc -public pb::create::www::delete::tcl {
    -pkg_data:required
    -type_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates delete tcl script
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)

    array set type $type_data
    set type_id $type(type_id)

    set result [subst {ad_page_contract \{
    Delete $type(pretty_name).

    @author $pkg(owner_name) ($pkg(owner_email))
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date $pkg(date)
\} \{
    $type(id_column)
\} -properties \{
    context_bar:onevalue
    page_title:onevalue
\}

set page_title \"\[_ $pkg(key)\.$type(name)\_Delete\]\"
set context_bar \[ad_context_bar \[list \"$type(name_dash)-list\" \"\[_ $pkg(key)\.$type(name)\_2\]\"\] \$page_title\]

set confirm_options \[list \[list \"\[_ $pkg(key)\.continue_with_delete\]\" t\] \[list \"\[_ $pkg(key)\.cancel_and_return\]\" f\]\]

ad_form -name delete_confirm -action $type(name_dash)-delete -export \{ $type(id_column) \} -form \{
    {section_id:key}
    \{title:text(inform) \{label \"\[_ $pkg(key)\.Delete\]\"\}\}
    \{confirmation:text(radio) \{label \" \"\} \{options \$confirm_options\} \{value f\}\}
\} -select_query_name \{title\} \\
-on_submit \{
    if \{\$confirmation\} \{
	db_dml mark_deleted \{\}
    \}
\} -after_submit \{
    ad_returnredirect \"$type(name_dash)-list\"
    ad_script_abort
\}

ad_return_template
    }]

    set f [open "$pkg(path)/www/$type(name_dash)-delete.tcl" w]
    puts $f $result
    close $f
}


ad_proc -public pb::create::www::delete::adp {
    -pkg_data:required
    -type_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates delete adp script
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)

    array set type $type_data
    set type_id $type(type_id)

    set result [subst {<master>
<property name=\"title\">@page_title;noquote@</property>
<property name=\"context_bar\">@context_bar;noquote@</property>

<blockquote>
  <formtemplate id=\"delete_confirm\"></formtemplate>
</blockquote>
    }]

    set f [open "$pkg(path)/www/$type(name_dash)-delete.adp" w]
    puts $f $result
    close $f
}


ad_proc -public pb::create::www::delete::xql {
    -pkg_data:required
    -type_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates delete xql script
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)

    array set type $type_data
    set type_id $type(type_id)

    set result [subst {<?xml version=\"1.0\"?>
<queryset>

<fullquery name=\"title\">
      <querytext>

	select title
	from cr_revisions
	where revision_id = :$type(id_column)

      </querytext>
</fullquery>

<fullquery name=\"mark_deleted\">
      <querytext>

	update cr_items
	set latest_revision = null
	where latest_revision = :$type(id_column)

      </querytext>
</fullquery>

</queryset>
    }]

    set f [open "$pkg(path)/www/$type(name_dash)-delete.xql" w]
    puts $f $result
    close $f
}
