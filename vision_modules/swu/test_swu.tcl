create_project -force test_swu_project test_swu_project

add_files -fileset sim_1 -norecurse {
    swu.sv
    swu_tb.sv
    ../binfile2axis/binfile2axis.sv
    ../shift_register/shift_register.sv
}
update_compile_order -fileset sim_1

set_property top swu_tb [get_filesets sim_1]
set_property xsim.simulate.log_all_signals {true} [get_filesets sim_1]
set_property xsim.simulate.runtime {100us} [get_filesets sim_1]

launch_simulation