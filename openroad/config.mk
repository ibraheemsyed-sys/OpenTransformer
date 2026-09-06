export DESIGN_NICKNAME = opentransformer
export DESIGN_NAME = matmul_16x16
export PLATFORM    = nangate45

export VERILOG_FILES = \
  /workspaces/OpenTransformer/rtl/mac.sv \
  /workspaces/OpenTransformer/rtl/pe.sv \
  /workspaces/OpenTransformer/rtl/pe_array_4x4.sv \
  /workspaces/OpenTransformer/rtl/tile_controller.sv \
  /workspaces/OpenTransformer/rtl/matmul_16x16.sv

export SDC_FILE = /workspaces/OpenTransformer/openroad/constraint.sdc

export CORE_UTILIZATION = 35
export PLACE_DENSITY = 0.45

# Needed because matmul_16x16 has inferred matrix memories larger than default 4096 bits.
export SYNTH_MEMORY_MAX_BITS = 32768
