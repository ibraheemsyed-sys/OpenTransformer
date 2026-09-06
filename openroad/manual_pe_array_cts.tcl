read_liberty /OpenROAD-flow-scripts/flow/platforms/nangate45/lib/NangateOpenCellLibrary_typical.lib
read_db /work/results/nangate45/opentransformer_pe_array/base/3_place.odb
read_sdc /work/results/nangate45/opentransformer_pe_array/base/3_place.sdc

source /OpenROAD-flow-scripts/flow/platforms/nangate45/setRC.tcl

clock_tree_synthesis -sink_clustering_enable -repair_clock_nets
estimate_parasitics -placement
detailed_placement
estimate_parasitics -placement

write_db /work/results/nangate45/opentransformer_pe_array/base/4_1_cts.odb
write_db /work/results/nangate45/opentransformer_pe_array/base/4_cts.odb
write_sdc -no_timestamp /work/results/nangate45/opentransformer_pe_array/base/4_1_cts.sdc
write_sdc -no_timestamp /work/results/nangate45/opentransformer_pe_array/base/4_cts.sdc
write_def /work/results/nangate45/opentransformer_pe_array/base/4_cts.def

puts "=== MANUAL CTS AREA ==="
report_design_area

puts "=== MANUAL CTS MAX TIMING ==="
report_checks -path_delay max -fields {slew cap input nets fanout}

puts "=== MANUAL CTS MIN TIMING ==="
report_checks -path_delay min -fields {slew cap input nets fanout}

puts "=== MANUAL CTS SLACK/TNS ==="
report_worst_slack -max
report_worst_slack -min
report_tns -max
report_tns -min

exit
