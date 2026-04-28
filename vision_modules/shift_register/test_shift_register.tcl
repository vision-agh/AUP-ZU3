create_project -force test_shift_register_project test_shift_register_project

add_files -fileset sim_1 -norecurse {
    shift_register.sv
    shift_register_tb.sv
}
update_compile_order -fileset sim_1

set_property top shift_register_tb [get_filesets sim_1]
set_property xsim.simulate.log_all_signals {true} [get_filesets sim_1]
set_property xsim.simulate.runtime {100us} [get_filesets sim_1]

launch_simulation