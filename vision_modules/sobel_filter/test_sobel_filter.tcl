create_project -force test_sobel_filter_project test_sobel_filter_project

add_files -fileset sources_1 -norecurse {
    ../shift_register/shift_register.sv
    ../swu/swu.sv
    sobel_filter.sv
}
update_compile_order -fileset sources_1

add_files -fileset sim_1 -norecurse {
    sobel_filter_tb.sv
    ../binfile2axis/binfile2axis.sv
}
update_compile_order -fileset sim_1

set_property top sobel_filter_tb [get_filesets sim_1]
set_property xsim.simulate.log_all_signals {true} [get_filesets sim_1]
set_property xsim.simulate.runtime {100us} [get_filesets sim_1]

launch_simulation