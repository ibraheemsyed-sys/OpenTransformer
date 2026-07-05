# Define compiler and flags
VC = verilator
VCFLAGS = -Wall --binary -j 0 --trace

# Directories and files
RTL_DIR = ../rtl
TB_DIR = ../tb
TOP_MODULE = tb_alu_8bit
SRC = $(RTL_DIR)/alu_pkg.sv $(RTL_DIR)/alu_8bit.sv $(TB_DIR)/tb_alu_8bit.sv
all: clean sim

sim:
	@echo "=> Compiling with Verilator..."
	$(VC) $(VCFLAGS) --timing $(SRC) --top-module $(TOP_MODULE) -o sim_executable
	@echo "=> Running Simulation..."
	./obj_dir/sim_executable

wave:
	@echo "=> Opening GTKWave..."
	gtkwave alu_8bit.vcd &

clean:
	@echo "=> Cleaning workspace..."
	rm -rf obj_dir alu_8bit.vcd