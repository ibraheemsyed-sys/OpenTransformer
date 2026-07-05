# Define compiler and flags
VC = verilator
VCFLAGS = -Wall --cc --exe --build -j 0 --trace

# Directories and files
RTL_DIR = ../rtl
TB_DIR = ../tb
TOP_MODULE = tb_and_gate
SRC = $(TB_DIR)/tb_and_gate.sv $(RTL_DIR)/and_gate.sv

all: clean sim

sim:
	@echo "=> Compiling with Verilator..."
	$(VC) $(VCFLAGS) --timing $(SRC) --top-module $(TOP_MODULE) -o sim_executable
	@echo "=> Running Simulation..."
	./obj_dir/sim_executable

wave:
	@echo "=> Opening GTKWave..."
	gtkwave and_gate.vcd &

clean:
	@echo "=> Cleaning workspace..."
	rm -rf obj_dir and_gate.vcd