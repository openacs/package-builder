ad_library {
    Package Builder procs
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07
}

namespace eval pb::create::tcl {}

ad_proc -public pb::create::tcl::install {
    -pkg_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates the tcl install script
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)

    set type_list [db_list_of_lists types {}]

    set result [subst {ad_library \{
    $pkg(pretty_name) Package install callbacks
    
    Procedures that deal with installing.
    
    @author $pkg(owner_name) ($pkg(owner_email))
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date $pkg(date)
\}

namespace eval $pkg(short_name)::install \{\}

ad_proc -public $pkg(short_name)::install::create_install \{
\} \{
    Creates the content types and adds the attributes.
\} \{
    }]
    
    foreach one_type $type_list {
	util_unlist $one_type type_id type_name pretty_name pretty_plural tablename id_column
	append result "content::type::new -content_type \{$type_name\} -supertype \{content_revision\} -pretty_name \{$pretty_name\} -pretty_plural \{$pretty_plural\} -table_name \{$tablename\} -id_column \{$id_column\}\n"
    }

    foreach one_type $type_list {
	util_unlist $one_type type_id type_name pretty_name pretty_plural tablename id_column
	append result "\n# $pretty_name\n"

	db_foreach attributes {} {
	    append result "content::type::attribute::new -content_type \{$type_name\} -attribute_name \{$name\} -datatype \{$datatype\} -pretty_name \{$pretty_name\} -column_spec \{$column_spec\}\n"
	}
    }

    append result [subst {
\}

ad_proc -public $pkg(short_name)::install::package_instantiate \{
    -package_id:required
\} \{
    Define folders
\} \{
    # create a content folder
    set folder_id \[content::folder::new -name \"$pkg(key_under)_\$package_id\" -package_id \$package_id\]
    # register the allowed content types for a folder
    }]

    foreach one_type $type_list {
	util_unlist $one_type type_id type_name pretty_name pretty_plural tablename id_column
	append result "content::folder::register_content_type -folder_id \$folder_id -content_type \{$type_name\} -include_subtypes t\n"
    }

    append result "\}"
    set f [open "$pkg(path)/tcl/$pkg(short_name)-install-procs.tcl" w]
    puts $f $result
    close $f
}


ad_proc -public pb::create::tcl::util {
    -pkg_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates util tcl procs
} {
    array set pkg $pkg_data

    set result [subst {ad_library \{
    $pkg(pretty_name) util procs
    @author $pkg(owner_name) ($pkg(owner_email))
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date $pkg(date)
\}

namespace eval $pkg(short_name)::util \{\}

ad_proc $pkg(short_name)::util::folder_id \{
    -package_id:required
\} \{
    @author $pkg(owner_name) ($pkg(owner_email))
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date $pkg(date)

    Returns the folder_id of the package instance
\} \{
    return \[db_string get_folder_id \"select folder_id from cr_folders where package_id=:package_id\"\]
\}
    }]

    set f [open "$pkg(path)/tcl/$pkg(short_name)-util-procs.tcl" w]
    puts $f $result
    close $f
}


ad_proc -public pb::create::tcl::wrapper {
    -pkg_data:required
    -type_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates wrapper tcl procs to add/edit a content type
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)

    array set type $type_data
    set type_id $type(type_id)

    set vars ""
    set params ""
    db_foreach attributes {} {
	append vars "    {-$attr_name \"\"}\n"
	append params "\\\n\t\t\[list $attr_name \$$attr_name\] "
    }

    set result [subst {ad_library \{
    $type(pretty_name) procs
    @author $pkg(owner_name) ($pkg(owner_email))
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date $pkg(date)
\}

namespace eval $pkg(short_name)::$type(name) \{\}

ad_proc -public $pkg(short_name)::$type(name)::new \{
    \{-name \"\"\}
    \{-title \"\"\}
    \{-description \"\"\}
$vars\} \{
    @author $pkg(owner_name) ($pkg(owner_email))
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date $pkg(date)

    New $type(pretty_name)
\} \{
    set package_id \[ad_conn package_id\]
    set folder_id \[$pkg(short_name)::util::folder_id -package_id \$package_id\]

    db_transaction \{
	if \{\[empty_string_p \$name\]\} \{
	    set name \[exec uuidgen\]
	\}
	set item_id \[content::item::new -parent_id \$folder_id -content_type \{$type(name)\} -name \$name -title \$title\]

	set new_id \[content::revision::new \\
		       -item_id \$item_id \\
		       -content_type \{$type(name)\} \\
		       -title \$title \\
		       -description \$description \\
		       -attributes \[list $params\] \]
    \}

    return \$new_id
\}

ad_proc -public $pkg(short_name)::$type(name)::edit \{
    -$type(id_column)\:required
    \{-title \"\"\}
    \{-description \"\"\}
$vars\} \{
    @author $pkg(owner_name) ($pkg(owner_email))
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date $pkg(date)

    Edit $type(pretty_name)
\} \{
    db_transaction \{
	set new_rev_id \[content::revision::new \\
			    -item_id \$$type(id_column) \\
			    -content_type \{$type(name)\} \\
			    -title \$title \\
			    -description \$description \\
			    -attributes \[list $params\] \]
    \}

    return \$new_rev_id
\}
    }]

    set f [open "$pkg(path)/tcl/$type(name_dash)\-procs.tcl" w]
    puts $f $result
    close $f
}
