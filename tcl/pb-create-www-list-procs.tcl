ad_library {
    Package Builder procs
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07
}

namespace eval pb::create::www::list {}

ad_proc -public pb::create::www::list::tcl {
    -pkg_data:required
    -type_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates list tcl script
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)

    array set type $type_data
    set type_id $type(type_id)

    set result [subst {ad_page_contract \{
    List of $type(pretty_plural).

    @author $pkg(owner_name) ($pkg(owner_email))
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date $pkg(date)
\} \{
\} -properties \{
    context_bar:onevalue
    page_title:onevalue
\}

set page_title \"\[_ $pkg(key)\.$type(name)\_2\]\"
set context_bar \[ad_context_bar \$page_title\]
set package_id \[ad_conn package_id\]

set actions \[list \"\[_ $pkg(key)\.$type(name)\_New\]\" $type(name_dash)-ae \"\[_ $pkg(key)\.$type(name)\_New2\]\"\]

template::list::create \\
    -name $type(name) \\
    -key $type(id_column) \\
    -no_data \"\[_ $pkg(key)\.None\]\" \\
    -elements \{
        title \{
	    label \{\[_ $pkg(key)\.$type(name)\_1\]\}
	    link_url_eval \{\[export_vars -base \"$type(name_dash)-ae\" \{$type(id_column) \{mode display\}\}\]\}
        \}
        action \{
	    display_template \{<a href=\"@$type(name)\.edit_link@\">#$pkg(key)\.Edit#</a>&nbsp;<a href=\"@$type(name)\.delete_link@\">#$pkg(key)\.Delete#</a>\}
	
        \}
    \} -actions \$actions

db_multirow -extend \{edit_link delete_link\} $type(name) $type(name) \{\} \{
    set edit_link \[export_vars -base \"$type(name_dash)-ae\" \{$type(id_column)\}\]
    set delete_link \[export_vars -base \"$type(name_dash)-delete\" \{$type(id_column)\}\]
\}

ad_return_template
    }]    

    set f [open "$pkg(path)/www/$type(name_dash)-list.tcl" w]
    puts $f $result
    close $f
}


ad_proc -public pb::create::www::list::adp {
    -pkg_data:required
    -type_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates list adp script
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)

    array set type $type_data
    set type_id $type(type_id)

    set result [subst {<master>
<property name=\"title\">@page_title;noquote@</property>
<property name=\"context_bar\">@context_bar;noquote@</property>

<listtemplate name=\"$type(name)\"></listtemplate>
    }]

    set f [open "$pkg(path)/www/$type(name_dash)-list.adp" w]
    puts $f $result
    close $f
}


ad_proc -public pb::create::www::list::xql {
    -pkg_data:required
    -type_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates list xql script
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)

    array set type $type_data
    set type_id $type(type_id)

    set result [subst {<?xml version=\"1.0\"?>
<queryset>

<fullquery name=\"$type(name)\">
      <querytext>
      
    select t.$type(id_column), cr.title
    from cr_folders cf, cr_items ci, cr_revisions cr, $type(tablename) t
    where cr.revision_id = ci.latest_revision
    and t.$type(id_column) = cr.revision_id
    and ci.parent_id = cf.folder_id
    and cf.package_id = :package_id
    order by cr.title
    
      </querytext>
</fullquery>

</queryset>
    }]

    set f [open "$pkg(path)/www/$type(name_dash)-list.xql" w]
    puts $f $result
    close $f
}
