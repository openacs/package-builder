ad_library {
    Package Builder procs
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07
}

namespace eval pb::create::www::index {}

ad_proc -public pb::create::www::index::tcl {
    -pkg_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates index tcl script
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)

    set result [subst {ad_page_contract \{
    Index page.

    @author $pkg(owner_name) ($pkg(owner_email))
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date $pkg(date)
\} \{
\} -properties \{
    context_bar:onevalue
    page_title:onevalue
\}

set page_title \"\[_ $pkg(key)\.$pkg(key_under)\]\"
set context_bar \[ad_context_bar\]
set package_id \[ad_conn package_id\]
set categories_node_id \[db_string get_category_node_id \{\}\]
set categories_url \[site_node::get_url -node_id \$categories_node_id\]

ad_return_template
    }]

    set f [open "$pkg(path)/www/index.tcl" w]
    puts $f $result
    close $f
}


ad_proc -public pb::create::www::index::adp {
    -pkg_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates index adp script
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)

    set types ""
    db_foreach types {} {
	regsub -all {_} $name {-} name_dash
	append types "<li><a href=\"$name_dash\-list\">$pretty_plural</a></li>\n"
    }

    set result [subst {<master>
<property name=\"title\">@page_title;noquote@</property>
<property name=\"context_bar\">@context_bar;noquote@</property>

<a href=\"@categories_url@cadmin/one-object?object_id=@package_id@\">#$pkg(key).admin_categories#</a>
<p>

<ul>
$types</ul>
    }]

    set f [open "$pkg(path)/www/index.adp" w]
    puts $f $result
    close $f
}


ad_proc -public pb::create::www::index::xql {
    -pkg_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates index xql script
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)

    set result [subst {<?xml version=\"1.0\"?>

<queryset>

<fullquery name=\"get_category_node_id\">
      <querytext>
      
	    select n.node_id
	    from site_nodes n, site_nodes top, apm_packages p
	    where top.parent_id is null
	    and n.parent_id = top.node_id
	    and p.package_id = n.object_id
	    and p.package_key = 'categories'
	
      </querytext>
</fullquery>

</queryset>
    }]

    set f [open "$pkg(path)/www/index.xql" w]
    puts $f $result
    close $f
}
