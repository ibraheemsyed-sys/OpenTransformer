export DESIGN_NICKNAME = opentransformer_pe_array
export DESIGN_NAME = pe_array_4x4
export PLATFORM = nangate45

export VERILOG_FILES = \
  /workspaces/OpenTransformer/rtl/mac.sv \
  /workspaces/OpenTransformer/rtl/pe.sv \
  /workspaces/OpenTransformer/rtl/pe_array_4x4.sv

export SDC_FILE = /workspaces/OpenTransformer/openroad/pe_array_constraint.sdc

export CORE_UTILIZATION = 30
export PLACE_DENSITY = 0.35
