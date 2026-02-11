read_libs /home/install/FOUNDRY/digital/90nm/lib/slow.lib

#Input files

read_hdl counbter.v

elaborate counter 

read_sdc constraints_top.sdc

set_db syn_generic_effort medium

syn_generic
 
set_db syn_map_effort medium

syn_map

set_db syn_opt_effort medium

syn_opt

#Reports

report_timing > counter_timing.rep
report_area > counter_area.rep
report_power > counter_power.rep
report_gate > counter_gate.rep

#Output files

write_hdl > counter_netlist.v
write_sdc > constraints_top_output.sdc

exit