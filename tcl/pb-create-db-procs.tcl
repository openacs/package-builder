ad_library {
    Package Builder procs
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07
}

namespace eval pb::create::db {}

ad_proc -public pb::create::db::create {
    -pkg_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates the db create scripts
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)

    set type_list [db_list_of_lists types {}]

    set result [subst {--
-- $pkg(pretty_name) Package
--
-- @author $pkg(owner_name) ($pkg(owner_email))
-- @author Timo Hentschel (timo@timohentschel.de)
-- @creation-date $pkg(date)
--


}]

    foreach one_type $type_list {
	util_unlist $one_type type_id tablename id_column
	append result "\n\ncreate table $tablename (\n"
        append result "\t$id_column\t\tinteger constraint $tablename\_$id_column\_pk primary key"

	db_foreach attributes {} {
	    append result ",\n\t$name\t\t$column_spec"
	}

	append result "\n);\n"
    }

    set f [open "$pkg(path)/sql/postgresql/$pkg(key)-create.sql" w]
    puts $f $result
    close $f
}


ad_proc -public pb::create::db::drop {
    -pkg_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates the db drop scripts
} {
    array set pkg $pkg_data
    set pkg_id $pkg(pkg_id)

    set result [subst {--
-- $pkg(pretty_name) Package
--
-- @author $pkg(owner_name) ($pkg(owner_email))
-- @author Timo Hentschel (timo@timohentschel.de)
-- @creation-date $pkg(date)
--



}]

    db_foreach tables {} {
	append result "drop table $tablename;\n"
    }

    set f [open "$pkg(path)/sql/postgresql/$pkg(key)-drop.sql" w]
    puts $f $result
    close $f
}
