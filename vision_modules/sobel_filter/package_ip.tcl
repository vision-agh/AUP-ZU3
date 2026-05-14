variable design_name
set design_name create_ip_sobel_filter_project
create_project $design_name $design_name -part xczu3eg-sfvc784-2-e -force

add_files -fileset sources_1 -norecurse {
    ../shift_register/shift_register.sv
    ../swu/swu.sv
    sobel_filter.sv
}

set_property file_type {SystemVerilog} [get_files -of_objects [get_filesets sources_1] *.sv]
update_compile_order -fileset sources_1
set_property top sobel_filter [current_fileset]
ipx::package_project -root_dir ./ip_repo -vendor user.org -library user -taxonomy /UserIP -import_files