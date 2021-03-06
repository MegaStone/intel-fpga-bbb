##
## Extract information from an AFU's JSON file.
##

package require json

##
## Find the JSON file in the project.  The file must have been added with
## set_global_assignment in the MISC_FILE namespace.
##
## The function returns the first JSON file found.
##
proc get_afu_json_file {} {
    set misc_file_col [get_all_global_assignments -name MISC_FILE]
    foreach_in_collection misc_file $misc_file_col {
        set fn [lindex $misc_file 2]
        if {[string match -nocase *.json $fn]} {
            return $fn
        }
    }
    return ""
}

##
## Given the path of an AFU JSON file return a Tcl dictionary with the contents.
##
proc afu_json_file_to_dict {json_path} {
    set d [dict create]
    if {$json_path != ""} {
        set f [open $json_path]
        set d [::json::json2dict [read $f]]
    }
    return $d
}

##
## Given a Tcl dictionary loaded from JSON, return the user clock low
## frequency (MHz).
##
## Returns 0 if no frequency is set.
##
proc afu_get_clock_frequency_low {json_dict} {
    if ([dict exists $json_dict afu-image clock-frequency-low]) {
        return [dict get $json_dict afu-image clock-frequency-low]
    }

    return 0
}

##
## Given a Tcl dictionary loaded from JSON, return the user clock high
## frequency (MHz).
##
## Returns 0 if no frequency is set.
##
proc afu_get_clock_frequency_high {json_dict} {
    if ([dict exists $json_dict afu-image clock-frequency-high]) {
        return [dict get $json_dict afu-image clock-frequency-high]
    }

    return 0
}

##
## Return a list of user clock frequencies requested in the AFU's JSON file.
## Index 0 is the low frequency, index 1 is the high frequency.  If no
## JSON file is set in the project (as a MISC_FILE) or the frequency is not
## specified in the JSON, 0 is returned for a missing entry.  (The
## returned list is always length 2.)
##
proc get_afu_json_user_clock_frequencies {} {
    # Path of the JSON file (or empty string if not defined)
    set jf [get_afu_json_file]
    # JSON as a Tcl dictionary.  (Empty if no JSON file is in the project.)
    set jd [afu_json_file_to_dict $jf]

    set freqs {}
    lappend freqs [afu_get_clock_frequency_low $jd]
    lappend freqs [afu_get_clock_frequency_high $jd]
    return $freqs
}
