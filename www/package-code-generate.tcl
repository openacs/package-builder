ad_page_contract {

    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-08
} {
    pkg_id
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set page_title "[_ package-builder.Package_Created]"
set context_bar [ad_context_bar $page_title]

# date owner_name owner_email path
db_1row package_data {} -column_array pkg
regsub -all -- {-} $pkg(key) {_} pkg(key_under)
set pkg(path) "[acs_root_dir]/packages/$pkg(key)"
set pkg_data [array get pkg]

set types [db_list types {}]

# file delete $pkg(path)
file mkdir $pkg(path)
file mkdir "$pkg(path)/tcl"
file mkdir "$pkg(path)/www"
file mkdir "$pkg(path)/catalog"
file mkdir "$pkg(path)/sql"
file mkdir "$pkg(path)/sql/postgresql"

pb::create::info::create -pkg_data $pkg_data
pb::create::db::create -pkg_data $pkg_data
pb::create::db::drop -pkg_data $pkg_data
pb::create::catalog::create -pkg_data $pkg_data
pb::create::tcl::install -pkg_data $pkg_data
pb::create::tcl::util -pkg_data $pkg_data
pb::create::www::index::tcl -pkg_data $pkg_data
pb::create::www::index::adp -pkg_data $pkg_data
pb::create::www::index::xql -pkg_data $pkg_data

foreach type_id $types {
    db_1row type_data {} -column_array type
    regsub -all {_} $type(name) {-} type(name_dash)
    set type_data [array get type]

    pb::create::tcl::wrapper -pkg_data $pkg_data -type_data $type_data
    pb::create::www::list::tcl -pkg_data $pkg_data -type_data $type_data
    pb::create::www::list::adp -pkg_data $pkg_data -type_data $type_data
    pb::create::www::list::xql -pkg_data $pkg_data -type_data $type_data
    pb::create::www::ae::tcl -pkg_data $pkg_data -type_data $type_data
    pb::create::www::ae::adp -pkg_data $pkg_data -type_data $type_data
    pb::create::www::ae::xql -pkg_data $pkg_data -type_data $type_data
    pb::create::www::delete::tcl -pkg_data $pkg_data -type_data $type_data
    pb::create::www::delete::adp -pkg_data $pkg_data -type_data $type_data
    pb::create::www::delete::xql -pkg_data $pkg_data -type_data $type_data

    array unset type
}

ad_return_template
