ad_library {
    Package Builder procs
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07
}

namespace eval pb::create::www::ae {}

ad_proc -public pb::create::www::ae::tcl {
    -pkg_data:required
    -type_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates add/edit form tcl script
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)

    array set type $type_data
    set type_id $type(type_id)
    # regsub -all {_} $type(name) {-} type(name_dash)

    set eoptions ""
    set elements ""
    set defaults ""
    set params ""
    db_foreach attributes {} {
	append defaults "\tset $name \"\"\n"
	append params "\\\n\t\t-$name \$$name "
	set optional ""
	if {$required_p == "f"} {
	    set optional ",optional"
	}
	switch -exact $datatype {
	    string {
		set etype text
		if {$widget == "textarea"} {
		    set ewidget "(textarea)"
		    set other "\{html \{rows 8 cols 80\}\}"
		} elseif {$widget == "text"} {
		    set ewidget ""
		    set other "\{html \{size 80 maxlength 200\}\}"
		} else {
		    set ewidget "($widget)"
		    set other "\{options \$$name\_options\}"
		    append eoptions "set $name\_options \[list"
		    foreach opt $options {
			regsub -all { } [string tolower $opt] {_} opt_under
			append eoptions " \[list \"\[_ $pkg(key)\.$type(name)\_$name\_$opt_under\]\" \"$opt\"\]"
		    }
		    append eoptions "\]\n"
		}
	    }
	    number {
		set etype integer
		set ewidget ""
		set other "\{html \{size 10 maxlength 10\}\}"
	    }
	    boolean {
		set etype text
		set ewidget "(select)"
		set other "\{options \$$name\_options\}"
		append eoptions "set $name\_options \[list \[list \"\[_ $pkg(key)\.yes\]\" t\] \[list \"\[_ $pkg(key)\.no\]\" f\]\]\n"
	    }
	}
	append elements "\t\{$name\:$etype$ewidget$optional \{label \"\[_ $pkg(key)\.$type(name)\_$name\]\"\} $other \{help_text \"\[_ $pkg(key)\.$type(name)\_$name\_help\]\"\}\}\n"
    }

    set result [subst {ad_page_contract \{
    Form to add/edit $type(pretty_name).

    @author $pkg(owner_name) ($pkg(owner_email))
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date $pkg(date)
\} \{
    $type(id_column)\:integer,optional
    \{__new_p 0\}
    \{mode edit\}
\} -properties \{
    context_bar:onevalue
    page_title:onevalue
\}

set has_submit 0
if \{!\[info exists $type(id_column)\] || \$__new_p\} \{
    set page_title \"\[_ $pkg(key)\.$type(name)\_Add\]\"
    set _$type(id_column) 0
\} else \{
    if \{\$mode == \"edit\"\} \{
        set page_title \"\[_ $pkg(key)\.$type(name)\_Edit\]\"
    \} else \{
        set page_title \"\[_ $pkg(key)\.$type(name)\_View\]\"
        set has_submit 1
    \}
    set _$type(id_column) \$$type(id_column)
\}

set context_bar \[ad_context_bar \[list \"$type(name_dash)-list\" \"\[_ $pkg(key)\.$type(name)\_2\]\"\] \$page_title\]
set package_id \[ad_conn package_id\]

$eoptions
ad_form -name $type(name)\_form -action $type(name_dash)\-ae -mode \$mode -has_submit \$has_submit -form \{
    \{$type(id_column):key\}
\}
    }]

    set ntd_defaults ""
    set n_param ""
    if {![empty_string_p $type(name_pretty)]} {
	set ntd_defaults "    set name \"\"\n"
	set n_param "\\\n\t\t-name \$name "
	append result [subst {
if \{\$_$type(id_column) > 0\} \{
    ad_form -extend -name $type(name)\_form -form \{
    \{name:text(inform) \{label \"\[_ $pkg(key)\.$type(name)\_Name\]\"\} \{html \{size 80 maxlength 1000\}\} \{help_text \"\[_ $pkg(key)\.$type(name)\_Name_help\]\"\}\}
    \}
\} else \{
    ad_form -extend -name $type(name)\_form -form \{
    \{name:text,optional \{label \"\[_ $pkg(key)\.$type(name)\_Name\]\"\} \{html \{size 80 maxlength 1000\}\} \{help_text \"\[_ $pkg(key)\.$type(name)\_Name_help\]\"\}\}
    \}
\}
	}]
    }

    set td_params ""
    if {![empty_string_p $type(title_pretty)] || ![empty_string_p $type(descr_pretty)]} {
	append result [subst {
ad_form -extend -name $type(name)\_form -form \{}]

	if {![empty_string_p $type(title_pretty)]} {
	    append ntd_defaults "    set title \"\"\n"
	    set td_params "\\\n\t\t-title \$title "
	    append result [subst {
    \{title:text \{label \"\[_ $pkg(key)\.$type(name)\_Title\]\"\} \{html \{size 80 maxlength 1000\}\} \{help_text \"\[_ $pkg(key)\.$type(name)\_Title_help\]\"\}\}}]
	}
	if {![empty_string_p $type(descr_pretty)]} {
	    append ntd_defaults "    set description \"\"\n"
	    append td_params "\\\n\t\t-description \$description "
	    append result [subst {
    \{description:text(textarea),optional \{label \"\[_ $pkg(key)\.$type(name)\_Description\]\"\} \{html \{rows 5 cols 80\}\} \{help_text \"\[_ $pkg(key)\.$type(name)\_Description_help\]\"\}\}}]
	}
	append result [subst {
\}
	}]
    }

    append result [subst {
if \{!\[empty_string_p \[category_tree::get_mapped_trees \$package_id\]\]\} \{
    category::ad_form::add_widgets -container_object_id \$package_id -categorized_object_id \$_$type(id_column) -form_name $type(name)\_form
\}

ad_form -extend -name $type(name)\_form -form \{
$elements\} -new_request \{
$ntd_defaults$defaults\} -edit_request \{
    db_1row get_data \{\}
\} -on_submit \{
    set category_ids \[category::ad_form::get_categories -container_object_id \$package_id\]
\} -new_data \{
    db_transaction \{
	set new_$type(id_column) \[$pkg(short_name)::$type(name)::new $n_param $td_params $params\]

	if \{\[exists_and_not_null category_ids\]\} \{
	    category::map_object -object_id \$new_$type(id_column) \$category_ids
	\}
    \}
\} -edit_data \{
    db_transaction \{
	set new_$type(id_column) \[$pkg(short_name)::$type(name)::edit \\
				-$type(id_column) \$$type(id_column) $td_params $params\]

	if \{\[exists_and_not_null category_ids\]\} \{
	    category::map_object -object_id \$new_$type(id_column) \$category_ids
	\}
    \}
\} -after_submit \{
    ad_returnredirect $type(name_dash)-list
    ad_script_abort
\}

ad_return_template
    }]
    

    set f [open "$pkg(path)/www/$type(name_dash)-ae.tcl" w]
    puts $f $result
    close $f
}


ad_proc -public pb::create::www::ae::adp {
    -pkg_data:required
    -type_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates add/edit form adp script
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)

    array set type $type_data
    set type_id $type(type_id)

    set result [subst {<master>
<property name=\"title\">@page_title;noquote@</property>
<property name=\"context_bar\">@context_bar;noquote@</property>

<blockquote>
  <formtemplate id=\"$type(name)\_form\"></formtemplate>
</blockquote>
    }]

    set f [open "$pkg(path)/www/$type(name_dash)-ae.adp" w]
    puts $f $result
    close $f
}


ad_proc -public pb::create::www::ae::xql {
    -pkg_data:required
    -type_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates add/edit form xql script
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)

    array set type $type_data
    set type_id $type(type_id)

    set columns ""
    if {![empty_string_p $type(name_pretty)]} {
	set columns "i.name, "
    }
    if {![empty_string_p $type(title_pretty)]} {
	append columns "r.title, "
    }
    if {![empty_string_p $type(descr_pretty)]} {
	append columns "r.description, "
    }

    db_foreach attributes {} {
	append columns "t.$name, "
    }
    set columns [string range $columns 0 end-2]

    set result [subst {<?xml version=\"1.0\"?>
<queryset>

<fullquery name=\"get_data\">
      <querytext>

	select $columns
	from $type(tablename) t, cr_revisions r, cr_items i
	where r.revision_id = t.$type(id_column)
	and i.item_id = r.item_id
	and t.$type(id_column) = :$type(id_column)

      </querytext>
</fullquery>

</queryset>
    }]

    set f [open "$pkg(path)/www/$type(name_dash)-ae.xql" w]
    puts $f $result
    close $f
}
