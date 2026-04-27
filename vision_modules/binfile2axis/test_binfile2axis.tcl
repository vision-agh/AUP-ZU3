create_project -force test_binfile2axis_project test_binfile2axis_project

add_files -fileset sim_1 -norecurse {
    binfile2axis.sv
    binfile2axis_tb.sv
}
update_compile_order -fileset sim_1

set_property top binfile2axis_tb [get_filesets sim_1]
set_property xsim.simulate.log_all_signals {true} [get_filesets sim_1]
set_property xsim.simulate.runtime {100us} [get_filesets sim_1]

launch_simulation