ad_library {
    Package Builder procs
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07
}

namespace eval pb::create::catalog {}

ad_proc -public pb::create::catalog::create {
    -pkg_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates english catalog file
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)
    set types [db_list_of_lists types {}]

    set msg($pkg(key_under)) $pkg(pretty_plural)
    set msg(Edit) Edit
    set msg(Delete) Delete
    set msg(None) None
    set msg(continue_with_delete) "Continue with Delete"
    set msg(cancel_and_return) "Cancel and Return"
    set msg(admin_categories) "Categories Administration"

    foreach one_type $types {
	util_unlist $one_type type_id type_name pretty_name pretty_plural name_pretty title_pretty descr_pretty
	set msg($type_name\_Add) "Add $pretty_name"
	set msg($type_name\_Edit) "Edit $pretty_name"
	set msg($type_name\_Delete) "Delete $pretty_name"
	set msg($type_name\_View) "View $pretty_name"
	set msg($type_name\_New) "New $pretty_name"
	set msg($type_name\_New2) "Create New $pretty_name"
	set msg($type_name\_1) $pretty_name
	set msg($type_name\_2) $pretty_plural
	if {![empty_string_p $name_pretty]} {
	    set msg($type_name\_Name) $name_pretty
	}
	if {![empty_string_p $title_pretty]} {
	    set msg($type_name\_Title) $title_pretty
	}
	if {![empty_string_p $descr_pretty]} {
	    set msg($type_name\_Description) $descr_pretty
	}

	db_foreach attributes {} {
	    set msg($type_name\_$name) $pretty_name
	    if {$datatype == "string" && $widget != "text" && $widget != "textarea"} {
		foreach opt $options {
		    regsub -all { } [string tolower $opt] {_} opt_under
		    set msg($type_name\_$name\_$opt_under) $opt
		}
	    }
	    if {$datatype == "boolean"} {
		set msg(yes) Yes
		set msg(no) No
	    }
	}
    }

    set msgs ""
    foreach key [lsort -dictionary [array names msg]] {
	append msgs "  <msg key=\"$key\">$msg($key)</msg>\n"
    }

    set result [subst {<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>
<message_catalog package_key=\"$pkg(key)\" package_version=\"0.01d1\" locale=\"en_US\" charset=\"ISO-8859-1\">

$msgs
</message_catalog>
    }]

    set f [open "$pkg(path)/catalog/$pkg(key).en_US.ISO-8859-1.xml" w]
    puts $f $result
    close $f
}
