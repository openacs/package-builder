ad_library {
    Package Builder procs
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07
}

namespace eval pb::create::info {}

ad_proc -public pb::create::info::create {
    -pkg_data:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-07

    Creates the package info script
} {
    array set pkg $pkg_data
    set result [subst {<?xml version="1.0"?>
<!-- Generated by the OpenACS Package Manager -->

<package key="$pkg(key)" url="http://openacs.org/repository/apm/packages/$pkg(key)" type="apm_application">
    <package-name>$pkg(pretty_name)</package-name>
    <pretty-plural>$pkg(pretty_plural)</pretty-plural>
    <initial-install-p>f</initial-install-p>
    <singleton-p>f</singleton-p>

    <version name="0.01d1" url="http://openacs.org/repository/download/apm/$pkg(key)-0.01d1.apm">
    <database-support>
        <database>postgresql</database>
    </database-support>
        <owner url="mailto:$pkg(owner_email)">$pkg(owner_name)</owner>
        <summary>$pkg(summary)</summary>
        <release-date>$pkg(date)</release-date>
	<maturity>0</maturity>
        <vendor url="$pkg(vendor_url)">$pkg(vendor_name)</vendor>
        <description format="text/plain">$pkg(description)</description>
        <provides url="$pkg(key)" version="0.01d1"/>
        <requires url="acs-kernel" version="5.0d13"/>
        <requires url="acs-templating" version="4.1.2"/>
        <requires url="acs-content-repository" version="5.1.4d3"/>
	
	 <callbacks>
            <callback type="after-install"  proc="$pkg(short_name)::install::create_install"/>
	    <callback type="after-instantiate"  proc="$pkg(short_name)::install::package_instantiate"/>
        </callbacks>

        <parameters>
        <!-- No version parameters -->
        </parameters>

    </version>
</package>
    }]

    set f [open "$pkg(path)/$pkg(key)\.info" w]
    puts $f $result
    close $f
}
