# Copyright (C) 2025 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: BSD-3-Clause

set overlay_name "base"
set design_name "base"

# Open project if not already open
if {[catch {current_project}]} {
    if {[file exists ./${overlay_name}/${overlay_name}.xpr]} {
        open_project ./${overlay_name}/${overlay_name}.xpr
    } elseif {[file exists ./myproj/project_1.xpr]} {
        open_project ./myproj/project_1.xpr
    } else {
        puts "ERROR: Could not find Vivado project file (${overlay_name}.xpr or project_1.xpr)."
        exit 1
    }
}

set proj_dir [get_property DIRECTORY [current_project]]

# Open block design
set bd_file [get_files ${design_name}.bd]
if {$bd_file ne ""} {
    open_bd_design $bd_file
} else {
    puts "ERROR: Block design ${design_name}.bd not found in project."
    exit 1
}

# Add top wrapper and xdc files
set wrapper_file [make_wrapper -files [get_files ${design_name}.bd] -top]
puts "Generated wrapper at: $wrapper_file"
add_files -norecurse $wrapper_file
set_property top ${design_name}_wrapper [current_fileset]

if {[file exists ./constraints/${design_name}.xdc]} {
    import_files -fileset constrs_1 -norecurse ./constraints/${design_name}.xdc
}
update_compile_order -fileset sources_1

# Set platform properties
set_property platform.default_output_type "sd_card" [current_project]
set_property platform.design_intent.embedded "true" [current_project]
set_property platform.design_intent.server_managed "false" [current_project]
set_property platform.design_intent.external_host "false" [current_project]
set_property platform.design_intent.datacenter "false" [current_project]

# Reset previous failed implementation run if any
reset_run synth_1
reset_run impl_1

# Call implement and write bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 16
wait_on_run impl_1

set run_progress [get_property PROGRESS [get_runs impl_1]]
set run_status [get_property STATUS [get_runs impl_1]]
puts "impl_1 status: $run_status ($run_progress)"
if {$run_progress ne "100%"} {
    puts "ERROR: impl_1 run failed or did not complete."
    exit 1
}

# Generate xsa
write_hw_platform -include_bit -force -fixed ./${overlay_name}.xsa
validate_hw_platform ./${overlay_name}.xsa

# Move and rename bitstream to final location
set impl_dir [get_property DIRECTORY [get_runs impl_1]]
set bit_src [file join $impl_dir "${design_name}_wrapper.bit"]
if {[file exists $bit_src]} {
    file copy -force $bit_src ./${overlay_name}.bit
    puts "Copied $bit_src -> ./${overlay_name}.bit"
} else {
    puts "ERROR: Bitstream file $bit_src not found."
    exit 1
}

# Copy hwh files
set hwh_files [glob -nocomplain [file join $proj_dir *.gen sources_1 bd ${design_name} hw_handoff ${design_name}.hwh]]
if {[llength $hwh_files] == 0} {
    set hwh_files [get_files -quiet ${design_name}.hwh]
}
if {[llength $hwh_files] > 0} {
    set hwh_src [lindex $hwh_files 0]
    file copy -force $hwh_src ./${overlay_name}.hwh
    puts "Copied $hwh_src -> ./${overlay_name}.hwh"
} else {
    puts "WARNING: HWH file for ${design_name} not found."
}

puts "Bitstream build complete."
