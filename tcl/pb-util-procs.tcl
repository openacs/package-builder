ad_library {
    Package Builder procs
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07
}

namespace eval pb::util {}

ad_proc -public pb::util::package_exists {
    -key:required
    -pretty_name:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-09

    Checks if package already exists in filesystem.
    This protects against overwriting existing packages.
} {
    if {[empty_string_p $key]} {
	regsub -all { } [string tolower $pretty_name] {-} key
    }
    return [file exists "[acs_root_dir]/packages/$key"]
}
