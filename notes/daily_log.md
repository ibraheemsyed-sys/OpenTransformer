# Dev Log - Jul 4, 2026

## Progress Update

### Week 1: Toolchain Ignition & Baseline AND Gate Verification

**Goal:** Establish a stable WSL2/Codespace toolchain and prove the compilation pipeline works using a basic combinational AND gate.
**Studied:** Nand2Tetris to SystemVerilog (Mentor-Guided + HDLBits)
**HDLBits Practice:** Verilog Language > Basics, Vectors, and Modules. (Focus on bitwise vs logical operators).

**Theory & Concepts:**
- [x] Establish a reliable Ubuntu-22.04 LTS container environment on Windows/Codespaces.
- [x] Verify installation of key tools: Verilator, Yosys, and GTKWave.
- [x] Map Nand2Tetris CHIP logic to SystemVerilog `module` syntax.
- [x] Understand how to write a simple testbench to drive stimuli into a module.

**Tasks Completed:**
- [x] Design a basic synthesizable SystemVerilog combinational logic block 'and_gate.sv'.
- [x] Develop a standard SystemVerilog testbench 'tb_and_gate.sv' checking standard AND operations using initial blocks.
- [x] Construct a basic compilation Makefile to simulate the design with Verilator and output visual GTKWave waveform files.

**Files updated:** `rtl/and_gate.sv`, `tb/tb_and_gate.sv`, `sim/Makefile`
**Commit:** `feat: establish hybrid toolchain and verify baseline and_gate using SystemVerilog testbench`

