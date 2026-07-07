# OpenTransformer

A personal hardware design project exploring how transformer-based machine learning workloads can be mapped into digital hardware using SystemVerilog.

## Motivation

I started OpenTransformer to better understand the connection between machine learning algorithms and the hardware that executes them. My goal is to learn computer architecture and hardware acceleration by building digital components step by step, starting from basic logic and gradually moving toward more complex hardware systems.

This project focuses on understanding how data moves through hardware, how designs are verified, and the architectural decisions involved in building efficient computing systems.

## Current Progress

This project is being developed incrementally, starting from basic digital logic and moving toward more complex hardware systems. Progress updates, implementation details, debugging notes, and simulation results are documented in the [Development Log](notes/daily_log.md).

## Tools Used

- **Hardware Description Language:** SystemVerilog
- **Simulation & Linting:** Verilator
- **Waveform Analysis:** WaveTrace (VS Code Extension)
- **Build System:** GNU Make
- **Development Environment:** Linux (WSL2/Codespaces)

## Repository Structure

```text
.
├── rtl/
│   ├── alu_pkg.sv        # Shared ALU operation definitions
│   ├── alu_8bit.sv       # 8-bit combinational ALU module
│   └── and_gate.sv       # Initial toolchain verification module
│
├── tb/
│   ├── tb_alu_8bit.sv    # ALU verification testbench
│   └── tb_and_gate.sv    # AND gate verification testbench
│
├── sim/
│   └── Makefile          # Simulation build commands
│
├── notes/
│   └── daily_log.md      # Development notes and troubleshooting
│
└── README.md
```

## Development Roadmap

This project is being developed step by step, starting with fundamental digital logic and gradually exploring the hardware concepts used in machine learning accelerators.

### Completed

- [x] Set up SystemVerilog simulation environment
- [x] Verify basic combinational logic designs
- [x] Build and test an 8-bit ALU
- [x] Learn package-based organization and verification practices

### Next Steps

- [ ] Add sequential logic components (clocking, resets, registers)
- [ ] Build larger datapath components
- [ ] Explore memory interfaces and control logic
- [ ] Study hardware structures used in transformer workloads
- [ ] Experiment with FPGA synthesis and hardware testing

## Project Goals

Long term, this project aims to build a stronger understanding of:

- Computer architecture
- Digital design and verification
- Hardware acceleration for machine learning
- Hardware/software co-design

The focus is on learning how efficient computing systems are designed by building, testing, and improving hardware components over time.
